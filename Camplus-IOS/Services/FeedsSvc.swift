//
//  HomeFeedService.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

protocol FeedsSvc {
    func fetchActiveFeeds(success:@escaping (_ dataArr:[FeedsData])->(),failure:@escaping (_ error:Error)->())
    func saveNewPost(feedPostedBy:String, feedTitle:String, feedText:String, feedImageUrl: String?)
}

class FeedsSvcImpl:FeedsSvc {
    let db = Firestore.firestore()
    
    func fetchActiveFeeds(success:@escaping (_ dataArr:[FeedsData])->(),failure:@escaping (_ error:Error)->()) {
        db.collection("feeds").addSnapshotListener {(snapshot, err) in
            var feedsArr = [FeedsData]()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    var feedImgUrl:String?,feedDescription:String?
                    //let docId = document.documentID
                    //let feedDate = document.get("feed_date") as! Timestamp
                    if let feedDesc = document.get("feed_description") {
                        feedDescription = feedDesc as? String
                    }
                    if let imgUrl = document.get("feed_image_url") {
                        feedImgUrl = imgUrl as? String
                    }
                    let feedTitle = document.get("feed_title") as! String
                    let userName = document.get("feed_user_name") as! String
                    let postTime = ChatsSvcImpl().getDateTimestamp(fromTimeStamp: document.get("feed_post_time") as! TimeInterval)
                    
                    let feedsData = FeedsData(postDescription:feedDescription, postImgName:feedImgUrl,postByUser:userName,postTitle:feedTitle,postTime:postTime)
                    
                    feedsArr.append(feedsData)
                }
                success(feedsArr)
            }
        }
    }
    
    func saveNewPost(feedPostedBy: String, feedTitle: String, feedText: String, feedImageUrl: String?) {
        if let imgUrl = feedImageUrl {
            db.collection("feeds").document().setData(["feed_description":feedText,"feed_image_url":imgUrl,
                                                       "feed_title":feedTitle, "feed_user_name":feedPostedBy
                ,"feed_post_time":Date().timeIntervalSince1970])
        } else {
            db.collection("feeds").document().setData(["feed_description":feedText,
            "feed_title":feedTitle, "feed_user_name":feedPostedBy
            ,"feed_post_time":Date().timeIntervalSince1970])
        }
        
    }
    
    func downloadImages(filename:String,success:@escaping (_ image:UIImage)->(),failure:@escaping (_ error:Error)->()){
        // Create a reference with an initial file path and name
        let reference = Storage.storage().reference(withPath: "images/\(filename)")
        reference.getData(maxSize: (10 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let myImage:UIImage! = UIImage(data: _data)
                    success(myImage)
                }
            }
        }
    }
}
