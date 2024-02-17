//
//  SettingsView.swift
//  Helium UI
//
//  Created by lemin on 10/19/23.
//

import Foundation
import SwiftUI

let buildNumber: Int = 0
let DEBUG_MODE_ENABLED = false
let USER_DEFAULTS_PATH = "/var/mobile/Library/Preferences/com.leemin.helium.plist"

// MARK: Settings View
// TODO: This
struct SettingsView: View {
    // Debug Variables
    @State var sideWidgetSize: Int = 100
    @State var centerWidgetSize: Int = 100
    
    // Preference Variables
    @State var apiKey: String = ""
    @State var dateLocale: String = "en_US"
    @State var hideSaveConfirmation: Bool = false
    @State var debugBorder: Bool = false
    
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
                        Text(NSLocalizedString("Date Locale", comment:""))
                            .bold()
                        Spacer()
                        Picker("", selection: $dateLocale) {
                            Text("en_US").tag("en_US")
                            Text("zh_CN").tag("zh_CN")
                        }
                        .pickerStyle(.menu)
                    }

                    HStack {
                        Text(NSLocalizedString("Weather Api key", comment:""))
                            .bold()
                        Spacer()
                        TextField("", text: $apiKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Toggle(isOn: $hideSaveConfirmation) {
                            Text(NSLocalizedString("Hide Save Confirmation Popup", comment:""))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                    }
                    
                    HStack {
                        Toggle(isOn: $debugBorder) {
                            Text(NSLocalizedString("Display Debug Border", comment:""))
                                .bold()
                                .minimumScaleFactor(0.5)
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
                        }
                        
                        HStack {
                            Text(NSLocalizedString("Center Widget Size", comment:""))
                                .bold()
                            Spacer()
                            TextField(NSLocalizedString("Center Size", comment:""), value: $centerWidgetSize, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                                .submitLabel(.done)
                        }
                    } header: {
                        Label(NSLocalizedString("Debug Preferences", comment:""), systemImage: "ladybug")
                    }
                }
                
                // Credits List
                Section {
                    LinkCell(imageName: "leminlimez", url: "https://github.com/leminlimez", title: "LeminLimez", contribution: NSLocalizedString("Main Developer", comment: "leminlimez's contribution"), circle: true)
                    LinkCell(imageName: "lessica", url: "https://github.com/Lessica/TrollSpeed", title: "Lessica", contribution: NSLocalizedString("TrollSpeed & Assistive Touch Logic", comment: "lessica's contribution"), circle: true)
                    LinkCell(imageName: "Fuuko", url: "https://github.com/AsakuraFuuko", title: "Fuuko", contribution: NSLocalizedString("Modder", comment: "Fuuko's contribution"), circle: true)
                    LinkCell(imageName: "bomberfish", url: "https://github.com/BomberFish", title: "BomberFish", contribution: NSLocalizedString("UI improvements", comment: "BomberFish's contribution"), imageInBundle: true, circle: true)
                } header: {
                    Label(NSLocalizedString("Credits", comment:""), systemImage: "wrench.and.screwdriver")
                }
            }
            .toolbar {
                HStack {
                    Button(action: {
                        saveChanges()
                    }) {
                        Text(NSLocalizedString("Save", comment:""))
                    }
                }
            }
            .onAppear {
                loadSettings()
            }
            .navigationTitle(Text(NSLocalizedString("Settings", comment:"")))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func loadSettings() {
        dateLocale = UserDefaults.standard.string(forKey: "dateLocale", forPath: USER_DEFAULTS_PATH) ?? "en_US"
        apiKey = UserDefaults.standard.string(forKey: "apiKey", forPath: USER_DEFAULTS_PATH) ?? ""
        hideSaveConfirmation = UserDefaults.standard.bool(forKey: "hideSaveConfirmation", forPath: USER_DEFAULTS_PATH)
        debugBorder = UserDefaults.standard.bool(forKey: "debugBorder", forPath: USER_DEFAULTS_PATH)
    }

    func saveChanges() {
        UserDefaults.standard.setValue(apiKey, forKey: "apiKey", forPath: USER_DEFAULTS_PATH)
        UserDefaults.standard.setValue(dateLocale, forKey: "dateLocale", forPath: USER_DEFAULTS_PATH)
        UserDefaults.standard.setValue(hideSaveConfirmation, forKey: "hideSaveConfirmation", forPath: USER_DEFAULTS_PATH)
        UserDefaults.standard.setValue(debugBorder, forKey: "debugBorder", forPath: USER_DEFAULTS_PATH)
        UIApplication.shared.alert(title: NSLocalizedString("Save Changes", comment:""), body: NSLocalizedString("Settings saved successfully", comment:""))
        DarwinNotificationCenter.default.post(name: NOTIFY_RELOAD_HUD)
    }
    
    // Link Cell code from Cowabunga
    struct LinkCell: View {
        var imageName: String
        var url: String
        var title: String
        var contribution: String
        var systemImage: Bool = false
        var imageInBundle: Bool = false
        var circle: Bool = false
        
        var body: some View {
            HStack(alignment: .center) {
                Group {
                    if systemImage {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if imageInBundle {
                        let url = Bundle.main.url(forResource: imageName, withExtension: "png")
                        if url != nil {
                            Image(uiImage: UIImage(contentsOfFile: url!.path)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
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
