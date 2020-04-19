//
//  ChatVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var noChatFound: UIView!
    @IBOutlet weak var classGroupContainerView: UIView!
    @IBOutlet weak var noResultFound: UIView!
    @IBOutlet weak var searchChatsTxt: UITextField!
    @IBOutlet weak var addChatBtn: UIButton!
    @IBOutlet weak var classGroupsLbl: UILabel!
    @IBOutlet weak var directMsgLbl: UILabel!
    let chatSvc = ChatsSvcImpl()
    var chatPreviewArr = [ChatPreviewMsgs]()
    var filteredChats = [ChatPreviewMsgs]()
    @IBOutlet weak var chatPreviewTable: UITableView!
    var receiverName:String?
    var messageId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatPreviewTable.tableFooterView = UIView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //setupNavigationBar()
        addChatBtn.layer.cornerRadius = addChatBtn.frame.size.width/2
        addChatBtn.layer.masksToBounds = true
        
        let classGroupsGesture = UITapGestureRecognizer(target: self, action: #selector(onClassGroupsClick))
        classGroupsLbl.addGestureRecognizer(classGroupsGesture)
        
        let directMsgGesture = UITapGestureRecognizer(target: self, action: #selector(onDirectMsgClick))
        directMsgLbl.addGestureRecognizer(directMsgGesture)
        
        //Service call
        chatSvc.fetchDirectMessageChats(userId: (appDelegate.userDetails.userId)!, success: {(chatPreviewMsgs) in
            self.chatPreviewArr = chatPreviewMsgs
            self.filteredChats = chatPreviewMsgs
            self.chatPreviewTable.reloadData()
        }, failure: {(error) in
            print(error)
        })
        
        searchChatsTxt.setLeftPaddingPoints(30)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredChats.count == 0 {
            noChatFound.isHidden = true
        } else {
            noChatFound.isHidden = true
        }
        return filteredChats.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatsDataCell
        cell.chatDpName.text = filteredChats[indexPath.row].senderDpName
        cell.chatName.text = filteredChats[indexPath.row].senderName
        cell.chatMsgPreview.text = filteredChats[indexPath.row].lastMsg
        cell.lastChatTime.text = filteredChats[indexPath.row].lastMsgTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        receiverName = filteredChats[indexPath.row].senderName
        messageId = filteredChats[indexPath.row].messageId
        performSegue(withIdentifier: "directChatMsgs", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "directChatMsgs" {
            let destination = segue.destination as! ChatMessageVC
            destination.receiverName = receiverName
            destination.messageId = messageId
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationItem.hidesBackButton = true
        self.tabBarController!.navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
    @objc func onClassGroupsClick() {
        classGroupContainerView.isHidden = false
        directMsgLbl.textColor = UIColor.white
        classGroupsLbl.textColor = UIColor.systemOrange
    }
    
    @objc func onDirectMsgClick() {
        classGroupContainerView.isHidden = true
        directMsgLbl.textColor = UIColor.systemOrange
        classGroupsLbl.textColor = UIColor.white
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var isFound = false
        if searchChatsTxt.text != nil && !searchChatsTxt.text!.isEmpty {
            filteredChats = []
            for chats in chatPreviewArr {
                if chats.senderName!.lowercased().contains(searchChatsTxt!.text!.lowercased()) {
                    filteredChats.append(chats)
                    isFound = true
                }
            }
            if isFound {
                noResultFound.isHidden = true
                chatPreviewTable.reloadData()
            } else {
                chatPreviewTable.reloadData()
                noResultFound.isHidden = false
            }
            
        } else {
            noResultFound.isHidden = true
            filteredChats = chatPreviewArr
            chatPreviewTable.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
}
