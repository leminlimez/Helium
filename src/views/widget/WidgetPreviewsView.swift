////
////  WidgetPreviewsView.swift
////  Helium UI
////
////  Created by lemin on 10/16/23.
////
//
//import Foundation
//import SwiftUI
//
//struct WidgetPreviewsView: View {
//    @Binding var widget: WidgetStruct
//    @State var text: String = ""
//    @State var previewColor: Color = .primary
//    
//    var body: some View {
//        HStack {
//            Text(text)
//                .foregroundColor(previewColor)
//                .minimumScaleFactor(0.01)
//        }
//        .onAppear {
//            updatePreview()
//        }
//        .onChange(of: widget.modified) { nv in
//            if nv {
//                updatePreview()
//            }
//        }
//    }
//    
//    func updatePreview() {
//        switch (widget.module) {
//        case .date, .time:
//            let dateFormat: String = widget.config["dateFormat"] as? String ?? (widget.module == .date ? "E MMM dd" : "hh:mm")
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = dateFormat
//            text = dateFormatter.string(from: Date())
//            // SAFEGUARD
//            if (text == "") {
//                text = "ERROR"
//            }
//        case .network:
//            let isUp: Bool = widget.config["isUp"] as? Bool ?? false
//            text = "\(isUp ? "▲" : "▼") 0 KB/s"
//        case .temperature:
//            text = "26.02ºC"
//        case .battery:
//            let batteryValue: Int = widget.config["batteryValueType"] as? Int ?? 0
//            switch (batteryValue) {
//            case 0:
//                text = "0 W"
//            case 1:
//                text = "0 mAh"
//            case 2:
//                text = "0 mAh"
//            case 3:
//                text = "25"
//            case 4:
//                text = "50%"
//            default:
//                text = "???"
//            }
//        case .text:
//            text = widget.config["text"] as? String ?? "Unknown"
//        }
//        widget.modified = false
//    }
//}
