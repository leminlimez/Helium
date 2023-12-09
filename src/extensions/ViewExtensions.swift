//
//  ViewExtensions.swift
//  
//
//  Created by lemin on 10/13/23.
//

import Foundation
import SwiftUI

// MARK: Tinted Button Style
struct TintedButton: ButtonStyle {
    var color: Color
    var fullWidth: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if fullWidth {
                configuration.label
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(AnyView(color.opacity(0.2)))
                    .cornerRadius(8)
                    .foregroundColor(color)
            } else {
                configuration.label
                    .padding(15)
                    .background(AnyView(color.opacity(0.2)))
                    .cornerRadius(8)
                    .foregroundColor(color)
            }
        }
    }
    
    init(color: Color = .blue, fullWidth: Bool = false) {
        self.color = color
        self.fullWidth = fullWidth
    }
}

// MARK: Extended Slider
struct BetterSlider: View {
    @Binding var value: Double
    var bounds: ClosedRange<Double>
    var step: Double.Stride? = nil
    
    var inputTitle: String = "Enter Value"
    var inputBody: String = "Enter a value."
    
    var body: some View {
        HStack {
            if step == nil {
                Slider(value: $value, in: bounds)
            } else {
                Slider(value: $value, in: bounds, step: step!)
            }
            Spacer()
            Button(action: {
                UIApplication.shared.inputAlert(title: inputTitle, body: inputBody, keyboardType: .decimalPad, onOK: { val in
                    var finalVal: Double = Double(val) ?? value
                    // make sure it is within bounds, then set it
                    if (finalVal > bounds.upperBound) {
                        finalVal = bounds.upperBound
                    } else if (finalVal < bounds.lowerBound) {
                        finalVal = bounds.lowerBound
                    }
                    if step != nil {
                        // make sure it is within the step
                        finalVal = finalVal.truncatingRemainder(dividingBy: step!)
                    }
                    value = finalVal
                }, noCancel: false)
            }) {
                Text(String(format: "%.2f", value))
            }
        }
    }
}
