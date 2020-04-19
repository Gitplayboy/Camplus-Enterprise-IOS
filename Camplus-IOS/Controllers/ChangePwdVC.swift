//
//  ChangePwdVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-17.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChangePwdVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var currentPwdTxt: UITextField!
    @IBOutlet weak var newPwdTxt: UITextField!
    @IBOutlet weak var retypePwdTxt: UITextField!
    @IBOutlet weak var changePwdBtn: UIButton!
    
    let loginSvc = LoginServiceImpl()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
    }
    func setupNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = " "
        let backBTN = UIBarButtonItem(image: UIImage(named: "back"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        backBTN.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = backBTN
        
        let currentPwdLine = CALayer()
        currentPwdLine.frame = CGRect(x: 0.0, y: currentPwdTxt.frame.height - 1, width: currentPwdTxt.frame.width - 40, height: 1.5)
        currentPwdLine.backgroundColor = UIColor.lightGray.cgColor
        currentPwdTxt.borderStyle = UITextField.BorderStyle.none
        currentPwdTxt.layer.addSublayer(currentPwdLine)
        
        let newPwdLine = CALayer()
        newPwdLine.frame = CGRect(x: 0.0, y: newPwdTxt.frame.height - 1, width: retypePwdTxt.frame.width - 40, height: 1.5)
        newPwdLine.backgroundColor = UIColor.lightGray.cgColor
        newPwdTxt.borderStyle = UITextField.BorderStyle.none
        newPwdTxt.layer.addSublayer(newPwdLine)
        
        let retypePwdLine = CALayer()
        retypePwdLine.frame = CGRect(x: 0.0, y: retypePwdTxt.frame.height - 1, width: retypePwdTxt.frame.width - 40, height: 1.5)
        retypePwdLine.backgroundColor = UIColor.lightGray.cgColor
        retypePwdTxt.borderStyle = UITextField.BorderStyle.none
        retypePwdTxt.layer.addSublayer(retypePwdLine)
        
        pwdView.layer.cornerRadius = 10
        pwdView.layer.shadowColor = UIColor.black.cgColor
        pwdView.layer.shadowOffset = CGSize(width: 5, height: 5)
        pwdView.layer.shadowRadius = 10
        pwdView.layer.shadowOpacity = 0.3
        
        // add on edit change targets
        currentPwdTxt.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        newPwdTxt.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        retypePwdTxt.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    @IBAction func onSubmitClick(_ sender: UIButton) {
        //check if current password is correct
        if currentPwdTxt.text!.elementsEqual(appDelegate.userDetails.userPwd!) {
            //check if both new passwords match
            if newPwdTxt.text!.elementsEqual(retypePwdTxt.text!) {
                // check if new password is same as old password
                if newPwdTxt.text!.elementsEqual(currentPwdTxt.text!) {
                    let alert = UIAlertController(title: "Incorrect Password", message: "New password cannot be the same as old password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //If all condition satisfies update the password via login service
                    loginSvc.changePassword(userId: appDelegate.userDetails.userId!, oldPwd: currentPwdTxt.text!, newPwd: newPwdTxt.text!, success: {(success) in
                        print("password changed successfully")
                        let alert = UIAlertController(title: "Password Changed", message: "Password changed successfully", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(after) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }, failure: {(failure) in
                        print(failure)
                    })
                }
                
            } else {
                let alert = UIAlertController(title: "Incorrect Password", message: "New password do not match with the retyped password", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Incorrect Password", message: "Current password is incorrectly entered", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func editingChanged() {
        if currentPwdTxt.text!.isEmpty || newPwdTxt.text!.isEmpty || retypePwdTxt.text!.isEmpty {
            changePwdBtn.isEnabled = false
            changePwdBtn.alpha = 0.5
        } else {
            changePwdBtn.isEnabled = true
            changePwdBtn.alpha = 1.0
        }
    }
}
