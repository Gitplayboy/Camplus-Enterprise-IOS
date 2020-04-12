//
//  ChatsSvc.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

protocol ChatsSvc {
    func fetchActiveChats(username:String)
    func fetchGroupChatInfo(username:String)
}

class ChatsSvcImpl {
    
}
