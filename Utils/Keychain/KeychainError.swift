//
//  KeychainError.swift
//  Utils
//
//  Created by Michal Nierebinski on 29/12/2022.
//

import Foundation
import Security

public enum KeychainError: Error {
    case invalidData
    case keychainError(status: OSStatus)
}
