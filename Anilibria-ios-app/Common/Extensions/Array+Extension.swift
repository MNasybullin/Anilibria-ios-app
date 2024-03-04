//
//  Array+Extension.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 04.03.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
