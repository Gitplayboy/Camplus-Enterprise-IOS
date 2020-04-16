//
//  LoginVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-06.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import Lottie

class LoginVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var rememberUsername: UISwitch!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    let loginSvc = LoginServiceImpl()
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.layer.cornerRadius = 8
        userName.layer.borderWidth = 0.7
        userName.layer.masksToBounds = true
        
        password.layer.cornerRadius = 8
        password.layer.borderWidth = 0.7
        password.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !userName.text!.isEmpty && !password.text!.isEmpty {
            signInBtn.isEnabled = true
            signInBtn.alpha = 1.0
        } else {
            signInBtn.isEnabled = false
            signInBtn.alpha = 0.5
        }
    }
    
    @IBAction func onLogin() {
        loginSvc.verifyUserLogin(userId: userName.text!,password: password.text!,success: {(success) in
            //save username and password to userdefaults
            if self.rememberUsername.isOn {
                let defaults = UserDefaults.standard
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                defaults.set(appDelegate.userDetails.userName, forKey: "username")
                defaults.set(appDelegate.userDetails.userId, forKey: "userId")
                defaults.set(appDelegate.userDetails.userType, forKey: "userType")
            }
            self.performSegue(withIdentifier: "loginSB", sender: self)
            
        },failure: {(error) in
            let alert = UIAlertController(title: "Invalid Login", message: "Login Failed Please check the credentials", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
}
