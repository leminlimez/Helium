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
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UIApplication.shared.statusBarStyle = .default
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
