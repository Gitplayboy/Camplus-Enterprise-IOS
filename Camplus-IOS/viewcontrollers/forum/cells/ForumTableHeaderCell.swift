//
//  ForumTableHeaderCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 08/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class ForumTableHeaderCell: UITableViewCell {

    @IBOutlet weak var viewHeaderContainer: UIView!
    @IBOutlet weak var ivUsrPhoto: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var viewCategoryContainer: UIView!
    @IBOutlet weak var labelQuestionTitle: UILabel!
    @IBOutlet weak var labelQuestionDescription: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var btnResponse: UIButton!
    
    @IBOutlet weak var btnSocialMedia: UIButton!
    @IBOutlet weak var btnTechnology: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    var actionDelegate: ForumActionDelegate!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func initForumUI(_ row: Int, actionDelegate: ForumActionDelegate) {
        ivUsrPhoto.layer.cornerRadius = 24
        btnSocialMedia.layer.cornerRadius = 8
        btnTechnology.layer.cornerRadius = 8
        btnMore.layer.cornerRadius = 8
        viewHeaderContainer.layer.cornerRadius = 4
        viewHeaderContainer.layer.shadowOpacity = 0.1
        btnResponse.tag = row
        btnReport.tag = row
        self.actionDelegate = actionDelegate
    }
    
    func setForum(form: Forum) {
        labelUserName.text = form.user_name
        labelQuestionTitle.text = form.title
        labelQuestionDescription.text = form.description
        
        if form.categories.count == 1 {
            btnSocialMedia.setTitle(form.categories[0], for: .normal)
            btnTechnology.isHidden = true
            btnMore.isHidden = true
        } else if form.categories.count >= 2 {
            btnSocialMedia.setTitle(form.categories[0], for: .normal)
            btnTechnology.setTitle(form.categories[1], for: .normal)
            if form.categories.count > 2 {
                btnMore.isHidden = false
            } else {
                btnMore.isHidden = true
            }
        } else {
            btnSocialMedia.isHidden = true
            btnTechnology.isHidden = true
        }
    }
    
    @IBAction func onResponseClicked(_ sender: Any) {
        let responseBtn = sender as! UIButton
        print("onResponseClicked -> \(responseBtn.tag)")
    }
    
    @IBAction func onReportClicked(_ sender: Any) {
        let reportBtn = sender as! UIButton
        print("onReportClicked \(reportBtn.tag)")
        if let delegate = actionDelegate {
            delegate.report(index: reportBtn.tag)
        }
    }

}
