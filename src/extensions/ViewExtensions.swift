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
