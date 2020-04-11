//
//  FeedsVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

class FeedsVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var feedsData = [FeedsData]()
    @IBOutlet weak var addPost:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Mock data
        feedsData.append(FeedsData(postTxt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",postImgName: nil))
        feedsData.append(FeedsData(postTxt: "I am great khali",postImgName: "justin_trudeau"))
        feedsData.append(FeedsData(postTxt: nil ,postImgName: "justin_trudeau"))
        
        addPost.layer.cornerRadius = addPost.frame.size.width/2
        addPost.layer.masksToBounds = true
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedsData.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedsDataCell
        cell.postTxtView?.text = feedsData[indexPath.row].postTxt
        if feedsData[indexPath.row].postImgName != nil {
            cell.postImgView?.image = UIImage(named: feedsData[indexPath.row].postImgName!)
        }
        cell.profilePic?.layer.cornerRadius = (cell.profilePic?.layer.bounds.width)! / 2
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var actualsize = CGSize()
        let textview = UITextView()

        textview.text = feedsData[indexPath.row].postTxt
        textview.font = UIFont(name:"Proxima Nova Reg",size:14)
        
        
        actualsize = textview.sizeThatFits(CGSize(width: collectionView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        //BOTH IMAGE AND TEXT ARE AVAILABLE
        if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postTxt != nil{
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 230)
        } else if feedsData[indexPath.row].postImgName == nil && feedsData[indexPath.row].postTxt != nil {
            // Only text available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 90)
        } else if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postTxt == nil {
            // Only image is available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 200)
        } else {
            // Both nil
            return CGSize(width: collectionView.frame.size.width, height: actualsize.height)
        }
    }

}
