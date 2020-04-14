//
//  ChatMessages.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-10.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatMessages {
    class SenderChatMsgs:ChatMessages {
        var chatMessage:String?
        var chatDate:Date?
        var senderName:String?
        init (chatMessage:String?,chatDate:Date?,senderName:String?) {
            self.chatMessage = chatMessage
            self.chatDate = chatDate
            self.senderName = senderName
        }
    }
    
    class RecieverChatMsgs: ChatMessages{
        var chatMessage:String?
        var chatDate:Date?
        var senderName:String?
        init (chatMessage:String?,chatDate:Date?,senderName:String?) {
            self.chatMessage = chatMessage
            self.chatDate = chatDate
            self.senderName = senderName
        }
    }
}

class ChatPreviewMsgs {
    var senderName:String?
    var senderDpName:String?
    var lastMsg:String?
    var messageId:String?
    
    init(senderName: String?, senderDpName: String?, lastMsg: String?, messageId:String?) {
        self.senderName = senderName
        self.senderDpName = senderDpName
        self.lastMsg = lastMsg
        self.messageId = messageId
    }
}

class GroupChatMsgs {
    var messageId:String?
    var groupName:String?
    var groupMembers:[String]?
    var groupId:String?
    
    init(messageId: String? , groupName: String?, groupMembers: [String]?,groupId:String?) {
        self.messageId = messageId
        self.groupName = groupName
        self.groupMembers = groupMembers
        self.groupId = groupId
    }
}
