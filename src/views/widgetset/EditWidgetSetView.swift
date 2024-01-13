//
//  EditWidgetSetView.swift
//
//
//  Created by lemin on 12/8/23.
//

import Foundation
import SwiftUI

struct EditWidgetSetView: View {
    @StateObject var widgetManager: WidgetManager
    @State var widgetSet: WidgetSetStruct
    @State var currentWidgetSet: WidgetSetStruct? = nil
    @State var usesAdaptiveColor: Bool = false
    
    @State var showingAddView: Bool = false
    
    @State var nameInput: String = ""
    
    @State var anchorSelection: Int = 0
    @State var anchorYSelection: Int = 0
    @State var offsetX: Double = 10.0
    @State var offsetY: Double = 0.0
    
    @State var autoResizes: Bool = true
    @State var scale: Double = 100.0
    @State var scaleY: Double = 12.0
    
    @State var widgetIDs: [WidgetIDStruct] = []
    @State var updatedWidgetIDs: Bool = false
    
    @State var hasBlur: Bool = false
    @State var cornerRadius: Double = 4
    @State var blurStyle: Int = 1
    @State var blurAlpha: Double = 1.0
    
    @State var usesCustomColor: Bool = false
    @State var customColor: Color = .white
    @State var dynamicColor: Bool = true
    
    @State var textBold: Bool = false
    @State var textAlignment: Int = 1
    @State var fontSize: Double = 10.0
    @State var textAlpha: Double = 1.0
    
    @State var changesMade: Bool = false
    
    var body: some View {
        VStack {
            List {
                // MARK: Title Field
                Section {
                    HStack {
                        Text("Widget Set Title")
                            .bold()
                        Spacer()
                        TextField("Title", text: $nameInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: nameInput) { _ in
                                changesMade = true
                            }
                    }
                } header: {
                    Text("Widget Set Details")
                }
                
                Section {
                    // MARK: Anchor Sides
                    HStack {
                        Text("Horizontal Anchor Side").foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $anchorSelection) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                            Text("Right").tag(2)
                        } label: {}
                            .pickerStyle(.menu)
                            .onChange(of: anchorSelection) { _ in
                                changesMade = true
                            }
                    }
                    HStack {
                        Text("Vertical Anchor Side").foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $anchorYSelection) {
                            Text("Top").tag(0)
                            Text("Center").tag(1)
                            Text("Bottom").tag(2)
                        } label: {}
                            .pickerStyle(.menu)
                            .onChange(of: anchorYSelection) { _ in
                                changesMade = true
                            }
                    }
                    // MARK: Offset X
                    VStack {
                        HStack {
                            Text("Offset X")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $offsetX, bounds: -300...300)
                            .onChange(of: offsetX) { _ in
                                changesMade = true
                            }
                    }
                    // MARK: Offset Y
                    VStack {
                        HStack {
                            Text("Offset Y")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $offsetY, bounds: -300...300)
                            .onChange(of: offsetY) { _ in
                                changesMade = true
                            }
                    }
                } header: {
                    Text("Positioning")
                }
                
                Section {
                    // MARK: Auto Resizes
                    HStack {
                        Toggle(isOn: $autoResizes) {
                            Text("Auto Resize")
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: autoResizes) { _ in
                            changesMade = true
                        }
                    }
                    // MARK: Width and Height
                    if !autoResizes {
                        VStack {
                            HStack {
                                Text("Width")
                                    .bold()
                                Spacer()
                            }
                            BetterSlider(value: $scale, bounds: 10...500)
                                .onChange(of: scale) { _ in
                                    changesMade = true
                                }
                        }
                        VStack {
                            HStack {
                                Text("Height")
                                    .bold()
                                Spacer()
                            }
                            BetterSlider(value: $scaleY, bounds: 5...500)
                                .onChange(of: scaleY) { _ in
                                    changesMade = true
                                }
                        }
                    }
                } header: {
                    Text("Size Constraints")
                }
                
