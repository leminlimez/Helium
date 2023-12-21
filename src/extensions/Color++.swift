//
//  Color++.swift
//  Cowabunga
//
//  Created by sourcelocation on 30/01/2023.
//

import SwiftUI

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
    var data: Data? {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            return data
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
        return nil
    }
    
    static func getColorFromData(data colorData: Data?) -> UIColor? {
        guard let colorDataUnwrapped = colorData else { return nil; }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorDataUnwrapped)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
    }
}

extension Color {
    init(uiColor14: UIColor) {
        self.init(red: Double(uiColor14.rgba.red),
                  green: Double(uiColor14.rgba.green),
                  blue: Double(uiColor14.rgba.blue),
                  opacity: Double(uiColor14.rgba.alpha))
    }
    
    init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, opacity: a)
                    return
                }
            } else if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff00) / 255

                    self.init(red: r, green: g, blue: b)
                    return
                }
            }
        }

        return nil
    }
}
