//
//  ThreadSafeDictionary.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 20.10.2023.
//

import Foundation

class ThreadSafeDictionary<A, B> where A: Hashable {
    var dictionary: [A: B] = [:]
    let queue = DispatchQueue(label: "com.nasybullin.threadSafeDictionary", attributes: .concurrent)
    
    subscript(_ key: A) -> B? {
        get {
            var result: B?
            queue.sync {
                result = self.dictionary[key]
            }
            return result
        }
        set {
            queue.async(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
    }
}
