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
                    toggleHUD(!isNowEnabled)
                }
                .buttonStyle(TintedButton(color: .blue))
                .padding(5)
                
                Spacer()
            }
            .disabled(buttonDisabled)
            .onAppear {
                isNowEnabled = IsHUDEnabledBridger()
            }
            .onOpenURL(perform: { url in
                let _ = FileManager.default
                // MARK: URL Schemes
                if url.absoluteString == "helium://toggle" {
                    toggleHUD(!isNowEnabled)
                } else if url.absoluteString == "helium://on" {
                    toggleHUD(true)
                } else if url.absoluteString == "helium://off" {
                    toggleHUD(false)
                }
            })
            .navigationTitle("Helium")
            .navigationViewStyle(.stack)
        }
    }
    
    func toggleHUD(_ isActive: Bool) {
        Haptic.shared.play(.medium)
        if isNowEnabled == isActive { return; }
        print(!isActive ? "Closing HUD" : "Opening HUD")
         SetHUDEnabledBridger(isActive);
        
        buttonDisabled = true
        waitForNotificationBridger({
            isNowEnabled = isActive;
            buttonDisabled = false
        }, !isNowEnabled)
    }
}
