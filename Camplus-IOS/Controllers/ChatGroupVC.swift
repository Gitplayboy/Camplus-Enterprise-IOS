//
//  ChatGroupVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-11.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchChatTxt:UITextField!
    @IBOutlet weak var groupChatTable: UITableView!
    let chatSvc = ChatsSvcImpl()
    var groupChatPreviewArr = [GroupChatMsgs]()
    var filteredChats = [GroupChatMsgs]()
    var selectedMessageId:String?
    var groupName:String?
    var groupId:String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        chatSvc.fetchActiveGroups(userId: (appDelegate.userDetails.userId)!, success: {(groupChatMsgs) in
            self.groupChatPreviewArr = groupChatMsgs
            self.filteredChats = self.groupChatPreviewArr
            self.groupChatTable.reloadData()
        }, failure: {(error) in
            print(error)
        })
        searchChatTxt.setLeftPaddingPoints(30)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupCell") as! GroupChatCell
        cell.groupNameLbl.text = filteredChats[indexPath.row].groupName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessageId = self.filteredChats[indexPath.row].messageId
        groupName = self.filteredChats[indexPath.row].groupName
        groupId = self.filteredChats[indexPath.row].groupId
        performSegue(withIdentifier: "groupChat", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupChat" {
            if let destination = segue.destination as? ChatMessageVC {
                destination.isGroupChat = true
                destination.groupName = groupName
                destination.groupId = groupId
                destination.messageId = selectedMessageId
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var isFound = false
        if searchChatTxt.text != nil && !searchChatTxt.text!.isEmpty {
            filteredChats = []
            for chats in groupChatPreviewArr {
                if chats.groupName!.lowercased().contains(searchChatTxt!.text!.lowercased()) {
                    filteredChats.append(chats)
                    isFound = true
                }
            }
            if isFound {
                groupChatTable.reloadData()
            } else {
                groupChatTable.reloadData()
                //NotesNotFoundVC.isHidden = false
            }
            
        } else {
            filteredChats = groupChatPreviewArr
            groupChatTable.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
