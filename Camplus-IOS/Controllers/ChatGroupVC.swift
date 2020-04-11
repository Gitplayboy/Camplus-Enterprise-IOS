//
//  ChatGroupVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-11.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGroupCell")
        return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupChat" {
            if let destination = segue.destination as? ChatMessageVC {
                destination.isGroupChat = true
            }
        }
    }
}
