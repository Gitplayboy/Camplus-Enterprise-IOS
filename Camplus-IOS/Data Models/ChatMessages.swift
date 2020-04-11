//
//  ChatMessages.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-10.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

class ChatMessages {
    class SenderChatMsgs:ChatMessages {
        var chatMessage:String?
        var chatDate:Date?
        init (chatMessage:String?,chatDate:Date?) {
            self.chatMessage = chatMessage
            self.chatDate = chatDate
        }
    }
    
    class RecieverChatMsgs: ChatMessages{
        var chatMessage:String?
        var chatDate:Date?
        init (chatMessage:String?,chatDate:Date?) {
            self.chatMessage = chatMessage
            self.chatDate = chatDate
        }
    }
}
