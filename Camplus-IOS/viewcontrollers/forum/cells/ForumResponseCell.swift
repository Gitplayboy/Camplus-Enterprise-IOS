//
//  ForumResponseCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 11/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class ForumResponseCell: UITableViewCell {

    @IBOutlet weak var labelUserName: UILabel!
    
    @IBOutlet weak var labelUserResponse: UILabel!
    @IBOutlet weak var labelSentTime: UILabel!
    @IBOutlet weak var ivUserPhoto: UIImageView!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setResponse(response: Response) {
        labelUserName.text = response.user_name
        labelUserResponse.text = response.comment
        labelSentTime.text = Date.toNewFormat(format: "hh:mm a MM/dd/yyyy", milliSecond: response.timestamp)
    }

}
