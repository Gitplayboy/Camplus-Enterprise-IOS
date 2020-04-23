//
//  FirebaseDelegate.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 16/04/20.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import Foundation

protocol FirebaseDelegate {
    func writingFailed(serviceID: Int)
    func wrote(serviceID: Int, docId: String)
    func readingFailed(serviceID: Int)
    func read(serviceID: Int, data: NSObject)
}
