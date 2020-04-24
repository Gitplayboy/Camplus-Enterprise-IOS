//
//  ChatGroupMembersVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-11.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatGroupMembersVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var noResultFoundVC: UIView!
    @IBOutlet weak var searchMembers: UITextField!
    @IBOutlet weak var batchMembersCount: UILabel!
    var groupName:String?
    var groupId:String?
    let chatSvc = ChatsSvcImpl()
    var userDetailsArr = [UserDetails]()
    var filteredUserDetails = [UserDetails]()
    var targetUserMsgId:String?
    var targetUserId:String?
    var targetUserName:String?
    @IBOutlet weak var groupMembersTable: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        self.groupMembersTable.tableFooterView = UIView()
        searchMembers.setLeftPaddingPoints(30)
        if groupId != nil {
            chatSvc.fetchGroupMembers(groupId: groupId!, success: {(userDetailsArr) in
                self.userDetailsArr = userDetailsArr
                self.filteredUserDetails = userDetailsArr
                self.groupMembersTable.reloadData()
                self.batchMembersCount.text = "Batch Members (\(userDetailsArr.count))"
            }, failure: {(error) in
                print(error)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if InternetConnectionManager.isConnectedToNetwork() {
            print("connected")
        } else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            navigationController?.pushViewController(noInternetVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUserDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMembersCell") as! GroupMembersCell
        cell.groupMemberName.text = filteredUserDetails[indexPath.row].userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userDetailsArr[indexPath.row].userId != appDelegate.userDetails.userId {
            targetUserName = filteredUserDetails[indexPath.row].userName
            targetUserId = filteredUserDetails[indexPath.row].userId
            chatSvc.fetchMessageId(targetUserId: filteredUserDetails[indexPath.row].userId!, success: {(messageId) in
                self.targetUserMsgId = messageId
                self.performSegue(withIdentifier: "directChatSB", sender: self)
            }, failure: {(error) in
                print(error)
                self.targetUserMsgId = nil
                self.performSegue(withIdentifier: "directChatSB", sender: self)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directChatSB" {
            let destination = segue.destination as! ChatMessageVC
            destination.isGroupChat = false
            destination.messageId = targetUserMsgId
            destination.receiverName = targetUserName!
            destination.receiverId = targetUserId!
        }
        targetUserMsgId = ""
    }
    
    func setupNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var isFound = false
        if searchMembers.text != nil && !searchMembers.text!.isEmpty {
            filteredUserDetails = []
            for users in userDetailsArr {
                if users.userName!.lowercased().contains(searchMembers!.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) {
                    filteredUserDetails.append(users)
                    isFound = true
                }
            }
            if isFound {
                noResultFoundVC.isHidden = true
                groupMembersTable.reloadData()
            } else {
                groupMembersTable.reloadData()
                noResultFoundVC.isHidden = false
            }
            
        } else {
            noResultFoundVC.isHidden = true
            filteredUserDetails = userDetailsArr
            groupMembersTable.reloadData()
        }
    }
    
}
