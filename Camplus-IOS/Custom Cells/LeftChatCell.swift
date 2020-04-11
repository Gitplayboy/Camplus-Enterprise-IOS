//
//  LeftChatCell.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-09.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class LeftChatCell: UITableViewCell {
    @IBOutlet weak var senderProfileImgView: UIView!
    @IBOutlet weak var chatTxtLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        senderProfileImgView.layer.cornerRadius = senderProfileImgView.frame.size.width/2
        senderProfileImgView.layer.masksToBounds = true
        chatTxtLbl.layer.cornerRadius = 8
        chatTxtLbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
