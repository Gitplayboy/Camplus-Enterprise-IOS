//
//  Token.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 20/04/20.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

public struct Token: Codable {
    var id: String!
    var onDate: String!
    var token: Int!
    var timestamp: Int64!
    var userId: String!
    var status: Int!
    var tokenDate: Int64!
    var tokenTime: String = "N/A"
    var serviceTitle: String!
    var serviceId: String!
    var serviceLocation: String!
    var servicePhone: String!
    
    enum CodingKeys: String, CodingKey {
        case onDate = "on_date"
        case token
        case timestamp
        case userId = "user_id"
        case status
        case tokenDate = "token_date"
        case tokenTime = "token_time"
        case serviceTitle = "service_title"
        case serviceId = "service_id"
        case serviceLocation = "service_location"
        case servicePhone = "service_phone"
    }
}
