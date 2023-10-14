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
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label
                .padding(15)
                .background(AnyView(color.opacity(0.2)))
                .cornerRadius(8)
                .foregroundColor(color)
        }
    }
    
    init(color: Color = .blue) {
        self.color = color
    }
}
