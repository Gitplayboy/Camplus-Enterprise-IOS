//
//  ChatMessageVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-09.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatMessageVC: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var chatHeaderLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textFieldBtmConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendTxtField: UITextField!
    var initialTxtFieldPos:CGFloat?
    var chatMessages = [ChatMessages]()
    var isGroupChat = false
    let chatSvc = ChatsSvcImpl()
    var messageId:String?
    var groupName:String?
    var groupId:String?
    var receiverName:String?
    var receiverId:String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        sendTxtField.delegate = self
        initialTxtFieldPos = textFieldBtmConstraint.constant
        setupNavigationbar()
        if isGroupChat {
            navigationItem.rightBarButtonItem?.customView?.isHidden = false
            if messageId != nil {
                //Service call to fetch group chat info
                chatSvc.fetchGroupChatMessages(userId: (appDelegate.userDetails.userId)!, messageId: messageId!, success: {(chatMsgs) in
                    self.chatMessages = chatMsgs
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                    if self.groupName != nil {
                        self.chatHeaderLbl.text = self.groupName!
                    }
                }, failure: {(error) in
                    print(error)
                })
            }
        } else {
            navigationItem.rightBarButtonItem?.customView?.isHidden = true
            
            if messageId != nil {
                // service call to fetch data
                chatSvc.fetchActiveChatMessages(messageId: messageId!, userId: (appDelegate.userDetails.userId)!, success: {(chatMsgsArr) in
                    self.chatMessages = chatMsgsArr
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                    if self.receiverName != nil {
                        self.chatHeaderLbl.text = self.receiverName!
                    }
                    
                }, failure: {(error) in
                    print(error)
                })
            } else {
                //check if there are any old chats associated with the receiver and fetch the message id
                
                if self.receiverName != nil {
                    self.chatHeaderLbl.text = self.receiverName!
                }
            }
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.textFieldBtmConstraint.constant < 300 {
                self.textFieldBtmConstraint.constant += 316
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.textFieldBtmConstraint.constant = initialTxtFieldPos!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if let sender = chatMessages[indexPath.row] as? ChatMessages.SenderChatMsgs {
            cell = tableView.dequeueReusableCell(withIdentifier: "LeftChat") as! LeftChatCell
            (cell as! LeftChatCell).chatTxtLbl.text! = sender.chatMessage!
            (cell as! LeftChatCell).chatTxtLbl.font = UIFont(name: "ProximaNova-Regular", size: 16)
            (cell as! LeftChatCell).senderName.text! = sender.senderName!
            (cell as! LeftChatCell).previewName.text! = String(sender.senderName!.prefix(2)).uppercased()
            (cell as! LeftChatCell).chatDate.text! = String(sender.chatDate!)
        } else if let receiever = chatMessages[indexPath.row] as? ChatMessages.RecieverChatMsgs {
            cell = tableView.dequeueReusableCell(withIdentifier: "RightChat") as! RightChatCell
            (cell as! RightChatCell).chatTxtLbl.text! = receiever.chatMessage!
            (cell as! RightChatCell).chatTxtLbl.font = UIFont(name: "ProximaNova-Regular", size: 16)
            (cell as! RightChatCell).chatTxtLbl.textColor = UIColor.white
            (cell as! RightChatCell).chatDate.text! = String(receiever.chatDate!)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var message:String?
        if let sender = chatMessages[indexPath.row] as? ChatMessages.SenderChatMsgs {
            message = sender.chatMessage
        } else if let receiever = chatMessages[indexPath.row] as? ChatMessages.RecieverChatMsgs {
            message = receiever.chatMessage
        }
        let height = heightForView(text: message!, font: UIFont(name: "ProximaNova-Regular", size: 16)!)
        return height + 80
    }
    
    func heightForView(text:String, font:UIFont) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 183, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @objc func checkGroupMembers() {
        performSegue(withIdentifier: "showGroupMembers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupMembers" {
            let destination = segue.destination as! ChatGroupMembersVC
            destination.groupId = groupId!
            destination.groupName = groupName!
        }
    }
    
    @IBAction func sendMessage() {
        if sendTxtField.text != nil && !sendTxtField.text!.isEmpty {
            // When already a chat exists with a message id
            if messageId != nil {
                chatSvc.sendDirectMessage(messageId: messageId!, userId: (appDelegate.userDetails.userId)!, messageText: sendTxtField.text!, senderName: appDelegate.userDetails.userName!)
            } else {
                // When user navigates from group members --> membername --> new chat
                if receiverId != nil {
                    chatSvc.sendNewDirectMessage(receiverId: receiverId!, receiverName: receiverName!, messageText: sendTxtField.text!,success: {(chatMsgs,messageId) in
                        self.chatMessages = chatMsgs
                        self.messageId = messageId
                        self.chatTableView.reloadData()
                        self.scrollToBottom()
                    }, failure: {(error) in
                        print(error)
                    })
                }
            }
            
            sendTxtField.resignFirstResponder()
            sendTxtField.text! = ""
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.chatMessages.count > 0 {
                let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func setupNavigationbar() {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "people"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(self.checkGroupMembers), for: UIControl.Event.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let add = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItems = [add]
        self.navigationController?.navigationBar.topItem?.title = " "
        let backBTN = UIBarButtonItem(image: UIImage(named: "back"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        backBTN.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = backBTN
    }
}
