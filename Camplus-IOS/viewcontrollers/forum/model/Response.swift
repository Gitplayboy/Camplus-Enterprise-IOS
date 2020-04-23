//
//  ForumResponse.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 11/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import FirebaseCore
import FirebaseFirestoreSwift

public struct Response: ForumTableDelegate, Codable {
    var comment: String!
    var timestamp: Int64!
    var user_name: String!
    var user_id: String!
    
    enum CodingKeys: String, CodingKey {
        case comment
        case timestamp
        case user_name
        case user_id
    }
    
    
}
