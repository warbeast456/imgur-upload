//
//  UserCache.swift
//  EngIdeaExercise
//
//  Created by MSQUARDIAN on 7/29/19.
//  Copyright © 2019 MSQUARDIAN. All rights reserved.
//

import Foundation

///Simple bridge to UserDefaults
struct UserURLCache {
    static let key = "URLList"
    
    static func save(_ value: String) {
        var cache = get()
        cache.append(value)
        UserDefaults.standard.set(cache, forKey: key)
    }
    
    static func get() -> [String] {
        if let data = UserDefaults.standard.stringArray(forKey: key) {
            return data
        } else {
            return []
        }
    }
    
}
