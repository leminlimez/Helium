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
    
    let timeFormats: [String] = [
        "hh:mm",
        "hh:mm a",
        "hh:mm:ss",
        "HH:mm",
        "HH:mm:ss"
    ]
    
    var body: some View {
        VStack {
            // MARK: Preview
            ZStack {
                Image(uiImage: UIImage(named: "wallpaper")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(1.5)
                    .frame(width: 190, height: 50)
                    .cornerRadius(12)
                    .clipped()
                WidgetPreviewsView(widget: $widgetStruct, previewColor: .white)
            }
            .padding(.bottom, 25)
            
            switch (widgetStruct.module) {
            case .date:
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
                    Picker(selection: $intSelection, label: Text("Network Type").foregroundColor(.primary).bold()) {
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
                    Picker(selection: $intSelection, label: Text("Battery Option").foregroundColor(.primary).bold()) {
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
            case .time:
                // MARK: Time Format Selector
                HStack {
                    Picker(selection: $intSelection, label: Text("Time Format").foregroundColor(.primary).bold()) {
                        Text("5:00         (hh:mm)").tag(0)
                        Text("5:00 PM   (hh:mm a)").tag(1)
                        Text("5:00:00   (hh:mm:ss)").tag(2)
                        Text("17:00       (HH:mm)").tag(3)
                        Text("17:00:00  (HH:mm:ss)").tag(4)
                    }
                    .onAppear {
                        if let timeFormat = widgetStruct.config["dateFormat"] as? String {
                            for i in 0...timeFormats.count {
                                if timeFormat == timeFormats[i] {
                                    intSelection = i
                                    return;
                                }
                            }
                        }
                        intSelection = 0
                    }
                }
            case .text:
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
                            if let format = widgetStruct.config["text"] as? String {
                                text = format
                            } else {
                                text = "Example"
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
            case .time:
                // MARK: time Format Handling
                widgetStruct.config["dateFormat"] = timeFormats[newInt]
            default:
                return
            }
            widgetStruct.modified = true
        }
    }
}
