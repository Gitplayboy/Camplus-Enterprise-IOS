//
//  LoginVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-06.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import Lottie

class LoginVC: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
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
}
