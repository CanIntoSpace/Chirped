//
//  Dictionary+Ext.swift
//  Utils
//
//  Created by Michal Nierebinski on 29/12/2022.
//

import Foundation

extension Dictionary {
    func adding(key: Key, value: Value) -> Dictionary {
        var copy = self
        copy[key] = value
        return copy
    }
}
