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
    
    @State var hasBlur: Bool = false
    @State var cornerRadius: Double = 4
    
    @State var textAlpha: Double = 1.0
    @State var textAlignment: Int = 1
    @State var fontSize: Double = 10.0
    
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
                    }
                    // MARK: Offset X
                    VStack {
                        HStack {
                            Text("Offset X")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $offsetX, bounds: -300...300)
                    }
                    // MARK: Offset Y
                    VStack {
                        HStack {
                            Text("Offset Y")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $offsetY, bounds: -300...300)
                    }
                    // MARK: Auto Resizes
                    HStack {
                        Toggle(isOn: $autoResizes) {
                            Text("Auto Resize")
                                .bold()
                                .minimumScaleFactor(0.5)
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
                    }
                    // MARK: Text Alignment
                    HStack {
                        Picker(selection: $textAlignment, label: Text("Text Alignment").foregroundColor(.primary).bold()) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                        }
                        .pickerStyle(.menu)
                    }
                    // MARK: Font Size
                    VStack {
                        HStack {
                            Text("Font Size")
                                .bold()
                            Spacer()
                        }
                        BetterSlider(value: $fontSize, bounds: 5...50, step: 0.5)
                    }
                }
                
                Section {
                    // MARK: Add Widget Button
                    Button(action: {
                        //TODO: save changes when clicked
                        showingAddView.toggle()
                    }) {
                        Text("Add Widget")
                            .buttonStyle(TintedButton(color: .blue, fullWidth: true))
                    }
                    // MARK: Widget IDs
                    ForEach($widgetSet.widgetIDs) { widgetID in
                        HStack {
                            WidgetPreviewsView(widget: widgetID, previewColor: .white)
                            Spacer()
                            // MARK: Configure Widget Button
                            Button(action: {
                                
                            }) {
                                Image(systemName: "gear")
                            }
                            // MARK: Remove Widget ID Button
                            Button(action: {
                                // save changes
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
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
                
                hasBlur = widgetSet.blurDetails.hasBlur
                cornerRadius = Double(widgetSet.blurDetails.cornerRadius)
                
                textAlpha = widgetSet.textAlpha
                textAlignment = widgetSet.textAlignment
                fontSize = widgetSet.fontSize
            }
            .sheet(isPresented: $showingAddView, content: {
                WidgetAddView(widgetManager: widgetManager, widgetSet: widgetSet, isOpen: $showingAddView)
            })
        }
    }
}
