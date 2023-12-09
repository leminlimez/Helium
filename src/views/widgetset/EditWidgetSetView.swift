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
    @State var cornerRadius: Int = 4
    
    @State var textAlpha: Double = 1.0
    @State var textAlignment: Int = 1
    @State var fontSize: Double = 10.0
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
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
                        TextField("10", value: $offsetX, formatter: formatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    // MARK: Offset Y
                    HStack {
                        Text("Offset Y")
                            .bold()
                        Spacer()
                        TextField("0", value: $offsetY, formatter: formatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                            TextField("100", value: $scale, formatter: formatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                            TextField("4", value: $cornerRadius, formatter: formatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                
                VStack {
                    // MARK: Text Alpha
                    HStack {
                        Text("Text Alpha")
                            .bold()
                        Spacer()
                        TextField("1", value: $textAlpha, formatter: formatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                        TextField("10", value: $fontSize, formatter: formatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                cornerRadius = widgetSet.blurDetails.cornerRadius
                
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
