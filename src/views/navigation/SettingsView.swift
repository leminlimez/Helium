//
//  SettingsView.swift
//  Helium UI
//
//  Created by lemin on 10/19/23.
//

import Foundation
import SwiftUI

let buildNumber: Int = 1
let DEBUG_MODE_ENABLED = false
let USER_DEFAULTS_PATH = "/var/mobile/Library/Preferences/com.leemin.helium.plist"

// MARK: Settings View
// TODO: This
struct SettingsView: View {
    // Debug Variables
    @State var sideWidgetSize: Int = 100
    @State var centerWidgetSize: Int = 100
    
    // Preference Variables
    @State var updateInterval: Double = 1.0
    @State var usesRotation: Bool = false
    @State var hideSaveConfirmation: Bool = false
    @State var ignoreSafeZone: Bool = false
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                // App Version/Build Number
                Section {
                    
                } header: {
                    Label(NSLocalizedString("Version ", comment:"") + "\(Bundle.main.releaseVersionNumber ?? NSLocalizedString("UNKNOWN", comment:"")) (\(buildNumber != 0 ? "\(buildNumber)" : NSLocalizedString("Release", comment:"")))", systemImage: "info")
                }
                
                // Preferences List
                Section {
                    HStack {
                        Text(NSLocalizedString("Update Interval (seconds)", comment:""))
                            .bold()
                        Spacer()
                        if #available(iOS 15, *) {
                            TextField(NSLocalizedString("Seconds", comment:""), value: $updateInterval, formatter: formatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            //                            .keyboardType(.decimalPad)
                                .submitLabel(.done)
                                .onSubmit {
                                    if updateInterval <= 0 {
                                        updateInterval = 1
                                    }
                                    UserDefaults.standard.setValue(updateInterval, forKey: "updateInterval", forPath: USER_DEFAULTS_PATH)
                                }
                                .onAppear {
                                    updateInterval = UserDefaults.standard.double(forKey: "updateInterval", forPath: USER_DEFAULTS_PATH)
                                    if updateInterval <= 0 {
                                        updateInterval = 1
                                    }
                                }
                        } else {
                            TextField(NSLocalizedString("Seconds", comment:""), value: $updateInterval, formatter: formatter)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onChange(of: updateInterval) { nv in
                                    if updateInterval <= 0 {
                                        updateInterval = 1
                                    }
                                    UserDefaults.standard.setValue(updateInterval, forKey: "updateInterval", forPath: USER_DEFAULTS_PATH)
                                }
                                .onAppear {
                                    updateInterval = UserDefaults.standard.double(forKey: "updateInterval", forPath: USER_DEFAULTS_PATH)
                                    if updateInterval <= 0 {
                                        updateInterval = 1
                                    }
                                }
                        }
                    }
                    
                    HStack {
                        Toggle(isOn: $usesRotation) {
                            Text(NSLocalizedString("Show when Rotating", comment:""))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: usesRotation) { _ in
                            UserDefaults.standard.setValue(usesRotation, forKey: "usesRotation", forPath: USER_DEFAULTS_PATH)
                        }
                        .onAppear {
                            usesRotation = UserDefaults.standard.bool(forKey: "usesRotation", forPath: USER_DEFAULTS_PATH)
                        }
                    }
                    
                    HStack {
                        Toggle(isOn: $hideSaveConfirmation) {
                            Text(NSLocalizedString("Hide Save Confirmation Popup", comment:""))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: hideSaveConfirmation) { _ in
                            UserDefaults.standard.setValue(hideSaveConfirmation, forKey: "hideSaveConfirmation", forPath: USER_DEFAULTS_PATH)
                        }
                        .onAppear {
                            hideSaveConfirmation = UserDefaults.standard.bool(forKey: "hideSaveConfirmation", forPath: USER_DEFAULTS_PATH)
                        }
                    }
                    
                    HStack {
                        Toggle(isOn: $ignoreSafeZone) {
                            Text(NSLocalizedString("Ignore Safe Zone Changes", comment:""))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onChange(of: ignoreSafeZone) { _ in
                            UserDefaults.standard.setValue(ignoreSafeZone, forKey: "ignoreSafeZone", forPath: USER_DEFAULTS_PATH)
                        }
                        .onAppear {
                            ignoreSafeZone = UserDefaults.standard.bool(forKey: "ignoreSafeZone", forPath: USER_DEFAULTS_PATH)
                        }
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Helium Data", comment:""))
                            .bold()
                        Spacer()
                        Button(action: {
                            do {
                                try UserDefaults.standard.deleteUserDefaults(forPath: USER_DEFAULTS_PATH)
                                UIApplication.shared.alert(title: NSLocalizedString("Successfully deleted user data!", comment:""), body: NSLocalizedString("Please restart the app to continue.", comment:""))
                            } catch {
                                UIApplication.shared.alert(title: NSLocalizedString("Failed to delete user data!", comment:""), body: error.localizedDescription)
                            }
                        }) {
                            Text(NSLocalizedString("Reset Data", comment:""))
                                .foregroundColor(.red)
                        }
                    }
                } header: {
                    Label(NSLocalizedString("Preferences", comment:""), systemImage: "gear")
                }
                
                // Debug Settings
                if #available(iOS 15, *), DEBUG_MODE_ENABLED {
                    Section {
                        HStack {
                            Text(NSLocalizedString("Side Widget Size", comment:""))
                                .bold()
                            Spacer()
                            TextField(NSLocalizedString("Side Size", comment:""), value: $sideWidgetSize, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                                .onSubmit {
                                    UserDefaults.standard.setValue(sideWidgetSize, forKey: "DEBUG_sideWidgetSize", forPath: USER_DEFAULTS_PATH)
                                }
                                .onAppear {
                                    sideWidgetSize = UserDefaults.standard.integer(forKey: "DEBUG_sideWidgetSize", forPath: USER_DEFAULTS_PATH)
                                }
                        }
                        
                        HStack {
                            Text(NSLocalizedString("Center Widget Size", comment:""))
                                .bold()
                            Spacer()
                            TextField(NSLocalizedString("Center Size", comment:""), value: $centerWidgetSize, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                                .onSubmit {
                                    UserDefaults.standard.setValue(centerWidgetSize, forKey: "DEBUG_centerWidgetSize", forPath: USER_DEFAULTS_PATH)
                                }
                                .onAppear {
                                    centerWidgetSize = UserDefaults.standard.integer(forKey: "DEBUG_centerWidgetSize", forPath: USER_DEFAULTS_PATH)
                                }
                        }
                    } header: {
                        Label(NSLocalizedString("Debug Preferences", comment:""), systemImage: "ladybug")
                    }
                }
                
                // Credits List
                Section {
                    LinkCell(imageName: "leminlimez", url: "https://github.com/leminlimez", title: "LeminLimez", contribution: NSLocalizedString("Main Developer", comment: "leminlimez's contribution"), circle: true)
                    LinkCell(imageName: "lessica", url: "https://github.com/Lessica/TrollSpeed", title: "Lessica", contribution: NSLocalizedString("TrollSpeed & Assistive Touch Logic", comment: "lessica's contribution"), circle: true)
                } header: {
                    Label(NSLocalizedString("Credits", comment:""), systemImage: "wrench.and.screwdriver")
                }
            }
            .navigationTitle(NSLocalizedString("Settings", comment:""))
            .navigationViewStyle(.stack)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