                Section {
                    // MARK: Has Blur
                    HStack {
                        Toggle(isOn: $hasBlur) {
                            Text("Background Blur")
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: hasBlur) { _ in
                            changesMade = true
                        }
                    }
                    if hasBlur {
                        // MARK: Blur Style
                        HStack {
                            Text("Blur Style").foregroundColor(.primary).bold()
                            Spacer()
                            Picker(selection: $blurStyle) {
                                Text("Light").tag(0)
                                Text("Dark").tag(1)
                            } label: {}
                                .pickerStyle(.menu)
                                .onChange(of: blurStyle) { _ in
                                    changesMade = true
                                }
                        }
                        // MARK: Blur Corner Radius
                        VStack {
                            HStack {
                                Text("Blur Corner Radius")
                                    .bold()
                                Spacer()
                            }
                            BetterSlider(value: $cornerRadius, bounds: 0...30, step: 1)
                                .onChange(of: cornerRadius) { _ in
                                    changesMade = true
                                }
                        }
                        // MARK: Blur Alpha
                        VStack {
                            HStack {
                                Text("Blur Alpha")
                                    .bold()
                                Spacer()
                            }
                            BetterSlider(value: $blurAlpha, bounds: 0.0...1.0)
                                .onChange(of: blurAlpha) { _ in
                                    changesMade = true
                                }
                        }
                    }
                } header: {
                    Text("Blur")
                }
                
                Section {
                    if !usesAdaptiveColor || !dynamicColor {
                        // MARK: Uses Custom Color
                        HStack {
                            Toggle(isOn: $usesCustomColor) {
                                Text("Custom Text Color")
                                    .bold()
                                    .minimumScaleFactor(0.5)
                            }
                            .onChange(of: usesCustomColor) { _ in
                                changesMade = true
                            }
                        }
                        // MARK: Custom Text Color
                        if usesCustomColor {
                            HStack {
                                Text("Text Color")
                                    .bold()
                                Spacer()
                                ColorPicker("Set Text Color", selection: $customColor)
                                    .labelsHidden()
                                    .onChange(of: customColor) { _ in
                                        changesMade = true
                                    }
                            }
                        }
                    }
                    // MARK: Dynamic Color
                    if usesAdaptiveColor {
                        Toggle(isOn: $dynamicColor) {
                            Text("Adaptive Color")
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: dynamicColor) { _ in
                            changesMade = true
                        }
                    }
                } header: {
                    Text("Text Color")
                }
                
