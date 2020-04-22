//
//  SettingsInfoVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-18.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class SettingsInfoVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            let alert = UIAlertController(title: "Logout", message: "Are you sure that you want to logout?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(success) in
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                let sceneDelegate = self.view.window!.windowScene!.delegate as! SceneDelegate
                let navigationController = UINavigationController(rootViewController: loginVC!)
                sceneDelegate.window?.rootViewController = navigationController
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }  else if indexPath.row == 4 {
            let contactVC = self.storyboard!.instantiateViewController(withIdentifier: "ContactVC") as! ContactUsVC
            self.navigationController?.pushViewController(contactVC, animated: true)
        }
    }
}
