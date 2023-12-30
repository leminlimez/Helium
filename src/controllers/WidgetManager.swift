//
//  WidgetManager.swift
//
//
//  Created by lemin on 10/16/23.
//

import Foundation
import SwiftUI

enum WidgetModule: Int, CaseIterable {
    case dateWidget = 1
    case timeWidget = 5
    
    case network = 2
    
    case battery = 4
    case currentCapacity = 7
    case temperature = 3
    
    case textWidget = 6
    case weather = 8
}

struct WidgetIDStruct: Identifiable, Equatable {
    static func == (lhs: WidgetIDStruct, rhs: WidgetIDStruct) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id = UUID()
    
    var module: WidgetModule
    var config: [String: Any]
    var modified: Bool = false
}

struct BlurDetailsStruct: Identifiable, Equatable {
    static func == (lhs: BlurDetailsStruct, rhs: BlurDetailsStruct) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id = UUID()
    
    var hasBlur: Bool
    var cornerRadius: Double // Int when saving, Double for runtime convenience
    var blurAlpha: Double
}

struct ColorDetailsStruct: Identifiable, Equatable {
    static func == (lhs: ColorDetailsStruct, rhs: ColorDetailsStruct) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id = UUID()
    
    var usesCustomColor: Bool = false
    var color: UIColor = .white
//    var dynamicColor: Bool
}

struct WidgetSetStruct: Identifiable, Equatable {
    static func == (lhs: WidgetSetStruct, rhs: WidgetSetStruct) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    var id = UUID()
    
    var title: String
    
    var anchor: Int
    var offsetX: Double
    var offsetY: Double
    var autoResizes: Bool
    var scale: Double
    
    var widgetIDs: [WidgetIDStruct]
    
    var blurDetails: BlurDetailsStruct
    
    var colorDetails: ColorDetailsStruct = .init()
    
