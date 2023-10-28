//
//  BezelCustomizationView.swift
//  Helium UI
//
//  Created by lemin on 10/27/23.
//

import Foundation
import SwiftUI

struct BezelButtonsMainView: View {
    @StateObject var widgetManager: WidgetManager
    
    var geometry: GeometryProxy
    var widgetOffsetSize: CGFloat
    var trueWidgetSize: CGFloat
    
    @Binding var zoomedInPos: Int
    @Binding var zoomAnimAmount: CGFloat
    @Binding var canPressButtons: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                playAnimation()
            }) {
                BezelButtonView(widgetManager: widgetManager, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons, zoomedOutAction: playAnimation)
                    .frame(width: geometry.size.width * widgetOffsetSize * trueWidgetSize, height: 14)
                    .background(
                        RoundedRectangle(cornerRadius: 3)
                            .opacity(0.4)
                            .foregroundColor(.black)
                    )
            }
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
    
    @Binding var zoomAnimAmount: CGFloat
    @Binding var canPressButtons: Bool
    
    @State var viewIndex: Int = -1
    @State var showingAddView: Bool = false
    @State var showingModView: Bool = false
    
    var zoomedOutAction: () -> Void
    
    var body: some View {
        HStack {
            ForEach (0..<widgetManager.widgetStructs.count, id: \.self) { widget in
                Button(action: {
                    if canPressButtons {
                        if zoomAnimAmount == 1 {
                            zoomedOutAction()
                        } else {
                            viewIndex = widget
                            showingModView.toggle()
                        }
                    }
                }) {
                    WidgetPreviewsView(widget: $widgetManager.widgetStructs[widget], previewColor: .white)
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
        .frame(height: 12)
        .padding(.vertical, 2)
        .sheet(isPresented: $showingAddView, content: {
            WidgetAddView(widgetManager: widgetManager)
        })
        .sheet(isPresented: $showingModView, content: {
            WidgetModifyView(widgetManager: widgetManager, widgetIndex: $viewIndex)
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
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Image(deviceType == 3 ? "DynamicIsland" : deviceType == 1 ? "SmallNotch" : "BigNotch")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * bezelSize)
                        .frame(maxHeight: .infinity)
                        .onTapGesture {
                            if canPressButtons && zoomAnimAmount != 1 {
                                canPressButtons = false
                                zoomAnimAmount = 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    canPressButtons = true
                                }
                            }
                        }
                    VStack {
                        HStack {
                            Spacer()
                                .frame(height: geometry.size.height * 0.075)
                        }
                        HStack {
                            BezelButtonsMainView(widgetManager: .init(widgetSide: .left), geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: sideWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons)
                            Spacer()
                            BezelButtonsMainView(widgetManager: .init(widgetSide: .center), geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: centerWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons)
                            Spacer()
                            BezelButtonsMainView(widgetManager: .init(widgetSide: .right), geometry: geometry, widgetOffsetSize: widgetOffsetSize, trueWidgetSize: sideWidgetSize, zoomedInPos: $zoomedInPos, zoomAnimAmount: $zoomAnimAmount, canPressButtons: $canPressButtons)
                        }
                        .frame(width: geometry.size.width * 0.68)
                        Spacer()
                    }
                }
                .scaleEffect(1.25, anchor: .top)
                .scaleEffect(zoomAnimAmount, anchor: (zoomedInPos == 0 ? .topLeading : zoomedInPos == 1 ? .top : .topTrailing))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(
                    .easeInOut(duration: 0.5),
                    value: zoomAnimAmount
                )
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
