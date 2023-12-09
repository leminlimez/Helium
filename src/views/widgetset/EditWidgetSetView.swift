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
    
    var body: some View {
        VStack {
            List {
                // MARK: Title Field
                HStack {
                    Text("Widget Set Title")
                        .bold()
                    Spacer()
                    TextField("Title", text: $widgetSet.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack {
                    // MARK: Anchor Side
                    HStack {
                        Picker(selection: $widgetSet.anchor, label: Text("Anchor Side").foregroundColor(.primary).bold()) {
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
                        Slider(value: $widgetSet.offsetX, in: 0...300)
                    }
                    // MARK: Offset Y
                    HStack {
                        Text("Offset Y")
                            .bold()
                        Spacer()
                        Slider(value: $widgetSet.offsetY, in: 0...300)
                    }
                    // MARK: Auto Resizes
                    HStack {
                        Toggle(isOn: $widgetSet.autoResizes) {
                            Text("Auto Resize")
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                    }
                    // MARK: Width
                    if !widgetSet.autoResizes {
                        HStack {
                            Text("Width")
                                .bold()
                            Spacer()
                            Slider(value: $widgetSet.scale, in: 10...500)
                        }
                    }
                }
                
                VStack {
                    // MARK: Has Blur
                    HStack {
                        Toggle(isOn: $widgetSet.blurDetails.hasBlur) {
                            Text("Background Blur")
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                    }
                    // MARK: Blur Corner Radius
                    if widgetSet.blurDetails.hasBlur {
                        HStack {
                            Text("Blur Corner Radius")
                                .bold()
                            Spacer()
                            Slider(value: $widgetSet.blurDetails.cornerRadius, in: 0...30, step: 1)
                        }
                    }
                }
                
                VStack {
                    // MARK: Text Alpha
                    HStack {
                        Text("Text Alpha")
                            .bold()
                        Spacer()
                        Slider(value: $widgetSet.textAlpha, in: 0...1, step: 0.01)
                    }
                    // MARK: Text Alignment
                    HStack {
                        Picker(selection: $widgetSet.textAlignment, label: Text("Text Alignment").foregroundColor(.primary).bold()) {
                            Text("Left").tag(0)
                            Text("Center").tag(1)
                        }
                    }
                    // MARK: Font Size
                    HStack {
                        Text("Font Size")
                            .bold()
                        Spacer()
                        Slider(value: $widgetSet.fontSize, in: 5...50)
                    }
                }
                
                VStack {
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
            .sheet(isPresented: $showingAddView, content: {
                WidgetAddView(widgetManager: widgetManager, widgetSet: widgetSet, isOpen: $showingAddView)
            })
        }
    }
}
