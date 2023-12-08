//
//  UserDefaultsExtensions.swift
//
//
//  Created by lemin on 12/8/23.
//

import Foundation

extension UserDefaults {
    // MARK: Managing the Data
    func loadUserDefaults(forPath path: String) -> [String: Any] {
        do {
            let plistData: Data = try Data(contentsOf: URL(fileURLWithPath: path))
            if let dict: [String: Any] = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] {
                return dict
            }
        } catch {
            // file doesn't exist
        }
        return [:]
    }
    
    func setValue(_ value: Any?, forKey key: String, forPath path: String) {
        var dict = loadUserDefaults(forPath: path)
        dict[key] = value
        do {
            let newData: Data = try PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
            try newData.write(to: URL(fileURLWithPath: path))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeObject(forKey defaultName: String, forPath path: String) {
        setValue(nil, forKey: defaultName, forPath: path)
    }
    
    
    // MARK: Specific Type Functions
    
    // string
    func string(forKey defaultName: String, forPath path: String) -> String? {
        let dict = loadUserDefaults(forPath: path)
        return dict[defaultName] as? String
    }
    
    // double
    func double(forKey defaultName: String, forPath path: String) -> Double {
        let dict = loadUserDefaults(forPath: path)
        return dict[defaultName] as? Double ?? 0
    }
    
    // integer
    func integer(forKey defaultName: String, forPath path: String) -> Int {
        let dict = loadUserDefaults(forPath: path)
        return dict[defaultName] as? Int ?? 0
    }
    
    // bool
    func bool(forKey defaultName: String, forPath path: String) -> Bool {
        let dict = loadUserDefaults(forPath: path)
        return dict[defaultName] as? Bool ?? false
    }
    
    // array
    func array(forKey defaultName: String, forPath path: String) -> [Any]? {
        let dict = loadUserDefaults(forPath: path)
        return dict[defaultName] as? [Any]
    }
}