    var fontName: String
    var textBold: Bool
    var textItalic: Bool
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
                    cornerRadius: blurDetails["cornerRadius"] as? Double ?? 4,
                    blurAlpha: blurDetails["blurAlpha"] as? Double ?? 1.0
                )
                let colorDetails: [String: Any] = s["colorDetails"] as? [String: Any] ?? [:]
                let selectedColor: UIColor = UIColor.getColorFromData(data: colorDetails["color"] as? Data) ?? UIColor.white
                let colorDetailsStruct: ColorDetailsStruct = .init(
                    usesCustomColor: colorDetails["usesCustomColor"] as? Bool ?? false,
                    color: selectedColor
                )
                // create the object
                var widgetSet: WidgetSetStruct = .init(
                    title: s["title"] as? String ?? NSLocalizedString("Untitled", comment: ""),
                    anchor: s["anchor"] as? Int ?? 0,
                    offsetX: s["offsetX"] as? Double ?? 10.0,
                    offsetY: s["offsetY"] as? Double ?? 0.0,
                    autoResizes: s["autoResizes"] as? Bool ?? false,
                    scale: s["scale"] as? Double ?? 100.0,
                    
                    widgetIDs: widgetIDs,
                    
                    blurDetails: blurDetailsStruct,
                    
                    fontName: s["fontName"] as? String ?? "Default Font",
                    textBold: s["textBold"] as? Bool ?? false,
                    textItalic: s["textItalic"] as? Bool ?? false,
                    textAlignment: s["textAlignment"] as? Int ?? 1,
                    fontSize: s["fontSize"] as? Double ?? 10.0
                )
                widgetSet.colorDetails = colorDetailsStruct
                sets.append(widgetSet)
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
            wSet["title"] = s.title
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
                "cornerRadius": Int(s.blurDetails.cornerRadius),
                "blurAlpha": s.blurDetails.blurAlpha
            ]
            wSet["blurDetails"] = blurDetails
            
            let colorDetails: [String: Any] = [
                "usesCustomColor": s.colorDetails.usesCustomColor,
                "color": s.colorDetails.color.data as Any
            ]
            wSet["colorDetails"] = colorDetails
            
            wSet["fontName"] = s.fontName
            wSet["textBold"] = s.textBold
            wSet["textItalic"] = s.textItalic
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
    public func addWidget(widgetSet: WidgetSetStruct, module: WidgetModule, config: [String: Any], save: Bool = true) -> WidgetIDStruct {
        let newWidget: WidgetIDStruct = .init(module: module, config: config)
        for (i, wSet) in widgetSets.enumerated() {
            if wSet == widgetSet {
                widgetSets[i].widgetIDs.append(newWidget)
            }
        }
        if save { saveWidgetSets(); }
        return newWidget
    }
    
    public func addWidget(widgetSet: WidgetSetStruct, module: WidgetModule, save: Bool = true) -> WidgetIDStruct {
        let config: [String: Any] = [:]
        return addWidget(widgetSet: widgetSet, module: module, config: config, save: save)
    }
    
    // removing widgets
    // remove at index in list
    public func removeWidget(widgetSet: WidgetSetStruct, id: Int, save: Bool = true) {
        for (i, wSet) in widgetSets.enumerated() {
            if wSet == widgetSet {
                widgetSets[i].widgetIDs.remove(at: id)
            }
        }
        if save { saveWidgetSets(); }
    }

    // move widgets
    // move at index in list
    public func moveWidget(widgetSet: WidgetSetStruct, source: IndexSet, destination: Int) {
        for (i, wSet) in widgetSets.enumerated() {
            if wSet == widgetSet {
                widgetSets[i].widgetIDs.move(fromOffsets: source, toOffset: destination)
            }
        }
    }
    
    // remove based on object
    public func removeWidget(widgetSet: WidgetSetStruct, id: WidgetIDStruct, save: Bool = true) {
        for (i, wID) in widgetSet.widgetIDs.enumerated() {
            if wID == id {
                removeWidget(widgetSet: widgetSet, id: i, save: save)
                break
            }
        }
    }
    
    // update widget config
    public func updateWidgetConfig(widgetSet: WidgetSetStruct, id: WidgetIDStruct, newID: WidgetIDStruct, save: Bool = true) {
        for (i, wSet) in widgetSets.enumerated() {
            if wSet == widgetSet {
                for (j, wID) in wSet.widgetIDs.enumerated() {
                    if wID == id {
                        widgetSets[i].widgetIDs[j].config = newID.config
                        if save { saveWidgetSets(); }
                        return
                    }
                }
            }
        }
    }
    
    // MARK: Widget Set Modification Management
    // adding widget sets
    public func addWidgetSet(widgetSet: WidgetSetStruct, save: Bool = true) {
        widgetSets.append(widgetSet)
        if save { saveWidgetSets(); }
    }
    
    // removing widget sets
    public func removeWidgetSet(widgetSet: WidgetSetStruct, save: Bool = true) {
        for (i, wSet) in widgetSets.enumerated() {
            if widgetSet == wSet {
                widgetSets.remove(at: i)
                break
            }
        }
        if save { saveWidgetSets(); }
    }
    
    // creating a new widget set
    public func createWidgetSet(title: String, anchor: Int = 0, save: Bool = true) {
        // create a widget set with the default values
        addWidgetSet(widgetSet: .init(
            title: title,
            
            anchor: anchor,
            offsetX: anchor == 1 ? 0.0 : 10.0,
            offsetY: 0.0,
            autoResizes: true,
            scale: 100.0,
            
            widgetIDs: [],
            
            blurDetails: .init(
                hasBlur: false,
                cornerRadius: 4,
                blurAlpha: 1.0
            ),
            
            fontName: "Default Font",
            textBold: false,
            textItalic: false,
            textAlignment: 1,
            fontSize: 10.0
        ), save: save)
    }
    
    // editing an existing widget set
    public func editWidgetSet(widgetSet: WidgetSetStruct, newSetDetails ns: WidgetSetStruct, save: Bool = true) {
        for (i, wSet) in widgetSets.enumerated() {
            if wSet == widgetSet {
                widgetSets[i].title = ns.title
                
                widgetSets[i].anchor = ns.anchor
                widgetSets[i].offsetX = ns.offsetX
                widgetSets[i].offsetY = ns.offsetY
                widgetSets[i].autoResizes = ns.autoResizes
                widgetSets[i].scale = ns.scale
                
                widgetSets[i].blurDetails = ns.blurDetails
                
                widgetSets[i].colorDetails = ns.colorDetails
                
                widgetSets[i].fontName = ns.fontName
                widgetSets[i].textBold = ns.textBold
                widgetSets[i].textItalic = ns.textItalic
                widgetSets[i].textAlignment = ns.textAlignment
                widgetSets[i].fontSize = ns.fontSize
                break
            }
        }
        if save { saveWidgetSets(); }
    }
    
    public func getUpdatedWidgetSet(widgetSet: WidgetSetStruct) -> WidgetSetStruct? {
        for wSet in widgetSets {
            if wSet == widgetSet {
                return wSet
            }
        }
        return nil
    }
}

// MARK: Widget Details for Previews
class WidgetDetails {
    // returns Name, Example
    static func getDetails(_ module: WidgetModule) -> (String, String) {
        switch (module) {
        case .dateWidget:
            return (NSLocalizedString("Date", comment: ""), NSLocalizedString("Mon Oct 16", comment: ""))
        case .network:
            return (NSLocalizedString("Network", comment: ""), "▲ 0 KB/s")
        case .temperature:
            return (NSLocalizedString("Device Temperature", comment: ""), "29.34ºC")
        case .battery:
            return (NSLocalizedString("Battery Details", comment: ""), "25 W")
        case .timeWidget:
            return (NSLocalizedString("Time", comment: ""), "14:57:05")
        case .textWidget:
            return (NSLocalizedString("Text Label", comment: ""), NSLocalizedString("Example", comment: ""))
        case .currentCapacity:
            return (NSLocalizedString("Battery Capacity", comment: ""), "50%")
        case .weather:
            return (NSLocalizedString("Weather", comment: ""), "🌤 20℃")
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
