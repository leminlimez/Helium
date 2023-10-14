//
//  ContentView.swift
//  
//
//  Created by lemin on 10/11/23.
//

import Foundation
import SwiftUI

let buildNumber: Int = 1

// MARK: Home Page View
struct HomePageView: View {
//    var buttonHandler: () -> Void
    @State var isNowEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // HUD Info Text
                Text(isNowEnabled ? "You can quit the app now.\nThe HUD will persist on your screen." : "Stopped.")
                    .foregroundColor(isNowEnabled ? .blue : .red)
                    .padding(5)
                
                // Activate HUD Button
                Button(isNowEnabled ? "Disable HUD" : "Enable HUD") {
                   print(isNowEnabled ? "Closing HUD" : "Opening HUD")
                   SetHUDEnabledBridger(!isNowEnabled);
                   isNowEnabled = !isNowEnabled;
                }
                .buttonStyle(TintedButton(color: .blue))
                .padding(5)
                
                Spacer()
            }
            .onAppear {
                isNowEnabled = IsHUDEnabledBridger()
            }
            .navigationTitle("Helium")
        }
    }
}

// MARK: Widget Customization View
// TODO: This
struct WidgetCustomizationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("TODO")
            }
            .navigationTitle("Customize")
        }
    }
}

// MARK: Settings View
// TODO: This
struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                // App Version/Build Number
                // Section {
                    
                // } header: {
                //     Label("Version \(Bundle.main.releaseVersionNumber ?? "UNKNOWN") (\(buildNumber != 0 ? "\(buildNumber)" : "Release"))", systemImage: "info")
                // }
                
                // Preferences List
                Section {
                    Text("TODO")
                } header: {
                    Label("Preferences", systemImage: "gear")
                }
                
                // Credits List
                Section {
                    LinkCell(imageName: "leminlimez", url: "https://github.com/leminlimez", title: "LeminLimez", contribution: NSLocalizedString("Main Developer", comment: "leminlimez's contribution"), circle: true)
                    LinkCell(imageName: "lessica", url: "https://github.com/Lessica/TrollSpeed", title: "Lessica", contribution: NSLocalizedString("TrollSpeed & Assistive Touch Logic", comment: "lessica's contribution"), circle: true)
                } header: {
                    Label("Credits", systemImage: "wrench.and.screwdriver")
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    // Link Cell code from Cowabunga
    struct LinkCell: View {
        var imageName: String
        var url: String
        var title: String
        var contribution: String
        var systemImage: Bool = false
        var circle: Bool = false
        
        var body: some View {
            HStack(alignment: .center) {
                Group {
                    if systemImage {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        if imageName != "" {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .cornerRadius(circle ? .infinity : 0)
                .frame(width: 24, height: 24)
                
                VStack {
                    HStack {
                        Button(action: {
                            if url != "" {
                                UIApplication.shared.open(URL(string: url)!)
                            }
                        }) {
                            Text(title)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 6)
                        Spacer()
                    }
                    HStack {
                        Text(contribution)
                            .padding(.horizontal, 6)
                            .font(.footnote)
                        Spacer()
                    }
                }
            }
            .foregroundColor(.blue)
        }
    }
}

// MARK: Root View
struct RootView: View {
    var body: some View {
        TabView {
            // Home Page
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            // Widget Customization
            WidgetCustomizationView()
                .tabItem {
                    Label("Customize", systemImage: "paintbrush")
                }
            
            // Settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

// MARK: Objc Bridging
@objc
open class ContentInterface: NSObject {
    @objc
    open func createUI() -> UIViewController {
        let contents = RootView()
        return UIHostingController(rootView: contents)
    }
}
