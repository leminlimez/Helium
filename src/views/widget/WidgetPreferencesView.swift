//
//  WidgetPreferencesView.swift
//  Helium UI
//
//  Created by lemin on 10/18/23.
//

import Foundation
import SwiftUI

struct WidgetPreferencesView: View {
    @Binding var widgetStruct: WidgetStruct
    @State var text: String = ""
    @State var intSelection: Int = 0
    
    var body: some View {
        VStack {
            switch (widgetStruct.module) {
            case .date:
                // MARK: Date Format Textbox
                HStack {
                    Text("Date Format")
                        .bold()
                    Spacer()
                    TextField("E MMM dd", text: $text)
                        .frame(maxWidth: 120)
                        .multilineTextAlignment(.trailing)
                        .onAppear {
                            if let format = widgetStruct.config["dateFormat"] as? String {
                                text = format
                            } else {
                                text = "E MMM dd"
                            }
                        }
                }
            case .network:
                // MARK: Network Choice
                HStack {
                    Text("Network Type")
                        .bold()
                    Spacer()
                    Picker(selection: $intSelection, label: Text("Network Type")) {
                        Text("Down").tag(0)
                        Text("Up").tag(1)
                    }
                    .onAppear {
                        if let netUp = widgetStruct.config["isUp"] as? Bool {
                            intSelection = netUp ? 1 : 0
                        } else {
                            intSelection = 0
                        }
                    }
                }
            case .battery:
                // MARK: Battery Value Type
                HStack {
                    Text("Battery Option")
                        .bold()
                    Spacer()
                    Picker(selection: $intSelection, label: Text("Battery Option")) {
                        Text("Watts").tag(0)
                        Text("Charging Current").tag(1)
                        Text("Amperage").tag(2)
                        Text("Charge Cycles").tag(3)
                    }
                    .onAppear {
                        if let batteryType = widgetStruct.config["batteryValueType"] as? Int {
                            intSelection = batteryType
                        } else {
                            intSelection = 0
                        }
                    }
                }
            default:
                Text("No Configurable Aspects")
            }
        }
        .padding(.horizontal, 15)
        .onChange(of: text) { newText in
            // MARK: Changing Text
            switch(widgetStruct.module) {
            case .date:
                // MARK: Date Format Handling
                if newText == "" {
                    widgetStruct.config["dateFormat"] = nil
                } else {
                    widgetStruct.config["dateFormat"] = text
                }
            default:
                return
            }
            widgetStruct.modified = true
        }
        .onChange(of: intSelection) { newInt in
            // MARK: Changing Integer
            switch(widgetStruct.module) {
            case .network:
                // MARK: Network Choice Handling
                widgetStruct.config["isUp"] = newInt == 1 ? true : false
            case .battery:
                // MARK: Battery Value Type Handling
                widgetStruct.config["batteryValueType"] = newInt
            default:
                return
            }
            widgetStruct.modified = true
        }
    }
}
