//
//  LoginService.swift
//  Camplus-IOS
//
//  Created by vibin joby on 2020-04-12.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import FirebaseFirestore

protocol LoginSvc {
    func verifyUserLogin(userId: String, password:String,success:@escaping (_ successMsg:  String)->(),failure:@escaping (_ error:String)->())
}

class LoginServiceImpl: LoginSvc {
    let db = Firestore.firestore()
    func verifyUserLogin(userId: String, password:String,success:@escaping (_ successMsg:  String)->(),failure:@escaping (_ error:String)->()) {
        var isFound = false
        db.collection("tbl_user").whereField("user_id", isEqualTo: userId).getDocuments(completion: {(
            snapshot,err) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    if ((data["user_password"] as? String)?.elementsEqual(password))! {
                        isFound = true
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.userDetails.userId = userId
                        appDelegate.userDetails.userName = (data["username"] as! String)
                        appDelegate.userDetails.userType = (data["user_type"] as! String)
                        success("Success")
                    } else {
                        isFound = true
                        failure("Incorrect UserId")
                    }
                }
                if !isFound {
                    failure("Incorrect UserId")
                }
            } else {
                failure("Incorrect UserId")
            }
        })
    }
}
