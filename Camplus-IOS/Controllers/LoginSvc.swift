//
//  LoginService.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

protocol LoginService {
    func fetchUserDetails(userId:String)
    func verifyUserLogin(userId:String, password:String)
}

class LoginServiceImpl {
    
}
