//
//  BezelCustomizationView.swift
//  Helium UI
//
//  Created by lemin on 10/27/23.
//

import Foundation
import SwiftUI

let CardAnimationSpeed = 0.3

struct BezelButtonsMainView: View {
    @StateObject var widgetManager: WidgetManager
    
    var geometry: GeometryProxy
    var widgetOffsetSize: CGFloat
    var trueWidgetSize: CGFloat
    
    @Binding var zoomedInPos: Int
    @Binding var zoomAnimAmount: CGFloat
    @Binding var canPressButtons: Bool
    
    @Binding var flippedWidget: WidgetStruct?
    @Binding var animate3d: Bool
    
    var body: some View {
        VStack {
            BezelButtonView(widgetManager: widgetManager, flippedWidget: $flippedWidget, animate3d: $animate3d, geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: trueWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, zoomedOutAction: playAnimation)
                .frame(width: geometry.size.width * widgetOffsetSize * trueWidgetSize, height: 18)
                .background(
                    RoundedRectangle(cornerRadius: 3)
                        .opacity(0.4)
                        .foregroundColor(.black)
                )
        }
    }
    
    func playAnimation() {
        if canPressButtons {
            canPressButtons = false
            
            if zoomAnimAmount == 1 {
                switch (widgetManager.widgetSide) {
                case .left:
                    zoomedInPos = 0
                case .center:
                    zoomedInPos = 1
                case .right:
                    zoomedInPos = 2
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                    zoomAnimAmount = 2
                }
            } else {
                zoomAnimAmount = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                canPressButtons = true
            }
        }
    }
}

struct BezelButtonView: View {
    @StateObject var widgetManager: WidgetManager
    @Binding var flippedWidget: WidgetStruct?
    @Binding var animate3d: Bool
    
    var geometry: GeometryProxy
    var widgetOffsetSize: CGFloat
    var trueWidgetSize: CGFloat
    
    @Binding var zoomedInPos: Int
    @Binding var zoomAnimAmount: CGFloat
    @Binding var canPressButtons: Bool
    
    @State var showingAddView: Bool = false
    
    var zoomedOutAction: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                ForEach ($widgetManager.widgetStructs) { widget in
                    WidgetPreviewsView(widget: widget, previewColor: .white)
                        .onTapGesture {
                            if canPressButtons && zoomAnimAmount != 1 && zoomedPosMatches() {
                                withAnimation(Animation.easeInOut(duration: CardAnimationSpeed)) {
                                    if animate3d {
                                        flippedWidget = nil
                                    } else {
                                        flippedWidget = widget.wrappedValue
                                    }
                                    animate3d.toggle()
                                }
                            }
                        }
                }
                if widgetManager.widgetStructs.count < widgetManager.maxNumWidgets {
                    // plus button
                    Button(action: {
                        if canPressButtons && zoomAnimAmount != 1 && zoomedPosMatches() {
                            showingAddView.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .minimumScaleFactor(0.01)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                    }
                }
            }
            .frame(height: 14)
            .padding(.vertical, 2)
            .sheet(isPresented: $showingAddView, content: {
                WidgetAddView(widgetManager: widgetManager)
            })
            
            if zoomAnimAmount == 1 {
                Button(action: {
                    zoomedOutAction()
                }) {
                    Rectangle()
                        .opacity(0)
                }
                .scaleEffect(CGSize(width: 1.05, height: 2))
            }
        }
    }
    
    func zoomedPosMatches() -> Bool {
        if (
            (widgetManager.widgetSide == .left && zoomedInPos == 0)
            || (widgetManager.widgetSide == .center && zoomedInPos == 1)
            || (widgetManager.widgetSide == .right && zoomedInPos == 2)
        ) {
            return true
        }
        return false
    }
}

struct BezelCustomizationView: View {
    @State var deviceType: Int
    
    @State var sideWidgetSize: CGFloat = 0.5
    @State var centerWidgetSize: CGFloat = 0.5
    
    @State var bezelSize: CGFloat = 0.8
    @State var widgetOffsetSize: CGFloat = 0.68
    
    @State var zoomedInPos: Int = 0 // 0 = left, 1 = center, 2 = right
    @State var zoomAnimAmount: CGFloat = 1.0
    @State var canPressButtons: Bool = true
    
    @State var flippedWidget: WidgetStruct?
    @State var flipped: Bool = false
    @State var animate3d: Bool = false
    
    @StateObject var widgetManagerL: WidgetManager = .init(widgetSide: .left)
    @StateObject var widgetManagerC: WidgetManager = .init(widgetSide: .center)
    @StateObject var widgetManagerR: WidgetManager = .init(widgetSide: .right)
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    // MARK: Phone and Widgets
                    ZStack {
                        Image(deviceType == 3 ? "DynamicIsland" : deviceType == 1 ? "SmallNotch" : "BigNotch")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * bezelSize)
                            .frame(maxHeight: .infinity)
                            .onTapGesture {
                                if canPressButtons {
                                    if flippedWidget != nil {
                                        // close the current widget
                                        withAnimation(Animation.easeInOut(duration: CardAnimationSpeed)) {
                                            flippedWidget = nil
                                            animate3d.toggle()
                                        }
                                    } else if zoomAnimAmount != 1 {
                                        canPressButtons = false
                                        zoomAnimAmount = 1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                            canPressButtons = true
                                        }
                                    }
                                }
                            }
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(height: geometry.size.height * 0.075)
                            }
                            HStack {
                                BezelButtonsMainView(widgetManager: widgetManagerL, geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: sideWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, flippedWidget: $flippedWidget, animate3d: $animate3d)
                                Spacer()
                                BezelButtonsMainView(widgetManager: widgetManagerC, geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: centerWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, flippedWidget: $flippedWidget, animate3d: $animate3d)
                                Spacer()
                                BezelButtonsMainView(widgetManager: widgetManagerR, geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: sideWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, flippedWidget: $flippedWidget, animate3d: $animate3d)
                            }
                            .frame(width: geometry.size.width * 0.68)
                            Spacer()
                        }
                    }
                    .coordinateSpace(name: "mainFrame")
                    .scaleEffect(1.25, anchor: .top)
                    .scaleEffect(zoomAnimAmount, anchor: (zoomedInPos == 0 ? .topLeading : zoomedInPos == 1 ? .top : .topTrailing))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: zoomAnimAmount
                    )
                    .blur(radius: animate3d ? 8 : 0)
                    
                    // MARK: Widget Flip View
                    // i hate state objects
                    if zoomedInPos == 0 {
                        WidgetSettingsFlipView(screenGeom: geometry, widgetManager: widgetManagerL, flippedWidget: $flippedWidget, canPressButtons: $canPressButtons, flipped: $flipped, animate3d: $animate3d)
                            .aspectRatio(1, contentMode: .fit)
                    } else if zoomedInPos == 1 {
                        WidgetSettingsFlipView(screenGeom: geometry, widgetManager: widgetManagerC, flippedWidget: $flippedWidget, canPressButtons: $canPressButtons, flipped: $flipped, animate3d: $animate3d)
                            .aspectRatio(1, contentMode: .fit)
                    } else if zoomedInPos == 2 {
                        WidgetSettingsFlipView(screenGeom: geometry, widgetManager: widgetManagerR, flippedWidget: $flippedWidget, canPressButtons: $canPressButtons, flipped: $flipped, animate3d: $animate3d)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .onAppear {
            sideWidgetSize = getSideWidgetSizeBridger()
            centerWidgetSize = getCenterWidgetSizeBridger()
        }
    }
}

struct WidgetCustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetCustomizationView()
    }
}
