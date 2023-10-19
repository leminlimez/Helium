//
//  WidgetCustomizationView.swift
//
//
//  Created by lemin on 10/13/23.
//

import Foundation
import SwiftUI

// MARK: Widget Customization View
// TODO: This
struct WidgetCustomizationView: View {
    var body: some View {
        NavigationView {
            VStack {
                WidgetPlaceView(widgetManager: .init(widgetSide: .center))
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
                    Button(action: {
                        showingAddView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                    }
                    .background(.ultraThinMaterial, in:
                                    RoundedRectangle(cornerRadius: 100.0))
                }
            }
            .padding(.horizontal, 5)
            .sheet(isPresented: $showingAddView, content: {
                WidgetAddView(widgetManager: widgetManager)
            })
            .sheet(isPresented: $showingModView, content: {
                WidgetModifyView(widgetManager: widgetManager, widgetIndex: $viewIndex)
            })
        }
        .background(.ultraThinMaterial, in:
            RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: Widget Modify View
struct WidgetModifyView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var widgetManager: WidgetManager
    @Binding var widgetIndex: Int
    
    var body: some View {
        VStack {
            if widgetIndex >= 0 && widgetIndex < widgetManager.widgetStructs.count {
                Text("Modify Widget")
                    .bold()
                    .font(.title3)
                // Widget Preferences
                WidgetPreferencesView(widgetStruct: $widgetManager.widgetStructs[widgetIndex])
                // Save Button
                Button("Save") {
                    widgetManager.saveWidgetStructs()
                    dismiss()
                }
                .buttonStyle(TintedButton(color: .blue))
                // Delete Button
                Button("Delete") {
                    widgetManager.removeWidget(id: widgetIndex)
                    dismiss()
                }
                .buttonStyle(TintedButton(color: .red))
            }
        }
    }
}

// MARK: Widget Add View
struct WidgetAddView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var widgetManager: WidgetManager
    
    var body: some View {
        List {
            ForEach(WidgetModule.allCases, id: \.self) { id in
                Button(action: {
                    widgetManager.addWidget(module: id)
                    dismiss()
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
            ZStack {
                Text(exampleText)
                    .padding(.vertical, 5)
                    .foregroundColor(.secondary)
            }
            .frame(width: 125)
            .background(.ultraThinMaterial, in:
                RoundedRectangle(cornerRadius: 8))
            .padding(.trailing, 5)
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
