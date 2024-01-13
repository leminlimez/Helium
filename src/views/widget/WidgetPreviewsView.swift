//
//  WidgetPreviewsView.swift
//  Helium UI
//
//  Created by lemin on 10/16/23.
//

import Foundation
import SwiftUI

struct WidgetPreviewsView: View {
    @Binding var widget: WidgetIDStruct
    @State var text: String = ""
    @State var previewColor: Color = .primary
    
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
                    Text(text)
                        .padding(.vertical, 5)
                        .foregroundColor(previewColor)
                        .minimumScaleFactor(0.01)
                }
                .frame(width: 125, height: 50)
            }
            .padding(.trailing, 5)
        }
        .onAppear {
            updatePreview()
        }
        .onChange(of: widget.modified) { nv in
            if nv {
                updatePreview()
            }
        }
    }
    
    func updatePreview() {
        switch (widget.module) {
        case .dateWidget, .timeWidget:
            let dateFormat: String = widget.config["dateFormat"] as? String ?? (widget.module == .dateWidget ? "E MMM dd" : "hh:mm")
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = dateFormat
            text = dateFormatter.string(from: Date())
            // SAFEGUARD
            if (text == "") {
                text = "ERROR"
            }
        case .network:
            let isUp: Bool = widget.config["isUp"] as? Bool ?? false
            text = "\(isUp ? "▲" : "▼") 0 KB/s"
        case .temperature:
            text = widget.config["useFahrenheit"] as? Bool ?? false ? "78.84ºF" : "26.02ºC"
        case .battery:
            let batteryValue: Int = widget.config["batteryValueType"] as? Int ?? 0
            switch (batteryValue) {
            case 0:
                text = "0 W"
            case 1:
                text = "0 mA"
            case 2:
                text = "0 mA"
            case 3:
                text = "25"
            default:
                text = "???"
            }
        case .textWidget:
            text = widget.config["text"] as? String ?? "Unknown"
        case .currentCapacity:
            text = "50\(widget.config["showPercentage"] as? Bool ?? true ? "%" : "")"
        case .chargeSymbol:
            text = "\(widget.config["filled"] as? Bool ?? true ? "􀋦" : "􀋥")"
        }
        widget.modified = false
    }
}
