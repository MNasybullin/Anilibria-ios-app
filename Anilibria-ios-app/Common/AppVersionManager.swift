//
//  AppVersionManager.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 10.04.2024.
//

import Foundation

struct AppVersionManager {
    var currentVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Version format = 0.0.0
    func currentVersionIsLessThan(version: String) -> Bool {
        guard let currentVersion = currentVersion else {
            return false
        }
        
        let currentComponents = currentVersion.components(separatedBy: ".")
        let newComponents = version.components(separatedBy: ".")
        
        for (current, new) in zip(currentComponents, newComponents) {
            // Если компоненты различаются, возвращаем результат сравнения
            if let currentNumber = Int(current), let newNumber = Int(new) {
                if currentNumber < newNumber {
                    return true
                } else if currentNumber > newNumber {
                    return false
                }
            } else {
                // Если не удается преобразовать компоненты в числа, возвращаем false
                return false
            }
        }
        // Если все компоненты совпадают, а новых компонентов больше нет, версии равны
        return false
    }
}
