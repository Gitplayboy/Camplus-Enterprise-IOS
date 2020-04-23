//
//  ForumDetailHeaderCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 11/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class ForumDetailHeaderCell: UITableViewCell {

    var categories: [String]!
    
    @IBOutlet weak var ivUserPhoto: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelQueryTitle: UILabel!
    @IBOutlet weak var labelQueryDescription: UILabel!
    @IBOutlet weak var labelQueryTime: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var cvCategory: UICollectionView!

    func setForum(forum: Forum) {
        labelUserName.text = forum.user_name
        labelQueryTitle.text = forum.title
        labelQueryDescription.text = forum.description
        labelQueryTime.text = Date.toNewFormat(format: "hh:mm a MM/dd/yyyy", milliSecond: forum.timestamp)
        categories = forum.categories
        
        cvCategory.register(ForumDetailCategoryCVCell.self, forCellWithReuseIdentifier: "cell_forum_detail_category")
        cvCategory.delegate  = self
        cvCategory.dataSource = self
        
        cvCategory.reloadData()
    }
 
}


extension ForumDetailHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categories = self.categories {
            return categories.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_forum_detail_category", for: indexPath) as! ForumDetailCategoryCVCell
        cell.setCategory(category: categories[indexPath.row])
        
        return cell
    }
}
