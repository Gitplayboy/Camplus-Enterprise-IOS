//
//  ForumCategoryCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 13/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class ForumCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var labelCategoryName: UILabel!
    
    func setCategory(category: Category) {
        labelCategoryName.text = category.title
        self.contentView.layer.cornerRadius = 8
        labelCategoryName.textColor = UIColor.black 
        self.contentView.backgroundColor = UIColor(hexa: "#00000017");
    }
    
    func itemSelected(_ category: Category) {
        if !category.selectStatus {
            labelCategoryName.textColor = UIColor.white
            self.contentView.backgroundColor = UIColor(hexa: "#FFAA20");
            category.selectStatus = true
        } else {
            labelCategoryName.textColor = UIColor.black
            self.contentView.backgroundColor = UIColor(hexa: "#00000017");
            category.selectStatus = false
        }
        
    }
}
