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
            BezelButtonView(widgetManager: widgetManager, flippedWidget: $flippedWidget, animate3d: $animate3d, geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: trueWidgetSize, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, zoomedOutAction: playAnimation)
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
    
    @Binding var zoomAnimAmount: CGFloat
    @Binding var canPressButtons: Bool
    
    @State var showingAddView: Bool = false
    
    var zoomedOutAction: () -> Void
    
    var body: some View {
        HStack {
            ForEach ($widgetManager.widgetStructs) { widget in
                WidgetPreviewsView(widget: widget, previewColor: .white)
                    .onTapGesture {
                        if canPressButtons {
                            if zoomAnimAmount == 1 {
                                zoomedOutAction()
                            } else {
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
            }
            if widgetManager.widgetStructs.count < widgetManager.maxNumWidgets {
                // plus button
                Button(action: {
                    if canPressButtons {
                        if zoomAnimAmount == 1 {
                            zoomedOutAction()
                        } else {
                            showingAddView.toggle()
                        }
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
                                BezelButtonsMainView(widgetManager: .init(widgetSide: .left), geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: sideWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, flippedWidget: $flippedWidget, animate3d: $animate3d)
                                Spacer()
                                BezelButtonsMainView(widgetManager: .init(widgetSide: .center), geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: centerWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, flippedWidget: $flippedWidget, animate3d: $animate3d)
                                Spacer()
                                BezelButtonsMainView(widgetManager: .init(widgetSide: .right), geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: sideWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, flippedWidget: $flippedWidget, animate3d: $animate3d)
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
                    
                    // MARK: Widget Flip View
                    WidgetSettingsFlipView(screenGeom: geometry, flippedWidget: $flippedWidget, canPressButtons: $canPressButtons, flipped: $flipped, animate3d: $animate3d)
                        .aspectRatio(1, contentMode: .fit)
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
