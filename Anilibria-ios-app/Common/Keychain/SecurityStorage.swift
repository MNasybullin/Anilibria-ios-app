//
//  SecurityStorage.swift
//  Anilibria-ios-app
//
//  Created by Mansur Nasybullin on 05.10.2023.
//

import Foundation
import Security

class SecurityStorage {
    enum KeychainError: Error {
        case itemAlreadyExist
        case itemNotFound
        case unexpectedSecureData
        case errorStatus(String?)
        
        init(status: OSStatus) {
            switch status {
                case errSecDuplicateItem:
                    self = .itemAlreadyExist
                case errSecItemNotFound:
                    self = .itemNotFound
                default:
                    let message = SecCopyErrorMessageString(status, nil) as String?
                    self = .errorStatus(message)
            }
        }
    }
    
    enum AttrLabels: String {
        case credentials
    }
    
    enum AttrAccount: String {
        case session
    }
    
    private func addItem(query: [String: Any]) throws {
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
    
    private func findItem(query: [String: Any]) throws -> [String: Any]? {
        var query = query
        query[kSecReturnAttributes as String] = true
        query[kSecReturnData as String] = true
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != errSecSuccess {
            throw KeychainError(status: status)
        } else {
            return item as? [String: Any]
        }
    }
    
    private func updateItem(query: [String: Any], attributesToUpdate: [String: Any]) throws {
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
    
    private func deleteItem(query: [String: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError(status: status)
        }
    }
}

// MARK: - Credentials

extension SecurityStorage {
    struct Credentials {
        var login: String
        var password: String
    }
    
    func addCredentials(_ credentials: Credentials, 
                        withLabel label: String = AttrLabels.credentials.rawValue) throws {
        let account = credentials.login
        let password = credentials.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrLabel as String: label,
                                    kSecValueData as String: password]
        try addItem(query: query)
    }
    
    func updateCredentials(_ credentials: Credentials, 
                           withLabel label: String = AttrLabels.credentials.rawValue) throws {
        try deleteCredentials(withLabel: label)
        try addCredentials(credentials, withLabel: label)
    }
    
    func addOrUpdateCredentials(_ credentials: Credentials, 
                                withLabel label: String = AttrLabels.credentials.rawValue) throws {
        do {
            try addCredentials(credentials, withLabel: label)
        } catch KeychainError.itemAlreadyExist {
            try updateCredentials(credentials, withLabel: label)
        }
    }
    
    func getCredentials(withLabel label: String = AttrLabels.credentials.rawValue) throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: label]
        
        let item: [String: Any]? = try findItem(query: query)
        
        guard let passwordData = item?[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let account = item?[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedSecureData
        }
        return Credentials(login: account, password: password)
    }
    
    func deleteCredentials(withLabel label: String = AttrLabels.credentials.rawValue) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: label]
        try deleteItem(query: query)
    }
}

// MARK: - Session

extension SecurityStorage {
    func addSession(_ sessionId: String, 
                    withAccount account: String = AttrAccount.session.rawValue) throws {
        let sessionData = sessionId.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: sessionData]
        try addItem(query: query)
    }
    
    func updateSession(_ sessionId: String, 
                       withAccount account: String = AttrAccount.session.rawValue) throws {
        try deleteSession(withAccount: account)
        try addSession(sessionId, withAccount: account)
    }
    
    func addOrUpdateSession(_ sessionId: String,
                            withAccount account: String = AttrAccount.session.rawValue) throws {
        do {
            try addSession(sessionId, withAccount: account)
        } catch KeychainError.itemAlreadyExist {
            try updateSession(sessionId, withAccount: account)
        }
    }
    
    func getSession(withAccount account: String = AttrAccount.session.rawValue) throws -> String {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account]
        
        let item: [String: Any]? = try findItem(query: query)
        
        guard let sessionData = item?[kSecValueData as String] as? Data,
              let sessionId = String(data: sessionData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedSecureData
        }
        return sessionId
    }
    
    func deleteSession(withAccount account: String = AttrAccount.session.rawValue) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account]
        try deleteItem(query: query)
    }
}
