//
//  ThreadSafeDictionary.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 02.03.2024.
//

import Foundation

class ThreadSafeDictionary<Key: Hashable, Value> {
    private var dictionary: [Key: Value] = [:]
    private var lock = NSLock()

    subscript(key: Key) -> Value? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return dictionary[key]
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            dictionary[key] = newValue
        }
    }

    func removeValue(forKey key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        return dictionary.removeValue(forKey: key)
    }

    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        dictionary.removeAll()
    }

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return dictionary.count
    }
    
    var values: Dictionary<Key, Value>.Values {
        lock.lock()
        defer { lock.unlock() }
        return dictionary.values
    }
}
