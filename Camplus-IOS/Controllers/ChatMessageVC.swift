//
//  ChatMessageVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-09.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatMessageVC: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textFieldBtmConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendTxtField: UITextField!
    var initialTxtFieldPos:CGFloat?
    var chatMessages = [ChatMessages]()
    var isGroupChat = false
    override func viewDidLoad() {
        super.viewDidLoad()
        sendTxtField.delegate = self
        initialTxtFieldPos = textFieldBtmConstraint.constant
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
        if isGroupChat {
            navigationItem.rightBarButtonItem?.customView?.isHidden = false
        } else {
            navigationItem.rightBarButtonItem?.customView?.isHidden = true
        }
        
        // Mock data
        chatMessages.append(ChatMessages.SenderChatMsgs(chatMessage: "Please check the instructions on Moodle on how to log in to Adobe Connect.",chatDate: nil))
        chatMessages.append(ChatMessages.SenderChatMsgs(chatMessage: "The link for today’s class is on Moodle.",chatDate: nil))
        chatMessages.append(ChatMessages.RecieverChatMsgs(chatMessage: "Hey am not working today",chatDate: nil))
        chatMessages.append(ChatMessages.RecieverChatMsgs(chatMessage: "Hey am not working today",chatDate: nil))
        chatMessages.append(ChatMessages.SenderChatMsgs(chatMessage: "Hey am not working today",chatDate: nil))
        chatMessages.append(ChatMessages.RecieverChatMsgs(chatMessage: "Hey am not working today",chatDate: nil))
        chatMessages.append(ChatMessages.RecieverChatMsgs(chatMessage: "Hey am not working today",chatDate: nil))
        chatMessages.append(ChatMessages.SenderChatMsgs(chatMessage: "Hey am not working today",chatDate: nil))
        chatMessages.append(ChatMessages.SenderChatMsgs(chatMessage: "Hey am not working today",chatDate: nil))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
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
            (cell as! LeftChatCell).chatTxtLbl.font = UIFont(name: "ProximaNova-Regular", size: 14)
        } else if let receiever = chatMessages[indexPath.row] as? ChatMessages.RecieverChatMsgs {
            cell = tableView.dequeueReusableCell(withIdentifier: "RightChat") as! RightChatCell
            (cell as! RightChatCell).chatTxtLbl.text! = receiever.chatMessage!
            (cell as! RightChatCell).chatTxtLbl.font = UIFont(name: "ProximaNova-Regular", size: 14)
            (cell as! RightChatCell).chatTxtLbl.textColor = UIColor.white
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
        let height = heightForView(text: message!, font: UIFont(name: "ProximaNova-Regular", size: 14)!)
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
}
