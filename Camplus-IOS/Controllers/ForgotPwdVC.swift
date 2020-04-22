//
//  ForgotPwdVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-19.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ForgotPwdVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
    }

    @IBAction func onSubmitClick(_ sender: UIButton) {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if usernameTxt.text!.rangeOfCharacter(from: characterset.inverted) != nil {
            let alert = UIAlertController(title: "Forgot Password", message: "Special characters are not allowed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Forgot Password", message: "Password has been sent to your registered Email Id", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(success) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty {
            submitBtn.alpha = 1.0
            submitBtn.isEnabled = true
        } else {
            submitBtn.alpha = 0.5
            submitBtn.isEnabled = false
        }
        return true
    }
}
