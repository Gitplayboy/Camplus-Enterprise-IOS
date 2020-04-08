//
//  FeedsVC.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

private let reuseIdentifier = "feedCell"

class FeedsVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
var feedsData = [FeedsData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Mock data
        feedsData.append(FeedsData(postTxt: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. ",postImgName: nil))
        feedsData.append(FeedsData(postTxt: "I am great khali",postImgName: "justin_trudeau"))
        feedsData.append(FeedsData(postTxt: nil ,postImgName: "justin_trudeau"))
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedsData.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedsCell
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
        textview.font = UIFont(name:"Montserrat-Regular",size:14)
        
        
        actualsize = textview.sizeThatFits(CGSize(width: collectionView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        //BOTH IMAGE AND TEXT ARE AVAILABLE
        if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postTxt != nil{
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 230)
        } else if feedsData[indexPath.row].postImgName == nil && feedsData[indexPath.row].postTxt != nil {
            // Only text available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 80)
        } else if feedsData[indexPath.row].postImgName != nil && feedsData[indexPath.row].postTxt == nil {
            // Only image is available
            return CGSize(width: collectionView.frame.size.width - 30, height: actualsize.height + 200)
        } else {
            // Both nil
            return CGSize(width: collectionView.frame.size.width, height: actualsize.height)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
