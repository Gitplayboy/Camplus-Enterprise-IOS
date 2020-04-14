//
//  FeedsData.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-08.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

class FeedsData {
    var postDescription:String?
    var postImgName:String?
    var postByUser:String?
    var postTitle:String?
    
    init(postDescription:String?, postImgName:String?,postByUser:String?,postTitle:String?) {
        self.postDescription = postDescription
        self.postImgName = postImgName
        self.postByUser = postByUser
        self.postTitle = postTitle
    }
}
