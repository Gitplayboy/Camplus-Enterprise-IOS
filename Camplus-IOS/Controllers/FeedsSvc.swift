//
//  HomeFeedService.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

protocol FeedsSvc {
    func fetchActiveFeeds(isAdmin:Bool)
    func saveNewPost(feedPostedBy:String, feedTitle:String, feedText:String, feedImage: UIImage)
}

class FeedsSvcImpl {
    
}
