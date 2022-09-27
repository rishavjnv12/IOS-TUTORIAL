//
//  DatabaseManager.swift
//  iOSLearningApp
//
//  Created by Rishav Kumar on 18/09/22.
//

import Foundation

public class DatabaseManger {
    public static let shared = DatabaseManger()
    
    private init() { }
    
    public func getValue(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public func setValue(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func removeForKey(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

