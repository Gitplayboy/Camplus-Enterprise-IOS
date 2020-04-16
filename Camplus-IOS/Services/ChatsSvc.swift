//
//  ChatsSvc.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol ChatsSvc {
    func fetchActiveChatMessages(messageId: String,userId:String,success:@escaping (_ chatMsgsArr:[ChatMessages])->(),failure:@escaping (_ error:Error)->())
    func fetchDirectMessageChats(userId: String,success:@escaping (_ chatMsgsArr:[ChatPreviewMsgs])->(),failure:@escaping (_ error:Error)->())
    func fetchActiveGroups(userId: String,success:@escaping (_ dataArr:[GroupChatMsgs])->(),failure:@escaping (_ error:Error)->())
    func fetchGroupChatMessages(userId: String,messageId: String, success:@escaping (_ dataArr:[ChatMessages])->(),failure:@escaping (_ error:Error)->())
    func sendDirectMessage(messageId:String, userId:String, messageText:String, senderName:String) 
}

class ChatsSvcImpl: ChatsSvc {
    let db = Firestore.firestore()
    
    func fetchActiveChatMessages(messageId: String,userId: String,success:@escaping (_ chatMsgsArr:[ChatMessages])->(),failure:@escaping (_ error:Error)->()) {
        
        db.collection("messages").addSnapshotListener {(snapshot, err) in
            var chatMsgs = [ChatMessages]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    if messageId == document.documentID {
                        if (document.get("sender_id") as? String == userId) ||
                            (document.get("receiver_id") as? String == userId) {
                            let messages = document.data()["message_map"]! as! [AnyObject]
                            for index in 0..<messages.count {
                                if let msgField = messages[index] as? [String : Any] {
                                    if msgField["sender_id"] as? String == userId {
                                        chatMsgs.append(ChatMessages.RecieverChatMsgs(chatMessage: msgField["message_text"] as? String, chatDate: self.getDateTimestamp(fromTimeStamp: (msgField["message_time"] as! TimeInterval)),senderName: msgField["sender_name"] as? String))
                                    } else {
                                        chatMsgs.append(ChatMessages.SenderChatMsgs(chatMessage: msgField["message_text"] as? String, chatDate: self.getDateTimestamp(fromTimeStamp: (msgField["message_time"] as! TimeInterval)),senderName: msgField["sender_name"] as? String))
                                    }
                                }
                            }
                        }
                        break
                    }
                }
                success(chatMsgs)
            }
        }
    }
    
    func fetchDirectMessageChats(userId: String,success:@escaping (_ chatMsgsArr:[ChatPreviewMsgs])->(),failure:@escaping (_ error:Error)->()) {
        
        db.collection("messages").addSnapshotListener {(snapshot, err) in
            var chatPreview = [ChatPreviewMsgs]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    if (document.get("sender_id") as? String == userId) {                        chatPreview.append(ChatPreviewMsgs(senderName: document.get("receiver_name") as? String, senderDpName: String(((document.get("receiver_name") as? String)?.prefix(2))!).uppercased(), lastMsg: document.get("last_msg") as? String, messageId: document.documentID, lastMsgTime: self.getLastTime(fromTimeStamp: (document.get("last_msg_time") as? TimeInterval)!)))
                    } else if (document.get("receiver_id") as? String == userId) {
                        chatPreview.append(ChatPreviewMsgs(senderName: document.get("sender_name") as? String, senderDpName: String(((document.get("sender_name") as? String)?.prefix(2))!).uppercased(), lastMsg: document.get("last_msg") as? String, messageId: document.documentID, lastMsgTime: self.getLastTime(fromTimeStamp: (document.get("last_msg_time") as? TimeInterval)!) ))
                    }
                }
                success(chatPreview)
            }
        }
    }
    
    func fetchActiveGroups(userId: String,success:@escaping (_ dataArr:[GroupChatMsgs])->(),failure:@escaping (_ error:Error)->()) {
        
        db.collection("chat_groups").addSnapshotListener {(snapshot, err) in
            var groupChatMsgsArr = [GroupChatMsgs]()
            var groupChatInfo:GroupChatMsgs?
            var isUserPresentInGroup = false;
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let groupMembersArr = document.data()["group_members"] as! [String]
                    let message_id = document.get("chat_message_id") as! String
                    let groupName = document.get("group_name") as! String
                    let groupId = document.documentID
                    //check if the group members have the user id
                    for index in 0..<groupMembersArr.count {
                        let groupMember = groupMembersArr[index]
                        if groupMember == userId {
                            isUserPresentInGroup = true
                        }
                    }
                    if isUserPresentInGroup {
                        groupChatInfo = GroupChatMsgs(messageId: message_id, groupName: groupName, groupMembers: groupMembersArr, groupId: groupId)
                        groupChatMsgsArr.append(groupChatInfo!)
                    }
                }
                success(groupChatMsgsArr)
            }
        }
    }
    
    func fetchGroupChatMessages(userId: String,messageId: String, success:@escaping (_ dataArr:[ChatMessages])->(),failure:@escaping (_ error:Error)->()) {
        
        db.collection("messages").addSnapshotListener {(snapshot, err) in
            var chatMsgs = [ChatMessages]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    if document.documentID == messageId {
                        let messages = document.data()["message_map"]! as! [AnyObject]
                        for index in 0..<messages.count {
                            let msgField = messages[index] as? [String : Any]
                            if msgField!["sender_id"] != nil {
                                if msgField!["sender_id"] as? String == userId {
                                    chatMsgs.append(ChatMessages.RecieverChatMsgs(chatMessage: msgField!["message_text"] as? String, chatDate: self.getDateTimestamp(fromTimeStamp: (msgField!["message_time"] as? TimeInterval)!),senderName: msgField!["sender_name"] as? String))
                                } else {
                                    chatMsgs.append(ChatMessages.SenderChatMsgs(chatMessage: msgField!["message_text"] as? String, chatDate: self.getDateTimestamp(fromTimeStamp: (msgField!["message_time"] as? TimeInterval)!),senderName: msgField!["sender_name"] as? String))
                                }
                            }
                        }
                        break
                    }
                }
                success(chatMsgs)
            }
        }
    }
    
    func sendDirectMessage(messageId:String, userId:String, messageText:String, senderName:String) {
        var msgField = [String:Any]()
        msgField["message_text"] = messageText
        msgField["sender_id"] = userId
        msgField["sender_name"] = senderName
        msgField["message_time"] = Date().timeIntervalSince1970
        
        let messageRef = self.db.collection("messages").document(messageId)
        messageRef.setData(["last_msg":messageText], merge: true)
        messageRef.setData(["message_time":Date().timeIntervalSince1970], merge: true)
        messageRef.updateData([
            "message_map": FieldValue.arrayUnion([msgField])
        ])
    }
    
    func sendNewDirectMessage(receiverId:String,receiverName:String, messageText:String,success:@escaping (_ chatMsgsArr:[ChatMessages],_ messageId:String)->(),failure:@escaping (_ error:Error)->()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var messageDocument = [String:Any]()
        messageDocument["is_direct_message"] = true
        messageDocument["last_msg"] = messageText
        messageDocument["receiver_id"] = receiverId
        messageDocument["receiver_name"] = receiverName
        messageDocument["sender_name"] = appDelegate.userDetails.userName
        messageDocument["sender_id"] = appDelegate.userDetails.userId
        messageDocument["message_time"] = Date().timeIntervalSince1970
        messageDocument["message_map"] = [["message_text" : messageText, "sender_id" : appDelegate.userDetails.userId, "sender_name" : appDelegate.userDetails.userName, "message_time": Date().timeIntervalSince1970]]
        let documentId = db.collection("messages").addDocument(data: messageDocument).documentID
        fetchActiveChatMessages(messageId: documentId, userId: appDelegate.userDetails.userId!, success: {(chatMsgs) in
            success(chatMsgs,documentId)
        }, failure: {(error) in
            print(error)
        })
    }
    
    func fetchGroupMembers(groupId:String, success:@escaping (_ dataArr:[UserDetails])->(),failure:@escaping (_ error:Error)->()) {
        
        db.collection("chat_groups").document(groupId).getDocument(completion: {(snapshot, err) in
            var userDetailsArr = [UserDetails]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshot = snapshot {
                    let groupMembers = snapshot.data()!["group_members"] as? [String]
                    for userId in groupMembers! {
                        self.db.collection("tbl_user").whereField("user_id", isEqualTo: userId).getDocuments(completion: {(snapshot, err) in
                            
                            let userDetailsObj = UserDetails()
                            userDetailsObj.userId = userId
                            for document in snapshot!.documents {
                                userDetailsObj.userName = document["username"] as? String
                            }
                            userDetailsArr.append(userDetailsObj)
                            if(userDetailsArr.count == groupMembers?.count) {
                                success(userDetailsArr)
                            }
                        })
                    }
                    
                }
            }
        })
    }
    
    func fetchMessageId(targetUserId:String,success:@escaping (_ messageId:String)->(),failure:@escaping (_ error:String)->()) {
        
        var isOldChatAvailable = false
        db.collection("messages").whereField("is_direct_message", isEqualTo: true).getDocuments(completion: {(snapshot,err) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let currentUserId = appDelegate.userDetails.userId
            for document in snapshot!.documents {
                if ((document.data()["sender_id"] as? String) == currentUserId
                    && (document.data()["receiver_id"] as? String) == targetUserId)
                    || ((document.data()["sender_id"] as? String) == targetUserId
                        && (document.data()["receiver_id"] as? String) == currentUserId){
                    isOldChatAvailable = true
                    success(document.documentID)
                    break
                }
            }
            
            if !isOldChatAvailable {
                failure("No Message Id")
            }
        })
    }
    
    func getDateTimestamp(fromTimeStamp timestamp: TimeInterval) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        return dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    
    func getLastTime(fromTimeStamp timestamp: TimeInterval) -> String {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone.current
        dayTimePeriodFormatter.dateFormat = "mm"
        let timeSince = dayTimePeriodFormatter.string(from: Date(timeIntervalSinceNow: timestamp))
        var timeStr = "\(timeSince) mins ago"
        if Int(timeSince)! > 60 {
            timeStr = "1 hour +"
        }
        return timeStr
    }
}
