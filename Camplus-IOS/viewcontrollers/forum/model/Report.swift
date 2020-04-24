//
//  Report.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 24/04/20.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

class Report : Codable {
    var userId: String!
    var forumId: String!
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case forumId = "forum_id"
    }
}
