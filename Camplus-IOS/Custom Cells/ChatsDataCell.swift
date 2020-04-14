//
//  FeedsCell.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-07.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class ChatsDataCell: UITableViewCell {
    
    @IBOutlet weak var chatDpName: UILabel!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var chatMsgPreview: UILabel!
    @IBOutlet weak var chatPreviewBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatPreviewBorder.layer.cornerRadius = chatPreviewBorder.frame.size.width/2
        chatPreviewBorder.layer.masksToBounds = true
    }
    
}
