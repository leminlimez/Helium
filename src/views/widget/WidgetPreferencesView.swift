//
//  WidgetPreferencesView.swift
//  Helium UI
//
//  Created by lemin on 10/18/23.
//

import Foundation
import SwiftUI

struct WidgetPreferencesView: View {
    @StateObject var widgetManager: WidgetManager
    @State var widgetSet: WidgetSetStruct
    @Binding var widgetID: WidgetIDStruct
    
    @State var text: String = ""
    @State var intSelection: Int = 0
    @State var intSelection_arrow: Int = 0
    @State var boolSelection: Bool = false
    
    @State var modified: Bool = false
    
    let timeFormats: [String] = [
        "hh:mm",
        "hh:mm a",
        "hh:mm:ss",
        "hh",
        
        "HH:mm",
        "HH:mm:ss",
        "HH",
        
        "mm",
        "ss"
    ]
    
    let dateFormatter = DateFormatter()
    let currentDate = Date()
    
    var body: some View {
        VStack {
            // MARK: Preview
            WidgetPreviewsView(widget: $widgetID, previewColor: .white)
            
            switch (widgetID.module) {
            case .dateWidget:
                // MARK: Date Format Textbox
                HStack {
                    Text("Date Format")
                        .foregroundColor(.primary)
                        .bold()
                    Spacer()
                    TextField("E MMM dd", text: $text)
                        .frame(maxWidth: 120)
                        .multilineTextAlignment(.trailing)
                        .onAppear {
                            if let format = widgetID.config["dateFormat"] as? String {
                                text = format
                            } else {
                                text = "E MMM dd"
                            }
                        }
                }
            case .network:
                // MARK: Network Choice
                VStack {
                    HStack {
                        Text("Network Type").foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $intSelection) {
                            Text("Down").tag(0)
                            Text("Up").tag(1)
                        } label: {}
                        .pickerStyle(.menu)
                        .onAppear {
                            if let netUp = widgetID.config["isUp"] as? Bool {
                                intSelection = netUp ? 1 : 0
                            } else {
                                intSelection = 0
                            }
                        }
                    }
                    HStack {
                        Text("Arrow Type").foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $intSelection_arrow) {
                            Text("Triangle").tag(0)
                            Text("Arrow").tag(1)
                        } label: {}
                        .pickerStyle(.menu)
                        .onAppear {
                            if let arrow = widgetID.config["isArrow"] as? Bool {
                                intSelection_arrow = arrow ? 1 : 0
                            } else {
                                intSelection_arrow = 0
                            }
                        }
                    }
                }
            case .battery:
                // MARK: Battery Value Type
                HStack {
                    Text("Battery Option").foregroundColor(.primary).bold()
                    Spacer()
                    Picker(selection: $intSelection) {
                        Text("Watts").tag(0)
                        Text("Charging Current").tag(1)
                        Text("Amperage").tag(2)
                        Text("Charge Cycles").tag(3)
                        Text("Current Capacity").tag(4)
                    } label: {}
                    .pickerStyle(.menu)
                    .onAppear {
                        if let batteryType = widgetID.config["batteryValueType"] as? Int {
                            intSelection = batteryType
                        } else {
                            intSelection = 0
                        }
                    }
                }
            case .timeWidget:
                // MARK: Time Format Selector
                HStack {
                    Picker(selection: $intSelection, label: Text("Time Format").foregroundColor(.primary).bold()) {
                        ForEach(0..<timeFormats.count, id: \.self) { index in
                            Text("\(getFormattedDate(timeFormats[index]))\n(\(timeFormats[index]))").tag(index)
                        }
                    }
                    .onAppear {
                        if let timeFormat = widgetID.config["dateFormat"] as? String {
                            intSelection = timeFormats.firstIndex(of: timeFormat) ?? 0
                        }
                        intSelection = 0
                    }
                }
            case .textWidget:
                // MARK: Custom Text Label Textbox
                HStack {
                    Text("Label Text")
                        .foregroundColor(.primary)
                        .bold()
                    Spacer()
                    TextField("Example", text: $text)
                        .frame(maxWidth: 120)
                        .multilineTextAlignment(.trailing)
                        .onAppear {
                            if let format = widgetID.config["text"] as? String {
                                text = format
                            } else {
                                text = "Example"
                            }
                        }
                }
            case .currentCapacity:
                // MARK: Current Capacity Choice
                HStack {
                    Toggle(isOn: $boolSelection) {
                        Text("Show Percent (%) Symbol")
                            .foregroundColor(.primary)
                            .bold()
                    }
                    .onAppear {
                        boolSelection = widgetID.config["showPercentage"] as? Bool ?? true
                    }
                }
            default:
                Text("No Configurable Aspects")
            }
        }
        .padding(.horizontal, 15)
        .toolbar {
            HStack {
                // MARK: Save Button
                // only shows up if something is changed
                if (modified) {
                    Button(action: {
                        saveChanges()
                    }) {
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
        }
        .onDisappear {
            if modified {
                UIApplication.shared.confirmAlert(title: "Save Changes", body: "Would you like to save changes to the widget?", onOK: {
                    saveChanges()
                }, noCancel: false)
            }
        }
        .onChange(of: text) { _ in
            modified = true
        }
        .onChange(of: intSelection) { _ in
            modified = true
        }
        .onChange(of: intSelection_arrow) { _ in
            modified = true
        }
        .onChange(of: boolSelection) { _ in
            modified = true
        }
    }
    
    func getFormattedDate(_ format: String) -> String {
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "zh_CN")
        return dateFormatter.string(from: currentDate)
    }
    
    func saveChanges() {
        var widgetStruct: WidgetIDStruct = .init(module: widgetID.module, config: widgetID.config)
        
        switch(widgetStruct.module) {
        // MARK: Changing Text
        case .dateWidget:
            // MARK: Date Format Handling
            if text == "" {
                widgetStruct.config["dateFormat"] = nil
            } else {
                widgetStruct.config["dateFormat"] = text
            }
            break;
        case .textWidget:
            // MARK: Custom Text Handling
            if text == "" {
                widgetStruct.config["text"] = nil
            } else {
                widgetStruct.config["text"] = text
            }
            break;
        
        // MARK: Changing Integer
        case .network:
            // MARK: Network Choice Handling
            widgetStruct.config["isUp"] = intSelection == 1 ? true : false
            widgetStruct.config["isArrow"] = intSelection_arrow == 1 ? true : false
            break;
        case .battery:
            // MARK: Battery Value Type Handling
            widgetStruct.config["batteryValueType"] = intSelection
            break;
        case .timeWidget:
            // MARK: Time Format Handling
            widgetStruct.config["dateFormat"] = timeFormats[intSelection]
            break;
        
        // MARK: Changing Boolean
        case .currentCapacity:
            // MARK: Current Capacity Handling
            widgetStruct.config["showPercentage"] = boolSelection
            break;
        default:
            break;
        }
        
        widgetManager.updateWidgetConfig(widgetSet: widgetSet, id: widgetID, newID: widgetStruct)
        widgetID.config = widgetStruct.config
        modified = false
    }
}
