//
//  WidgetManager.swift
//
//
//  Created by lemin on 10/16/23.
//

import Foundation
import SwiftUI

enum WidgetModule: Int, CaseIterable {
    case date = 1
    case network = 2
    case temperature = 3
    case battery = 4
    case time = 5
    case text = 6
}

struct WidgetIDStruct: Identifiable, Equatable {
    static func == (lhs: WidgetIDStruct, rhs: WidgetIDStruct) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id = UUID()
    
    var module: WidgetModule
    var config: [String: Any]
}

struct BlurDetailsStruct: Identifiable, Equatable {
    static func == (lhs: BlurDetailsStruct, rhs: BlurDetailsStruct) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id = UUID()
    
    var hasBlur: Bool
    var cornerRadius: Int
}

struct ColorDetailsStruct: Identifiable {
    var id = UUID()
    
    var usesCustomColor: Bool
    var dynamicColor: Bool
}

struct WidgetSetStruct: Identifiable, Equatable {
    static func == (lhs: WidgetSetStruct, rhs: WidgetSetStruct) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id = UUID()
    
    var anchor: Int
    var offsetX: Double
    var offsetY: Double
    var autoResizes: Bool
    var scale: Double
    
    var widgetIDs: [WidgetIDStruct]
    
    var blurDetails: BlurDetailsStruct
    
    // var colorDetails: ColorDetailsStruct
    
    var textAlpha: Double
    var textAlignment: Int
    var fontSize: Double
}

// MARK: Widget Manager Class
class WidgetManager: ObservableObject {
    @Published var widgetSets: [WidgetSetStruct]

    init(widgetSets: [WidgetSetStruct]) {
        self.widgetSets = widgetSets
    }
    
    convenience init() {
        self.init(widgetSets: [])
        self.widgetSets = getWidgetSets()
    }
    
    // get the list of widget sets
    public func getWidgetSets() -> [WidgetSetStruct] {
        let defaults = UserDefaults.standard
        var sets: [WidgetSetStruct] = []
        
        if let dict: [[String: Any]] = defaults.array(forKey: "widgetProperties", forPath: USER_DEFAULTS_PATH) as? [[String: Any]] {
            for s in dict {
                // get the list of widget ids
                var widgetIDs: [WidgetIDStruct] = []
                if let ids = s["widgetIDs"] as? [[String: Any]] {
                    for w in ids {
                        var widgetID: Int = 0
                        var config: [String: Any] = [:]
                        for k in w.keys {
                            if k == "widgetID" {
                                widgetID = w[k] as? Int ?? 0
                            } else {
                                config[k] = w[k]
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
                            widgetIDs.append(.init(module: module, config: config))
                        }
                    }
                }
                let blurDetails: [String: Any] = s["blurDetails"] as? [String: Any] ?? [:]
                let blurDetailsStruct: BlurDetailsStruct = .init(
                    hasBlur: blurDetails["hasBlur"] as? Bool ?? false,
                    cornerRadius: blurDetails["cornerRadius"] as? Int ?? 4
                )
                // create the object
                sets.append(.init(
                    anchor: s["anchor"] as? Int ?? 0,
                    offsetX: s["offsetX"] as? Double ?? 10.0,
                    offsetY: s["offsetY"] as? Double ?? 0.0,
                    autoResizes: s["autoResizes"] as? Bool ?? false,
                    scale: s["scale"] as? Double ?? 100.0,
                    
                    widgetIDs: widgetIDs,
                    
                    blurDetails: blurDetailsStruct,
                    
                    textAlpha: s["textAlpha"] as? Double ?? 1.0,
                    textAlignment: s["textAlignment"] as? Int ?? 1,
                    fontSize: s["fontSize"] as? Double ?? 10.0
                ))
            }
        }
        
        return sets
    }
    
    // save widget sets
    public func saveWidgetSets() {
        let defaults = UserDefaults.standard
        var dict: [[String: Any]] = []
        
        for s in widgetSets {
            var wSet: [String: Any] = [:]
            wSet["anchor"] = s.anchor
            wSet["offsetX"] = s.offsetX
            wSet["offsetY"] = s.offsetY
            wSet["autoResizes"] = s.autoResizes
            wSet["scale"] = s.scale
            
            var widgetIDs: [[String: Any]] = []
            for w in s.widgetIDs {
                var widget: [String: Any] = [:]
                widget["widgetID"] = w.module.rawValue
                for c in w.config.keys {
                    widget[c] = w.config[c]
                }
                widgetIDs.append(widget)
            }
            wSet["widgetIDs"] = widgetIDs
            
            let blurDetails: [String: Any] = [
                "hasBlur": s.blurDetails.hasBlur,
                "cornerRadius": s.blurDetails.cornerRadius
            ]
            wSet["blurDetails"] = blurDetails
            
            wSet["textAlpha"] = s.textAlpha
            wSet["textAlignment"] = s.textAlignment
            wSet["fontSize"] = s.fontSize
            
            dict.append(wSet)
        }
        
        // save it to user defaults
        if dict.count > 0 {
            defaults.setValue(dict, forKey: "widgetProperties", forPath: USER_DEFAULTS_PATH)
        } else {
            // remove from the defaults
            defaults.removeObject(forKey: "widgetProperties", forPath: USER_DEFAULTS_PATH)
        }
    }
    
    // MARK: Widget Modification Management
    // adding widgets
    public func addWidget(widgetSet: WidgetSetStruct, module: WidgetModule, config: [String: Any], save: Bool = true) {
        for (i, wSet) in widgetSets.enumerated() {
            if wSet == widgetSet {
                widgetSets[i].widgetIDs.append(.init(module: module, config: config))
            }
        }
        if save { saveWidgetSets(); }
    }
    
    public func addWidget(widgetSet: WidgetSetStruct, module: WidgetModule, save: Bool = true) {
        let config: [String: Any] = [:]
        addWidget(widgetSet: widgetSet, module: module, config: config, save: save)
    }
    
    // removing widgets
    public func removeWidget(widgetSet: WidgetSetStruct, id: Int, save: Bool = true) {
        for (i, wSet) in widgetSets.enumerated() {
            if wSet == widgetSet {
                widgetSets[i].widgetIDs.remove(at: id)
            }
        }
        if save { saveWidgetSets(); }
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
        case .time:
            return ("Time", "14:57:05")
        case .text:
            return ("Text Label", "Example")
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
