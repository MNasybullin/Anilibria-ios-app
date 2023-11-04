//
//  AsyncDictionary.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import Foundation

actor AsyncDictionary<A, B> where A: Hashable {
    private var dictionary: [A: B] = [:]
    
    func get(_ key: A) -> B? {
        return dictionary[key]
    }
    
    func set(_ key: A, value: B?) {
        dictionary[key] = value
    }
    
    func removeAll() {
        dictionary.removeAll()
    }
}
