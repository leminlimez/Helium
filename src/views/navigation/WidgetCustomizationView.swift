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
                BezelCustomizationView(deviceType: getDeviceSizeBridger())
            }
            .navigationTitle("Customize")
        }
    }
}

// MARK: Widget Modify View
struct WidgetModifyView: View {
    @StateObject var widgetManager: WidgetManager
    @Binding var widgetIndex: Int
    
    var dismiss: () -> Void
    
    var body: some View {
        return List {
            if widgetIndex >= 0 && widgetIndex < widgetManager.widgetStructs.count {
                // Widget Preferences
                WidgetPreferencesView(widgetStruct: $widgetManager.widgetStructs[widgetIndex])
                VStack {
                    // Save Button
                    Button("Save") {
                        widgetManager.saveWidgetStructs()
                        dismiss()
                    }
                    .buttonStyle(TintedButton(color: .blue, fullWidth: true))
                    .padding(.horizontal, 7)
                    // Delete Button
                    Button("Delete") {
                        widgetManager.removeWidget(id: widgetIndex)
                        dismiss()
                    }
                    .buttonStyle(TintedButton(color: .red, fullWidth: true))
                    .padding(.horizontal, 7)
                }
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
                Image(uiImage: UIImage(named: "wallpaper")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(1.5)
                    .frame(width: 125, height: 50)
                    .cornerRadius(12)
                    .clipped()
                ZStack {
                    Text(exampleText)
                        .padding(.vertical, 5)
                        .foregroundColor(.white)
                }
                .frame(width: 125, height: 50)
            }
            .padding(.trailing, 5)
            Text(widgetName)
                .foregroundColor(.primary)
                .bold()
        }
    }
}

//struct WidgetCustomizationView_Previews: PreviewProvider {
//    static var previews: some View {
//        WidgetCustomizationView()
//    }
//}
