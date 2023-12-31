//
//  ContentView.swift
//  
//
//  Created by lemin on 10/11/23.
//

import Foundation
import SwiftUI

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
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            } else {
                // Fallback on earlier versions
            }
            UIApplication.shared.statusBarStyle = .default
            
            do {
                try FileManager.default.contentsOfDirectory(atPath: "/var/mobile")
                // warn to turn on developer mode if iOS 16+
                if #available(iOS 16.0, *), !UserDefaults.standard.bool(forKey: "hasWarnedOfDevMode", forPath: USER_DEFAULTS_PATH) {
                    UIApplication.shared.confirmAlert(title: "Info", body: "Make sure you enable developer mode before using! This will not work otherwise.", onOK: {
                        UserDefaults.standard.setValue(true, forKey: "hasWarnedOfDevMode", forPath: USER_DEFAULTS_PATH)
                    }, noCancel: true)
                }
                return
            } catch {
                UIApplication.shared.alert(title: "Not Supported", body: "This app must be installed with TrollStore.")
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

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
