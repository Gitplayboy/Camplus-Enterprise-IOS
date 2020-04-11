//
//  ChatVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var classGroupContainerView: UIView!
    @IBOutlet weak var addChatBtn: UIButton!
    @IBOutlet weak var classGroupsLbl: UILabel!
    @IBOutlet weak var directMsgLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addChatBtn.layer.cornerRadius = addChatBtn.frame.size.width/2
        addChatBtn.layer.masksToBounds = true
        
        let classGroupsGesture = UITapGestureRecognizer(target: self, action: #selector(onClassGroupsClick))
        classGroupsLbl.addGestureRecognizer(classGroupsGesture)
        
        let directMsgGesture = UITapGestureRecognizer(target: self, action: #selector(onDirectMsgClick))
        directMsgLbl.addGestureRecognizer(directMsgGesture)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatsDataCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationItem.hidesBackButton = true
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
    
}
