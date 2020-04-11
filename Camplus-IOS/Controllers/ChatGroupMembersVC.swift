//
//  ChatGroupMembersVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-11.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatGroupMembersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupMembersCell")
        return cell!
    }
    

}
