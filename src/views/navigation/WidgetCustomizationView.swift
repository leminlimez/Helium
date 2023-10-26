//
//  WidgetCustomizationView.swift
//
//
//  Created by lemin on 10/13/23.
//

import Foundation
import SwiftUI

// MARK: Widget Customization View
struct WidgetCustomizationView: View {
    var body: some View {
        NavigationView {
            VStack {
                // TODO: Improve This UI
                HStack {
                    Text("Left:")
                        .bold()
                    Spacer()
                    if #available(iOS 15, *) {
                        WidgetPlaceView(widgetManager: .init(widgetSide: .left))
                            .background(.ultraThinMaterial, in:
                                RoundedRectangle(cornerRadius: 8))
                    } else {
                        WidgetPlaceView(widgetManager: .init(widgetSide: .left))
                    }
                }
                .padding(5)
                
                HStack {
                    Text("Center:")
                        .bold()
                    Spacer()
                    if #available(iOS 15, *) {
                        WidgetPlaceView(widgetManager: .init(widgetSide: .center))
                            .background(.ultraThinMaterial, in:
                                RoundedRectangle(cornerRadius: 8))
                    } else {
                        WidgetPlaceView(widgetManager: .init(widgetSide: .center))
                    }
                }
                .padding(5)
                
                HStack {
                    Text("Right:")
                        .bold()
                    Spacer()
                    if #available(iOS 15, *) {
                        WidgetPlaceView(widgetManager: .init(widgetSide: .right))
                            .background(.ultraThinMaterial, in:
                                RoundedRectangle(cornerRadius: 8))
                    } else {
                        WidgetPlaceView(widgetManager: .init(widgetSide: .right))
                    }
                }
                .padding(5)
            }
            .navigationTitle("Customize")
        }
    }
}

// MARK: Widget Place View
struct WidgetPlaceView: View {
    @StateObject var widgetManager: WidgetManager
    @State var viewIndex: Int = -1
    @State var showingAddView: Bool = false
    @State var showingModView: Bool = false

    var body: some View {
        HStack {
            HStack {
                ForEach (0..<widgetManager.widgetStructs.count, id: \.self) { widget in
                    Button(action: {
                        viewIndex = widget
                        showingModView.toggle()
                    }) {
                        WidgetPreviewsView(widget: $widgetManager.widgetStructs[widget])
                    }
                }
                .padding(.horizontal, 1)
                if widgetManager.widgetStructs.count < widgetManager.maxNumWidgets {
                    // add a plus button
                    if #available(iOS 15, *) {
                        Button(action: {
                            showingAddView.toggle()
                        }) {
                            Image(systemName: "plus")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                        }
                        .background(.ultraThinMaterial, in:
                                        RoundedRectangle(cornerRadius: 100.0))
                    } else {
                        Button(action: {
                            showingAddView.toggle()
                        }) {
                            Image(systemName: "plus")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 100.0).opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 5)
            .sheet(isPresented: $showingAddView, content: {
                WidgetAddView(showing: $showingAddView, widgetManager: widgetManager)
            })
            .sheet(isPresented: $showingModView, content: {
                WidgetModifyView(showing: $showingModView, widgetManager: widgetManager, widgetIndex: $viewIndex)
            })
        }
    }
}

// MARK: Widget Modify View
struct WidgetModifyView: View {
    @Binding var showing: Bool
    @StateObject var widgetManager: WidgetManager
    @Binding var widgetIndex: Int
    
    var body: some View {
        VStack {
            if widgetIndex >= 0 && widgetIndex < widgetManager.widgetStructs.count {
                List {
                    // Widget Preferences
                    WidgetPreferencesView(widgetStruct: $widgetManager.widgetStructs[widgetIndex])
                    VStack {
                        // Save Button
                        Button("Save") {
                            widgetManager.saveWidgetStructs()
                            showing = false
                        }
                        .buttonStyle(TintedButton(color: .blue, fullWidth: true))
                        .padding(.horizontal, 7)
                        // Delete Button
                        Button("Delete") {
                            widgetManager.removeWidget(id: widgetIndex)
                            showing = false
                        }
                        .buttonStyle(TintedButton(color: .red, fullWidth: true))
                        .padding(.horizontal, 7)
                    }
                }
            }
        }
    }
}

// MARK: Widget Add View
struct WidgetAddView: View {
    @Binding var showing: Bool
    @StateObject var widgetManager: WidgetManager
    
    var body: some View {
        List {
            ForEach(WidgetModule.allCases, id: \.self) { id in
                Button(action: {
                    widgetManager.addWidget(module: id)
                    showing = false
                }) {
                    WidgetChoiceView(widgetName: WidgetDetails.getWidgetName(id), exampleText: WidgetDetails.getWidgetExample(id))
                }
            }
        }
    }
}

// MARK: Widget Choice View
struct WidgetChoiceView: View {
    var widgetName: String
    var exampleText: String

    var body: some View {
        HStack {
            if #available(iOS 15, *) {
                ZStack {
                    Text(exampleText)
                        .padding(.vertical, 5)
                        .foregroundColor(.secondary)
                }
                .frame(width: 125)
                .background(.ultraThinMaterial, in:
                                RoundedRectangle(cornerRadius: 8))
                .padding(.trailing, 5)
            } else {
                ZStack {
                    Text(exampleText)
                        .padding(.vertical, 5)
                        .foregroundColor(.secondary)
                }
                .frame(width: 125)
                .background(RoundedRectangle(cornerRadius: 8).opacity(0.6))
                .padding(.trailing, 5)
            }
            Text(widgetName)
                .foregroundColor(.primary)
                .bold()
        }
    }
}

struct WidgetCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetCustomizationView()
    }
}
