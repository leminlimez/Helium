//
//  WidgetConfigureView.swift
//  Helium UI
//
//  Created by lemin on 11/2/23.
//

import Foundation
import SwiftUI

let cardScale: CGFloat = 0.9

struct WidgetSettingsFlipView: View {
    var screenGeom: GeometryProxy
    @StateObject var widgetManager: WidgetManager
    
    @Binding var flippedWidget: WidgetStruct?
    
    @Binding var canPressButtons: Bool
    
    @Binding var flipped: Bool
    @Binding var animate3d: Bool
    
    var body: some View {
        return GeometryReader {cardGeometry in
            VStack {
                if animate3d && flippedWidget != nil {
                    BackWidgetOptionView(screenGeom: screenGeom, widgetManager: widgetManager, flippedWidget: $flippedWidget, widgetIndex: widgetManager.getWidgetID(widget: flippedWidget!), canPressButtons: $canPressButtons, flipFunction: flipCard)
                        .frame(
                            width: animate3d ? (min(screenGeom.size.width, screenGeom.size.height)) : 0,
                            height: animate3d ? (min(screenGeom.size.width, screenGeom.size.height)) : 0
                        )
                } else {
                    Rectangle()
                        .opacity(0)
                }
            }
            .scaleEffect(animate3d ? ((min(screenGeom.size.width, screenGeom.size.height)*cardScale)) / cardGeometry.size.width: 1)
            .zIndex(animate3d ? 2 : 0)
            .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0.0, y: 1)))
            .aspectRatio(1.0, contentMode: .fit)
        }
    }
    
    func flipCard() {
        withAnimation(Animation.easeInOut(duration: CardAnimationSpeed)) {
            animate3d.toggle()
        }
    }
}

// MARK: Back Widget View/Edit Widget View
struct BackWidgetOptionView: View {
    var screenGeom: GeometryProxy
    @StateObject var widgetManager: WidgetManager
    
    @Binding var flippedWidget: WidgetStruct?
    @State var widgetIndex: Int
    
    @Binding var canPressButtons: Bool
    
    var flipFunction: () -> Void
    
    var body: some View {
        return VStack(alignment: .center) {
            Text("Configure Widget")
                .bold()
                .padding(.top, 25)
            
            Spacer()
            
            WidgetModifyView(widgetManager: widgetManager, widgetIndex: $widgetIndex, dismiss: {
                canPressButtons = false
                withAnimation(Animation.easeInOut(duration: CardAnimationSpeed)) {
                    flippedWidget = nil
                    flipFunction()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + CardAnimationSpeed + 0.05) {
                    canPressButtons = true
                }
            })
            .padding(5)
            
            Spacer()
        }
        .background(Color(uiColor14: .secondarySystemBackground))
        .cornerRadius(16)
    }
}
