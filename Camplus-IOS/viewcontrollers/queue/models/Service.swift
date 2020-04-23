//
//  Service.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 14/04/20.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

class Service: Codable {
    var id: String!
    var title: String!
    var isSelected: Bool = false
    var location: String!
    var phone: String!
    
    enum CodingKeys: String, CodingKey {
        case title = "service_name"
        case location
        case phone
    }
}
