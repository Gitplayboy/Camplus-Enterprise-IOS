//
//  ProfileInfoVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-16.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ProfileInfoVC: UITableViewController {
    
    @IBOutlet weak var firstnameLbl: UILabel!
    @IBOutlet weak var lastnameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        firstnameLbl.text = appDelegate.userDetails.firstName
        lastnameLbl.text = appDelegate.userDetails.lastName
        emailLbl.text = appDelegate.userDetails.emailId
        phoneLbl.text = appDelegate.userDetails.phone
        genderLbl.text = appDelegate.userDetails.gender
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
