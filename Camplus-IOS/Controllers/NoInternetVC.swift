//
//  NoInternetVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-15.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class NoInternetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    @IBAction func onTryAgain(_ sender: UIButton) {
        if InternetConnectionManager.isConnectedToNetwork() {
            navigationController?.popViewController(animated: true)
        } else {
            print("Not Connected")
        }
        
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationItem.hidesBackButton = true
    }
}
