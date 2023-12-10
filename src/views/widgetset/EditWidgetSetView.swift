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
    
    @State var showingAddView: Bool = false
    
    @State var nameInput: String = ""
    
    @State var anchorSelection: Int! = 0
    @State var offsetX: Double = 10.0
    @State var offsetY: Double = 0.0
    @State var autoResizes: Bool = true
    @State var scale: Double = 100.0
    
    @State var widgetIDs: [WidgetIDStruct] = []
    @State var updatedWidgetIDs: Bool = false
    
    @State var hasBlur: Bool = false
    @State var cornerRadius: Double = 4
    
    @State var usesCustomColor: Bool = false
    @State var customColor: Color = .white
    
    @State var textAlpha: Double = 1.0
    @State var textAlignment: Int = 1
    @State var fontSize: Double = 10.0
    
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
                }
                
                Section {
                    // MARK: Anchor Side
                    HStack {
                        Picker(selection: $anchorSelection, label: Text("Anchor Side").foregroundColor(.primary).bold()) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                            Text("Right").tag(2)
                        }
                        .pickerStyle(.menu)
                        .onChange(of: anchorSelection) { _ in
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
                    // MARK: Width
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
                    }
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
                    // MARK: Blur Corner Radius
                    if hasBlur {
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
                    }
                }
                
                Section {
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
                
                Section {
                    // MARK: Text Alpha
                    VStack {
                        HStack {
                            Text("Text Alpha")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $textAlpha, bounds: 0...1, step: 0.01)
                            .onChange(of: textAlpha) { _ in
                                changesMade = true
                            }
                    }
                    // MARK: Text Alignment
                    HStack {
                        Picker(selection: $textAlignment, label: Text("Text Alignment").foregroundColor(.primary).bold()) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                        }
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
                        HStack {
                            WidgetPreviewsView(widget: widgetID, previewColor: .white)
                            Spacer()
                            // MARK: Configure Widget Button
                            Button(action: {
                                
                            }) {
                                Image(systemName: "gear")
                            }
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
                    .onDelete { indexSet in
                        indexSet.forEach { i in
                            UIApplication.shared.confirmAlert(title: "Delete Widget", body: "Are you sure you want to delete this widget?", onOK: {
                                widgetManager.removeWidget(widgetSet: widgetSet, id: widgetIDs[i], save: false)
                                saveSet()
                                widgetIDs.remove(at: i)
                            }, noCancel: false)
                        }
                    }
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
            .onAppear {
                nameInput = widgetSet.title
                
                anchorSelection = widgetSet.anchor
                offsetX = widgetSet.offsetX
                offsetY = widgetSet.offsetY
                autoResizes = widgetSet.autoResizes
                scale = widgetSet.scale
                
                if !updatedWidgetIDs {
                    widgetIDs = widgetSet.widgetIDs
                    updatedWidgetIDs = true
                }
                
                hasBlur = widgetSet.blurDetails.hasBlur
                cornerRadius = widgetSet.blurDetails.cornerRadius
                
                usesCustomColor = widgetSet.colorDetails.usesCustomColor
                customColor = Color(widgetSet.colorDetails.color)
                
                textAlpha = widgetSet.textAlpha
                textAlignment = widgetSet.textAlignment
                fontSize = widgetSet.fontSize
                
                changesMade = false
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
            offsetX: offsetX,
            offsetY: offsetY,
            autoResizes: autoResizes,
            scale: scale,
            
            widgetIDs: [],
            
            blurDetails: .init(
                hasBlur: hasBlur,
                cornerRadius: cornerRadius
            ),
            
            colorDetails: .init(
                usesCustomColor: usesCustomColor,
                color: UIColor(customColor)
            ),
            
            textAlpha: textAlpha,
            textAlignment: textAlignment,
            fontSize: fontSize
        ), save: save)
        let updatedSet = widgetManager.getUpdatedWidgetSet(widgetSet: widgetSet)
        if updatedSet != nil {
            widgetSet = updatedSet!
        }
    }
}
