//
//  Forum.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 11/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import FirebaseCore
import FirebaseFirestoreSwift


public struct Forum: ForumTableDelegate, Codable {
    var id: String!
    var title: String!
    var description: String!
    var categories: [String]!
    var category: String!
    var timestamp: Int64!
    var user_name: String!
    var user_id: String!
    var reportCount: Int = 0
    var responseCount: Int = 0
    var isReport: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case categories
        case timestamp
        case user_name
        case user_id
        case reportCount = "report_count"
        case responseCount = "response_count"
    }
}