                Section {
                    // MARK: Bold Text
                    HStack {
                        Toggle(isOn: $textBold) {
                            Text("Bold Text")
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: textBold) { _ in
                            changesMade = true
                        }
                    }
                    // MARK: Text Alignment
                    HStack {
                        Text("Text Alignment").foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $textAlignment) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                        } label: {}
                        .pickerStyle(.menu)
                        .onChange(of: textAlignment) { _ in
                            changesMade = true
                        }
                    }
                    // MARK: Font Size
                    VStack {
                        HStack {
                            Text("Font Size")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $fontSize, bounds: 5...50, step: 0.5)
                            .onChange(of: fontSize) { _ in
                                changesMade = true
                            }
                    }
                    // MARK: Text Alpha
                    VStack {
                        HStack {
                            Text("Text Alpha")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $textAlpha, bounds: 0.0...1.0)
                            .onChange(of: textAlpha) { _ in
                                changesMade = true
                            }
                    }
                } header: {
                    Text("Text Properties")
                }
                
                Section {
                    // MARK: Add Widget Button
                    Button(action: {
                        showingAddView.toggle()
                    }) {
                        Text("Add Widget")
                            .buttonStyle(TintedButton(color: .blue, fullWidth: true))
                    }
                    // MARK: Widget IDs
                    ForEach($widgetIDs) { widgetID in
                        NavigationLink(destination: WidgetPreferencesView(widgetManager: widgetManager, widgetSet: widgetSet, widgetID: widgetID)) {
                            HStack {
                                WidgetPreviewsView(widget: widgetID, previewColor: .white)
                                Spacer()
                                // MARK: Configure Widget Button
//                            Button(action: {
//
//                            }) {
//                                Image(systemName: "gear")
//                            }
                                // MARK: Remove Widget ID Button
//                            Button(action: {
//                                // save changes
//                                widgetManager.removeWidget(widgetSet: widgetSet, id: widgetID.wrappedValue, save: false)
//                                saveSet()
//                                widgetIDs = widgetSet.widgetIDs
//                            }) {
//                                Image(systemName: "trash")
//                                    .foregroundColor(.red)
//                            }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { i in
                            UIApplication.shared.confirmAlert(title: "Delete Widget", body: "Are you sure you want to delete this widget?", onOK: {
                                widgetManager.removeWidget(widgetSet: widgetSet, id: widgetIDs[i], save: false)
                                saveSet()
                                widgetIDs.remove(at: i)
                            }, noCancel: false)
                        }
                    }
                } header: {
                    Text("Widgets")
                }
            }
            .toolbar {
                HStack {
                    // MARK: Save Button
                    // only shows up if something is changed
                    if (changesMade) {
                        Button(action: {
                            saveSet()
                        }) {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
            }
            .navigationTitle("Edit Widget")
            .onAppear {
                if currentWidgetSet == widgetSet {
                    return
                }
                usesAdaptiveColor = UserDefaults.standard.bool(forKey: "adaptiveColors", forPath: USER_DEFAULTS_PATH)
                currentWidgetSet = widgetSet
                nameInput = widgetSet.title
                
                anchorSelection = widgetSet.anchor
                anchorYSelection = widgetSet.anchorY
                offsetX = widgetSet.offsetX
                offsetY = widgetSet.offsetY
                
                autoResizes = widgetSet.autoResizes
                scale = widgetSet.scale
                scaleY = widgetSet.scaleY
                
                if !updatedWidgetIDs {
                    widgetIDs = widgetSet.widgetIDs
                    updatedWidgetIDs = true
                }
                
                hasBlur = widgetSet.blurDetails.hasBlur
                cornerRadius = widgetSet.blurDetails.cornerRadius
                blurStyle = widgetSet.blurDetails.styleDark ? 1 : 0
                blurAlpha = widgetSet.blurDetails.alpha
                
                usesCustomColor = widgetSet.colorDetails.usesCustomColor
                customColor = Color(widgetSet.colorDetails.color)
                dynamicColor = widgetSet.colorDetails.dynamicColor
                
                textBold = widgetSet.textBold
                textAlignment = widgetSet.textAlignment
                fontSize = widgetSet.fontSize
                textAlpha = widgetSet.textAlpha
                
                changesMade = false
            }
            .onDisappear {
                if changesMade {
                    if UserDefaults.standard.bool(forKey: "hideSaveConfirmation", forPath: USER_DEFAULTS_PATH) {
                        saveSet()
                    } else {
                        UIApplication.shared.confirmAlert(title: "Save Changes", body: "Would you like to save the changes to your current widget set?", onOK: {
                            saveSet()
                        }, noCancel: false)
                    }
                }
            }
            .sheet(isPresented: $showingAddView, content: {
                WidgetAddView(widgetManager: widgetManager, widgetSet: widgetSet, isOpen: $showingAddView, onChoice: { newWidget in
                    saveSet()
                    widgetIDs.append(newWidget)
                })
            })
        }
    }
    
    func saveSet(save: Bool = true) {
        changesMade = false
        widgetManager.editWidgetSet(widgetSet: widgetSet, newSetDetails: .init(
            title: nameInput,
            
            anchor: anchorSelection,
            anchorY: anchorYSelection,
            offsetX: offsetX,
            offsetY: offsetY,
            
            autoResizes: autoResizes,
            scale: scale,
            scaleY: scaleY,
            
            widgetIDs: [],
            
            blurDetails: .init(
                hasBlur: hasBlur,
                cornerRadius: cornerRadius,
                styleDark: blurStyle == 1 ? true : false,
                alpha: blurAlpha
            ),
            
            colorDetails: .init(
                usesCustomColor: usesCustomColor,
                color: UIColor(customColor),
                dynamicColor: dynamicColor
            ),
            
            textBold: textBold,
            textAlignment: textAlignment,
            fontSize: fontSize,
            textAlpha: textAlpha
        ), save: save)
        let updatedSet = widgetManager.getUpdatedWidgetSet(widgetSet: widgetSet)
        if updatedSet != nil {
            widgetSet = updatedSet!
        }
    }
}
