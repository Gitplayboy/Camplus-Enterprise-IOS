//
//  ForumDetailCategoryCVCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 16/04/20.
//  Copyright © 2020 yadhukrishnan E. All rights reserved.
//

import UIKit

class ForumDetailCategoryCVCell: UICollectionViewCell {
    
    @IBOutlet weak var labelCatName: UILabel!
    
    func setCategory(category: String!) {
        self.contentView.backgroundColor = UIColor(hexa: "#00000017");
        self.contentView.layer.cornerRadius = 8
        
    }
    
    
}
