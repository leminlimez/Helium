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
    
    @State var anchorSelection: Int = 0
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
                HStack {
                    Text("Widget Set Title")
                        .bold()
                    Spacer()
                    TextField("Title", text: $nameInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack {
                    // MARK: Anchor Side
                    HStack {
                        Picker(selection: $anchorSelection, label: Text("Anchor Side").foregroundColor(.primary).bold()) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                            Text("Right").tag(2)
                        }
                    }
                    // MARK: Offset X
                    HStack {
                        Text("Offset X")
                            .bold()
                        Spacer()
                        Slider(value: $offsetX, in: 0...300)
                    }
                    // MARK: Offset Y
                    HStack {
                        Text("Offset Y")
                            .bold()
                        Spacer()
                        Slider(value: $offsetY, in: 0...300)
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
                        HStack {
                            Text("Width")
                                .bold()
                            Spacer()
                            Slider(value: $scale, in: 10...500)
                        }
                    }
                }
                
                VStack {
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
                        HStack {
                            Text("Blur Corner Radius")
                                .bold()
                            Spacer()
                            Slider(value: $cornerRadius, in: 0...30, step: 1)
                        }
                    }
                }
                
                VStack {
                    // MARK: Text Alpha
                    HStack {
                        Text("Text Alpha")
                            .bold()
                        Spacer()
                        Slider(value: $textAlpha, in: 0...1, step: 0.01)
                    }
                    // MARK: Text Alignment
                    HStack {
                        Picker(selection: $textAlignment, label: Text("Text Alignment").foregroundColor(.primary).bold()) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                        }
                    }
                    // MARK: Font Size
                    HStack {
                        Text("Font Size")
                            .bold()
                        Spacer()
                        Slider(value: $fontSize, in: 5...50)
                    }
                }
                
                VStack {
                    // MARK: Add Widget Button
                    Button(action: {
                        showingAddView.toggle()
                    }) {
                        Text("Add Widget")
                            .buttonStyle(TintedButton(color: .blue, fullWidth: true))
                    }
                    // MARK: Widget IDs
                    ForEach($widgetSet.widgetIDs) { widgetID in
                        HStack {
                            WidgetPreviewsView(widget: widgetID, previewColor: .white)
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
