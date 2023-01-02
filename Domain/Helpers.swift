//
//  Helpers.swift
//  Domain
//
//  Created by Michal Nierebinski on 29/12/2022.
//

import Foundation
import struct Twift.List
import struct Twift.User

public typealias TwitterList = Twift.List

public let allUserFields: Set<Twift.User.Field> = [
    \.createdAt,
    \.description,
    \.entities,
    \.location,
    \.pinnedTweetId,
    \.profileImageUrl,
    \.protected,
    \.publicMetrics,
    \.url,
    \.verified,
    \.withheld,
]
