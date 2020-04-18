//
//  ChangePwdVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-17.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChangePwdVC: UIViewController {
    
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
    }
}
