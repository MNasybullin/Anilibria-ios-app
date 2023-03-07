//
//  Cache.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 07.03.2023.
//

import Foundation

// https://www.swiftbysundell.com/articles/caching-in-swift/

final class Cache<Key: Hashable, Value> {
    private var wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
    }
    
    func insert(_ value: Value, forKey key: Key) {
        let date = dateProvider().addingTimeInterval(entryLifetime)
        let entry = Entry(value: value, exprirationDate: date)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }
    
    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        
        return entry.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}

private extension Cache {
    final class Entry {
        let value: Value
        let expirationDate: Date
        
        init(value: Value, exprirationDate: Date) {
            self.value = value
            self.expirationDate = exprirationDate
        }
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}
