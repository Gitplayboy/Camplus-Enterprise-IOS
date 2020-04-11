//
//  AddPostVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController {

    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var imgDescription: UILabel!
    @IBOutlet weak var uploadedImg: UIImageView!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var uploadImgView: UIView!
    @IBOutlet weak var deleteImgBtn: UIButton!
    @IBOutlet weak var publishPostBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imgUploadBorder = CAShapeLayer()
        imgUploadBorder.strokeColor = UIColor.black.cgColor
        imgUploadBorder.lineDashPattern = [5, 5]
        imgUploadBorder.frame = uploadImgView.bounds
        imgUploadBorder.fillColor = nil
        imgUploadBorder.path = UIBezierPath(rect: uploadImgView.bounds).cgPath
        uploadImgView.layer.addSublayer(imgUploadBorder)
        
        deleteImgBtn.isHidden = true
        postDescription.layer.cornerRadius = 8
        postDescription.layer.borderWidth = 1.0
        let myColor : UIColor = UIColor.gray
        postDescription.layer.borderColor = myColor.cgColor
        postDescription.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onImageUpload))
        uploadImgView.addGestureRecognizer(gesture)
        self.view.isUserInteractionEnabled = true
        uploadImgView.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.topItem?.title = " "
        
        publishPostBtn.layer.cornerRadius = 8
    }
    @objc func onImageUpload(){
        deleteImgBtn.isHidden = false
        imgTitle.isHidden = true
        imgDescription.isHidden = true
        uploadedImg.image = UIImage(named: "justin_trudeau")
    }
    @IBAction func onImageDeletion(_ sender: UIButton) {
        deleteImgBtn.isHidden = true
        uploadedImg.image = nil
        imgTitle.isHidden = false
        imgDescription.isHidden = false
    }
}
