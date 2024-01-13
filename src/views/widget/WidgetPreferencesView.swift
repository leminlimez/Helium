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
    @State var intSelection2: Int = 0
    @State var intSelection3: Int = 1
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
                // MARK: Network Type Choice
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
                // MARK: Speed Icon Choice
                HStack {
                    Text("Speed Icon").foregroundColor(.primary).bold()
                    Spacer()
                    Picker(selection: $intSelection2) {
                        Text(intSelection == 0 ? "▼" : "▲").tag(0)
                        Text(intSelection == 0 ? "↓" : "↑").tag(1)
                    } label: {}
                    .pickerStyle(.menu)
                    .onAppear {
                        if let speedIcon = widgetID.config["speedIcon"] as? Int {
                            intSelection2 = speedIcon
                        } else {
                            intSelection2 = 0
                        }
                    }
                }
                // MARK: Minimum Unit Choice
                HStack {
                    Text("Minimum Unit").foregroundColor(.primary).bold()
                    Spacer()
                    Picker(selection: $intSelection3) {
                        Text("b").tag(0)
                        Text("Kb").tag(1)
                        Text("Mb").tag(2)
                        Text("Gb").tag(3)
                    } label: {}
                    .pickerStyle(.menu)
                    .onAppear {
                        if let minUnit = widgetID.config["minUnit"] as? Int {
                            intSelection3 = minUnit
                        } else {
                            intSelection3 = 1
                        }
                    }
                }
                // MARK: Hide Speed When Zero
                Toggle(isOn: $boolSelection) {
                    Text("Hide Speed When 0")
                        .foregroundColor(.primary)
                        .bold()
                }
                .onAppear {
                    boolSelection = widgetID.config["hideSpeedWhenZero"] as? Bool ?? false
                }
            case .temperature:
                // MARK: Battery Temperature Value
                HStack {
                    Text("Temperature Unit").foregroundColor(.primary).bold()
                    Spacer()
                    Picker(selection: $intSelection) {
                        Text("Celcius").tag(0)
                        Text("Fahrenheit").tag(1)
                    } label: {}
                        .pickerStyle(.menu)
                        .onAppear {
                            if widgetID.config["useFahrenheit"] as? Bool ?? false == true {
                                intSelection = 1
                            } else {
                                intSelection = 0
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
            case .chargeSymbol:
                // MARK: Charge Symbol Fill Option
                HStack {
                    Toggle(isOn: $boolSelection) {
                        Text("Fill Symbol")
                            .foregroundColor(.primary)
                            .bold()
                    }
                    .onAppear {
                        boolSelection = widgetID.config["filled"] as? Bool ?? true
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
        .onChange(of: intSelection2) { _ in
            modified = true
        }
        .onChange(of: intSelection3) { _ in
            modified = true
        }
        .onChange(of: boolSelection) { _ in
            modified = true
        }
    }
    
    func getFormattedDate(_ format: String) -> String {
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
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
        case .textWidget:
            // MARK: Custom Text Handling
            if text == "" {
                widgetStruct.config["text"] = nil
            } else {
                widgetStruct.config["text"] = text
            }
        
        // MARK: Changing Integer
        case .network:
            // MARK: Network Choices Handling
            widgetStruct.config["isUp"] = intSelection == 1 ? true : false
            widgetStruct.config["speedIcon"] = intSelection2
            widgetStruct.config["minUnit"] = intSelection3
            widgetStruct.config["hideSpeedWhenZero"] = boolSelection
        case .temperature:
            // MARK: Temperature Unit Handling
            widgetStruct.config["useFahrenheit"] = intSelection == 1 ? true : false
        case .battery:
            // MARK: Battery Value Type Handling
            widgetStruct.config["batteryValueType"] = intSelection
        case .timeWidget:
            // MARK: Time Format Handling
            widgetStruct.config["dateFormat"] = timeFormats[intSelection]
        
        // MARK: Changing Boolean
        case .currentCapacity:
            // MARK: Current Capacity Handling
            widgetStruct.config["showPercentage"] = boolSelection
        case .chargeSymbol:
            // MARK: Charge Symbol Fill Handling
            widgetStruct.config["filled"] = boolSelection
        default:
            return;
        }
        
        widgetManager.updateWidgetConfig(widgetSet: widgetSet, id: widgetID, newID: widgetStruct)
        widgetID.config = widgetStruct.config
        modified = false
    }
}
