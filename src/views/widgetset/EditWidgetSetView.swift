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
    @State var textItalic: Bool = false
    @State var fontName: String = "Default Font"
    @State var textAlignment: Int = 1
    @State var fontSize: Double = 10.0
    @State var textAlpha: Double = 1.0
    
    @State var changesMade: Bool = false

    private let fonts: [String] = FontUtils.allFontNames()
    
    var body: some View {
        VStack {
            List {
                // MARK: Title Field
                Section {
                    HStack {
                        Text(NSLocalizedString("Widget Set Title", comment: ""))
                            .bold()
                        Spacer()
                        TextField(NSLocalizedString("Title", comment: ""), text: $nameInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: nameInput) { _ in
                                changesMade = true
                            }
                    }
                } header: {
                    Text(NSLocalizedString("Widget Set Details", comment: ""))
                }
                
                Section {
                    // MARK: Anchor Sides
                    HStack {
                        Text(NSLocalizedString("Horizontal Anchor Side", comment: "")).foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $anchorSelection) {
                            Text(NSLocalizedString("Left", comment: "")).tag(0)
                            Text(NSLocalizedString("Center", comment: "")).tag(1)
                            Text(NSLocalizedString("Right", comment: "")).tag(2)
                        } label: {}
                            .pickerStyle(.menu)
                            .onChange(of: anchorSelection) { _ in
                                changesMade = true
                            }
                    }
                    HStack {
                        Text(NSLocalizedString("Vertical Anchor Side", comment: "")).foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $anchorYSelection) {
                            Text(NSLocalizedString("Top", comment: "")).tag(0)
                            Text(NSLocalizedString("Center", comment: "")).tag(1)
                            Text(NSLocalizedString("Bottom", comment: "")).tag(2)
                        } label: {}
                            .pickerStyle(.menu)
                            .onChange(of: anchorYSelection) { _ in
                                changesMade = true
                            }
                    }
                    // MARK: Offset X
                    VStack {
                        HStack {
                            Text(NSLocalizedString("Offset X", comment: ""))
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
                            Text(NSLocalizedString("Offset Y", comment: ""))
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $offsetY, bounds: -300...300)
                            .onChange(of: offsetY) { _ in
                                changesMade = true
                            }
                    }
                } header: {
                    Text(NSLocalizedString("Positioning", comment: ""))
                }
                
                Section {
                    // MARK: Auto Resizes
                    HStack {
                        Toggle(isOn: $autoResizes) {
                            Text(NSLocalizedString("Auto Resize", comment: ""))
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
                                Text(NSLocalizedString("Width", comment: ""))
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
                                Text(NSLocalizedString("Height", comment: ""))
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
                    Text(NSLocalizedString("Size Constraints", comment: ""))
                }
                
                if !usesAdaptiveColor || !dynamicColor {
                    Section {
                        // MARK: Has Blur
                        HStack {
                            Toggle(isOn: $hasBlur) {
                                Text(NSLocalizedString("Background Blur", comment: ""))
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
                                Text(NSLocalizedString("Blur Style", comment: "")).foregroundColor(.primary).bold()
                                Spacer()
                                Picker(selection: $blurStyle) {
                                    Text(NSLocalizedString("Light", comment: "")).tag(0)
                                    Text(NSLocalizedString("Dark", comment: "")).tag(1)
                                } label: {}
                                    .pickerStyle(.menu)
                                    .onChange(of: blurStyle) { _ in
                                        changesMade = true
                                    }
                            }
                            // MARK: Blur Corner Radius
                            VStack {
                                HStack {
                                    Text(NSLocalizedString("Blur Corner Radius", comment: ""))
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
                                    Text(NSLocalizedString("Blur Alpha", comment: ""))
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
                        Text(NSLocalizedString("Blur", comment: ""))
                    }
                }
                
                Section {
                    if !usesAdaptiveColor || !dynamicColor {
                        // MARK: Uses Custom Color
                        HStack {
                            Toggle(isOn: $usesCustomColor) {
                                Text(NSLocalizedString("Custom Text Color", comment: ""))
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
                                Text(NSLocalizedString("Text Color", comment: ""))
                                    .bold()
                                Spacer()
                                ColorPicker(NSLocalizedString("Set Text Color", comment: ""), selection: $customColor)
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
                            Text(NSLocalizedString("Adaptive Color", comment: ""))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: dynamicColor) { _ in
                            changesMade = true
                        }
                    }
                } header: {
                    Text(NSLocalizedString("Text Color", comment: ""))
                }
                
                Section {
                    // MARK: Text Font
                    HStack {
                        Text(NSLocalizedString("Text Font", comment: "")).foregroundColor(.primary).font(Font.custom(fontName, size: UIFont.labelFontSize)).bold()
                        Spacer()
                        Picker(selection: $fontName) {
                            ForEach(fonts, id: \.self) { _fontName in
                                Text(_fontName).font(Font.custom(_fontName, size: UIFont.systemFontSize))
                            }
                        } label: {}
                        .pickerStyle(.menu)
                        .onChange(of: fontName) { _ in
                            changesMade = true
                        }
                    }
                    // MARK: Bold Text
                    HStack {
                        Toggle(isOn: $textBold) {
                            Text(NSLocalizedString("Bold Text", comment: ""))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: textBold) { _ in
                            changesMade = true
                        }
                    }
                    // MARK: Italic Text
                    HStack {
                        Toggle(isOn: $textItalic) {
                            Text(NSLocalizedString("Italic Text", comment: ""))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: textItalic) { _ in
                            changesMade = true
                        }
                    }
                    // MARK: Text Alignment
                    HStack {
                        Text(NSLocalizedString("Text Alignment", comment: "")).foregroundColor(.primary).bold()
                        Spacer()
                        Picker(selection: $textAlignment) {
                            Text(NSLocalizedString("Left", comment: "")).tag(0)
                            Text(NSLocalizedString("Center", comment: "")).tag(1)
                            Text(NSLocalizedString("Right", comment: "")).tag(2)
                        } label: {}
                        .pickerStyle(.menu)
                        .onChange(of: textAlignment) { _ in
                            changesMade = true
                        }
                    }
                    // MARK: Font Size
                    VStack {
                        HStack {
                            Text(NSLocalizedString("Font Size", comment: ""))
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
                            Text(NSLocalizedString("Text Alpha", comment: ""))
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $textAlpha, bounds: 0.0...1.0)
                            .onChange(of: textAlpha) { _ in
                                changesMade = true
                            }
                    }
                } header: {
                    Text(NSLocalizedString("Text Properties", comment: ""))
                }
                
                Section {
                    // MARK: Add Widget Button
                    Button(action: {
                        showingAddView.toggle()
                    }) {
                        Text(NSLocalizedString("Add Widget", comment: ""))
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
                            .onDrag { // mean drag a row container
                                return NSItemProvider()
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { i in
                            UIApplication.shared.confirmAlert(title: NSLocalizedString("Delete Widget", comment: ""), body: NSLocalizedString("Are you sure you want to delete this widget?", comment: ""), onOK: {
                                widgetManager.removeWidget(widgetSet: widgetSet, id: widgetIDs[i], save: false)
                                saveSet()
                                widgetIDs.remove(at: i)
                            }, noCancel: false)
                        }
                    }
                    .onMove(perform: moveItem)
                } header: {
                    Text(NSLocalizedString("Widgets", comment: ""))
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
            .navigationTitle(NSLocalizedString("Edit Widget", comment: ""))
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
                
                fontName = widgetSet.fontName
                textBold = widgetSet.textBold
                textItalic = widgetSet.textItalic
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
                        UIApplication.shared.confirmAlert(title: NSLocalizedString("Save Changes", comment: ""), body: NSLocalizedString("Would you like to save the changes to your current widget set?", comment: ""), onOK: {
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

    func moveItem(from source: IndexSet, to destination: Int) {
        widgetManager.moveWidget(widgetSet: widgetSet, source: source, destination: destination)
        // saveSet()
        changesMade = true
        widgetIDs.move(fromOffsets: source, toOffset: destination)
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
            
            fontName: fontName,
            textBold: textBold,
            textItalic: textItalic,
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
