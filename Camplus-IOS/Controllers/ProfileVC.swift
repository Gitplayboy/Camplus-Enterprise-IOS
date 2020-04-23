//
//  ProfileVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-16.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var profileIc: UIView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var changePwdBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        usernameLbl.text = appDelegate.userDetails.userName
        profileNameLbl.text = appDelegate.userDetails.userName?.prefix(2).uppercased()
        profileIc.layer.cornerRadius = profileIc.frame.size.width/2
        profileIc.layer.masksToBounds = true
        
        changePwdBtn.layer.cornerRadius = 10
        changePwdBtn.layer.shadowColor = UIColor.black.cgColor
        changePwdBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        changePwdBtn.layer.shadowRadius = 10
        changePwdBtn.layer.shadowOpacity = 0.3
        
        setupNavigationBar()
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "more-menu"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(self.navigateSettingsPage), for: UIControl.Event.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let settings = UIBarButtonItem(customView: button)
        self.tabBarController!.navigationItem.rightBarButtonItems = [settings]
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
    
    @objc func navigateSettingsPage() {
        //self.tabBarController?.navigationController?.pushViewController(SettingsVC(), animated: false)
        performSegue(withIdentifier: "settingsSB", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.navigationItem.rightBarButtonItem?.customView?.isHidden = false
        self.tabBarController!.navigationController?.navigationBar.topItem?.title = ""
    }

}
