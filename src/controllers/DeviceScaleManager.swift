//
//  DeviceScaleManager.swift
//
//
//  Created by lemin on 12/15/23.
//

import Foundation
import SwiftUI

struct PresetStruct: Identifiable {
    var id = UUID()
    
    var width: Double
    var offsetX: Double
    var offsetY: Double
}

enum Preset: String, CaseIterable {
    case above = "Above Status Bar"
    case below = "Below Status Bar"
}

class DeviceScaleManager {
    static let shared = DeviceScaleManager()
    
    private func getDeviceName() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let deviceModel = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)

        return deviceModel ?? ""
    }
    
    /*
     Sizes:
     0 = No Notch
     1 = Small Notch
     2 = Large Notch
     3 = Dynamic Island
     */
    private func getDeviceSize() -> Int {
        let deviceModel: String = getDeviceName()
        
        // get the notch size
        if (deviceModel.starts(with: "iPhone14")) {
            // Small Notch
            return 1
        } else if (
            deviceModel.starts(with: "iPhone10,3")
            || deviceModel.starts(with: "iPhone10,6")
            || deviceModel.starts(with: "iPhone11")
            || deviceModel.starts(with: "iPhone12")
            || deviceModel.starts(with: "iPhone13")
        ) {
            // Big Notch
            return 2
        } else if (
            deviceModel.starts(with: "iPhone15")
            || deviceModel.starts(with: "iPhone16")
        ) {
            // Dynamic Island
            return 3
        }
        return 0
    }
}
