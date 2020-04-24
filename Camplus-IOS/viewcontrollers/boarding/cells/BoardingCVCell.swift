//
//  BoardingCVCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 23/04/20.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class BoardingCVCell: UICollectionViewCell {
    
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    func setBoard(board: Board) {
        labelHeading.text = board.heading!
        labelDescription.text = board.description!
        ivImage.image = UIImage(named: board.image!)
        self.contentView.backgroundColor = UIColor(hexa: board.color)
    }
}
