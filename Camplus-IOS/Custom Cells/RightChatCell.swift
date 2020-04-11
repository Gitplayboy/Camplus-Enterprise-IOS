//
//  RightChatCell.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-09.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class RightChatCell: UITableViewCell {

    @IBOutlet weak var chatTxtLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTxtLbl.layer.cornerRadius = 8
        chatTxtLbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
