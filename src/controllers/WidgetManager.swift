//
//  WidgetManager.swift
//
//
//  Created by lemin on 10/16/23.
//

import Foundation
import SwiftUI

enum WidgetSide: String {
    case left = "left"
    case center = "center"
    case right = "right"
}

enum WidgetModule: Int, CaseIterable {
    case date = 1
    case network = 2
    case temperature = 3
    case battery = 4
}

struct WidgetStruct: Identifiable {
    var id = UUID()
    var module: WidgetModule
    var config: [String: Any]
    var modified: Bool = false
}

// MARK: Widget Manager Class
class WidgetManager: ObservableObject {
    let widgetSide: WidgetSide
    @Published var widgetStructs: [WidgetStruct]

    init(widgetSide: WidgetSide, widgetStructs: [WidgetStruct]) {
        self.widgetSide = widgetSide
        self.widgetStructs = widgetStructs
    }
    
    convenience init(widgetSide: WidgetSide) {
        self.init(widgetSide: widgetSide, widgetStructs: [])
        self.widgetStructs = getWidgetStructs()
    }
    
    // get the list of widgets
    public func getWidgetStructs() -> [WidgetStruct] {
        let defaults = UserDefaults.standard
        var structs: [WidgetStruct] = []
        
        if let dict: [[String: Any]] = defaults.array(forKey: "\(widgetSide.rawValue)WidgetIDs") as? [[String: Any]] {
            for s in dict {
                var widgetID: Int = 0
                var config: [String: Any] = [:]
                for k in s.keys {
                    if k == "widgetID" {
                        widgetID = s[k] as? Int ?? 0
                    } else {
                        config[k] = s[k]
                    }
                }
                var module: WidgetModule? = nil
                for m in WidgetModule.allCases {
                    if m.rawValue == widgetID {
                        module = m
                        break
                    }
                }
                if let module = module {
                    structs.append(.init(module: module, config: config))
                }
            }
        }
        
        return structs
    }
    
    // save widgets
    public func saveWidgetStructs() {
        let defaults = UserDefaults.standard
        var dict: [[String: Any]] = []
        
        for s in widgetStructs {
            var widget: [String: Any] = [:]
            widget["widgetID"] = s.module.rawValue
            for c in s.config.keys {
                widget[c] = s.config[c]
            }
            dict.append(widget)
        }
        
        // save it to user defaults
        if dict.count > 0 {
            defaults.setValue(dict, forKey: "\(widgetSide.rawValue)WidgetIDs")
        } else {
            // remove from the defaults
            defaults.removeObject(forKey: "\(widgetSide.rawValue)WidgetIDs")
        }
    }
    
    // MARK: Widget Modification Management
    // adding widgets
    public func addWidget(module: WidgetModule, config: [String: Any], save: Bool = true) {
        widgetStructs.append(.init(module: module, config: config))
        if save { saveWidgetStructs(); }
    }
    
    public func addWidget(module: WidgetModule, save: Bool = true) {
        let config: [String: Any] = [:]
        addWidget(module: module, config: config, save: save)
    }
    
    // removing widgets
    public func removeWidget(id: Int, save: Bool = true) {
        widgetStructs.remove(at: id)
        if save { saveWidgetStructs(); }
    }
}

// MARK: Widget Details for Previews
class WidgetDetails {
    // returns Name, Example
    static func getDetails(_ module: WidgetModule) -> (String, String) {
        switch (module) {
        case .date:
            return ("Date", "Mon Oct 16")
        case .network:
            return ("Network", "▲ 0 KB/s")
        case .temperature:
            return ("Device Temperature", "29.34ºC")
        case .battery:
            return ("Battery Details", "25 W")
        default:
            return ("UNKNOWN", "(null)")
        }
    }
    
    // return Name
    static func getWidgetName(_ module: WidgetModule) -> String {
        let (name, _) = getDetails(module)
        return name
    }
    
    // return example
    static func getWidgetExample(_ module: WidgetModule) -> String {
        let (_, example) = getDetails(module)
        return example
    }
}
