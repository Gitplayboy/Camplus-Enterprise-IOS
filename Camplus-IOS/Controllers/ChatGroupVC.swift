//
//  ChatGroupVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-11.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupChatTable: UITableView!
    let chatSvc = ChatsSvcImpl()
    var groupChatPreviewArr = [GroupChatMsgs]()
    var selectedMessageId:String?
    var groupName:String?
    var groupId:String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        chatSvc.fetchActiveGroups(userId: (appDelegate.userDetails.userId)!, success: {(groupChatMsgs) in
            self.groupChatPreviewArr = groupChatMsgs
            self.groupChatTable.reloadData()
        }, failure: {(error) in
            print(error)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupChatPreviewArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupCell") as! GroupChatCell
        cell.groupNameLbl.text = groupChatPreviewArr[indexPath.row].groupName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessageId = self.groupChatPreviewArr[indexPath.row].messageId
        groupName = self.groupChatPreviewArr[indexPath.row].groupName
        groupId = self.groupChatPreviewArr[indexPath.row].groupId
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
}
