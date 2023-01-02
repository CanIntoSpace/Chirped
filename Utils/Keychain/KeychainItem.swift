//
//  KeychainItem.swift
//  Utils
//
//  Created by Michal Nierebinski on 29/12/2022.
//

import Foundation
import Security

@propertyWrapper
public final class KeychainItem {
    private let account: String
    private let accessGroup: String?

    public init(account: String) {
        self.account = account
        accessGroup = nil
    }

    public init(account: String, accessGroup: String) {
        self.account = account
        self.accessGroup = accessGroup
    }

    private var baseDictionary: [String: AnyObject] {
        let base = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrSynchronizable as String: kCFBooleanTrue!,
        ]

        return accessGroup == nil
            ? base
            : base.adding(key: kSecAttrAccessGroup as String, value: accessGroup as AnyObject)
    }

    private var query: [String: AnyObject] {
        baseDictionary.adding(key: kSecMatchLimit as String, value: kSecMatchLimitOne)
    }

    public var wrappedValue: String? {
        get {
            try? read()
        }
        set {
            if let v = newValue {
                if let _ = try? read() {
                    try! update(v)
                } else {
                    try! add(v)
                }
            } else {
                try? delete()
            }
        }
    }
}

private extension KeychainItem {
    func delete() throws {
        // SecItemDelete seems to fail with errSecItemNotFound if the item does not exist in the keychain. Is this expected behavior?
        let status = SecItemDelete(baseDictionary as CFDictionary)
        guard status != errSecItemNotFound else { return }
        try throwIfNotZero(status)
    }

    func read() throws -> String? {
        let query = query.adding(key: kSecReturnData as String, value: true as AnyObject)
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status != errSecItemNotFound else { return nil }
        try throwIfNotZero(status)
        guard let data = result as? Data, let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }
        return string
    }

    func update(_ secret: String) throws {
        let dictionary: [String: AnyObject] = [
            kSecValueData as String: secret.data(using: String.Encoding.utf8)! as AnyObject,
        ]
        try throwIfNotZero(SecItemUpdate(baseDictionary as CFDictionary, dictionary as CFDictionary))
    }

    func add(_ secret: String) throws {
        let dictionary = baseDictionary.adding(key: kSecValueData as String, value: secret.data(using: .utf8)! as AnyObject)
        try throwIfNotZero(SecItemAdd(dictionary as CFDictionary, nil))
    }

    func throwIfNotZero(_ status: OSStatus) throws {
        guard status != 0 else { return }
        throw KeychainError.keychainError(status: status)
    }
}
