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
  @State private var inProgress = false

  var body: some View {
    NavigationView {
      VStack(spacing: 10) {
        Spacer()

        // Activate HUD Button
        Button(
          action: {
            #if targetEnvironment(simulator)
              isNowEnabled.toggle()
            #else
              toggleHUD(!isNowEnabled)
            #endif
          },
          label: {
            HStack(spacing: 10) {
              if inProgress {
                if #available(iOS 16.0, *) {
                  ProgressView()
                    .tint(isNowEnabled ? .red : .blue)
                } else {
                  ProgressView()
                    .foregroundColor(isNowEnabled ? .red : .blue)
                }
              }
              Text(
                isNowEnabled
                  ? NSLocalizedString("Disable HUD", comment: "")
                  : NSLocalizedString("Enable HUD", comment: ""))
            }
          }
        )
        .buttonStyle(TintedButton(color: isNowEnabled ? .red : .blue))
        .padding(5)
        .offset(y: isNowEnabled ? -10 : 0)
        Text(
          NSLocalizedString(
            "You can quit the app now.\nThe HUD will persist on your screen.", comment: "")
        )
        .multilineTextAlignment(.center)
        .offset(y: isNowEnabled ? 5 : 15)
        .foregroundColor(.blue)
        .opacity(isNowEnabled ? 1 : 0)

        Spacer()
        // HUD Info Text
        Text(
          isNowEnabled
            ? NSLocalizedString("Status: Running", comment: "")
            : NSLocalizedString("Status: Stopped", comment: "")
        )
        .font(.caption)
        .foregroundColor(isNowEnabled ? .blue : .red)
        .padding(.bottom, 10)
        .multilineTextAlignment(.center)
      }
      .disabled(buttonDisabled)
      .onAppear {
        #if !targetEnvironment(simulator)
          isNowEnabled = IsHUDEnabledBridger()
        #endif
      }
      .onOpenURL(perform: { url in
        let _ = FileManager.default
        // MARK: URL Schemes
        if url.absoluteString == "helium://toggle" {
          #if !targetEnvironment(simulator)
            toggleHUD(!isNowEnabled)
          #endif
        } else if url.absoluteString == "helium://on" {
          #if !targetEnvironment(simulator)
            toggleHUD(true)
          #endif
        } else if url.absoluteString == "helium://off" {
          #if !targetEnvironment(simulator)
            toggleHUD(false)
          #endif
        }
      })
      .navigationTitle(Text(NSLocalizedString("Helium", comment: "")))
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .animation(.timingCurve(0.25, 0.1, 0.35, 1.75).speed(1.2), value: isNowEnabled)
    .animation(.timingCurve(0.25, 0.1, 0.35, 1.75).speed(1.2), value: inProgress)
  }

  func toggleHUD(_ isActive: Bool) {
    inProgress.toggle()
    Haptic.shared.play(.medium)
    if isNowEnabled == isActive { return }
    print(
      !isActive
        ? NSLocalizedString("Closing HUD", comment: "")
        : NSLocalizedString("Opening HUD", comment: ""))
    SetHUDEnabledBridger(isActive)

    buttonDisabled = true
    waitForNotificationBridger(
      {
        isNowEnabled = isActive
        buttonDisabled = false
        inProgress.toggle()
      }, !isNowEnabled)
  }
}
