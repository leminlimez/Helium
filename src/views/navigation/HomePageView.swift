//
//  HomePageView.swift
//  Helium UI
//
//  Created by lemin on 10/19/23.
//

import Foundation
import SwiftUI

// MARK: Home Page View
struct HomePageView: View {
    @State private var isNowEnabled: Bool = false
    @State private var buttonDisabled: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // HUD Info Text
                Text(isNowEnabled ? "You can quit the app now.\nThe HUD will persist on your screen." : "Stopped.")
                    .foregroundColor(isNowEnabled ? .blue : .red)
                    .padding(5)
                    .multilineTextAlignment(.center)
                
                // Activate HUD Button
                Button(isNowEnabled ? "Disable HUD" : "Enable HUD") {
                   print(isNowEnabled ? "Closing HUD" : "Opening HUD")
                    SetHUDEnabledBridger(!isNowEnabled);

                    buttonDisabled = true
                    waitForNotificationBridger({
                        isNowEnabled = !isNowEnabled;
                        buttonDisabled = false
                    }, !isNowEnabled)
                }
                .buttonStyle(TintedButton(color: .blue))
                .padding(5)
                
                Spacer()
            }
            .disabled(buttonDisabled)
            .onAppear {
                isNowEnabled = IsHUDEnabledBridger()
            }
            .navigationTitle("Helium")
        }
    }
}
