//
//  FirestoreService.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 16/04/20.
//  Copyright © 2020 yadhukrishnan E . All rights reserved.
//

import Firebase
import FirebaseDatabase

class FirestoreService {
    
    public static let SERVICE_ID_CREATE_FORUM = 1000
    public static let SERVICE_ID_GET_CATEGORIES = 1001
    public static let SERVICE_ID_GET_FORUMS = 1002
    public static let SERVICE_ID_SEND_RESPONSE = 1003
    public static let SERVICE_ID_GET_RESPONSES = 1004
    public static let SERVICE_ID_GET_SERVICES = 1005
    public static let SERVICE_ID_GET_TOKEN = 1006
    public static let SERVICE_ID_SEND_TOKEN = 1007
    public static let SERVICE_ID_GET_PARTICULAR_TOKEN = 1008
    public static let SERVICE_ID_GET_MY_TOKEN = 1009
    public static let SERVICE_ID_UPDATE_TOKEN = 1010
    public static let SERVICE_ID_UPDATE_REPORT = 1011
    public static let SERVICE_ID_LISTEN_TOKEN_UPDATE = 1012
    public static let SERVICE_ID_LISTEN_FORUM_UPDATE = 1013
    public static let SERVICE_ID_UPDATE_RESPONSE_COUNT = 1014
    public static let SERVICE_ID_SEND_REPORT = 1015
    public static let SERVICE_ID_GET_REPORTS = 1016
   
    func getForumCategories(serviceId: Int, _ delegate: FirebaseDelegate) {
        let db = Firestore.firestore()
        db.collection("categories").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("--------  FirebaseService -- getForumCategories \(err) -----------")
                delegate.readingFailed(serviceID: serviceId)
            } else {
                var categories: [Category] = []
                for document in querySnapshot!.documents {
                    let category = Category()
                    category.title = document.documentID
                    category.selectStatus = false
                    categories.append(category)
                }
                
                delegate.read(serviceID: serviceId, data: categories as NSObject)
            }
        }
    }
    
    func sendForumToDB(serviceId: Int, forum: Forum, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("forums").document()
        do {
            
           let _ =  try reference.setData(from: forum, encoder: .init(), completion: { err in
                if let err = err {
                    print("---------- FirestoreService --  sendForumToDB -- \(err) -----------")
                    firebaseDelegate.writingFailed(serviceID: serviceId)
                } else {
                    print("---------- FirestoreService -- sendForumToDB -- SUCCESSFULLY INSERTED -------------")
                    firebaseDelegate.wrote(serviceID: serviceId, docId: reference.documentID)
                }
            })
            
        } catch let err {
            print("---------- FirestoreService --  sendForumToDB -- catch -- \(err) -----------")
            firebaseDelegate.writingFailed(serviceID: serviceId)
        }
    }
    
    func getForumsFromDB(serviceId: Int, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("forums")
        reference.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("------------ FirestoreService -- getForumsFromDB -- FAILED -- \(err) -----------")
                firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                print("---------- FirestoreService -- getForumsFromDB -- SUCCESS -------------")
                var forums: [Forum] = []
                for document in querySnapshot!.documents {
                    do {
                        let forum = try document.data(as: Forum.self)
                        if var forum = forum {
                            forum.id = document.documentID
                            forums.append(forum)
                        }
                    } catch let err {
                        print("------------ FirestoreService -- getForumsFromDB -- FAILED -- \(err) -----------")
                        firebaseDelegate.readingFailed(serviceID: serviceId)
                        
                        return
                    }
                }
                firebaseDelegate.read(serviceID: serviceId, data: forums as NSObject)
            }
        }
    }
    
    func sendResponse(serviceId: Int, forumId: String, response: Response, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("responses").document(forumId).collection("comments").document()
        do {
            let _ = try reference.setData(from: response, encoder: .init()) { err in
                if let err = err {
                    print("----------- FirestoreService -- sendResponse -- \(err)")
                    firebaseDelegate.writingFailed(serviceID: serviceId)
                } else {
                    print("----------- FirestoreService -- sendResponse -- SUCCESS")
                    firebaseDelegate.wrote(serviceID: serviceId, docId: reference.documentID)
                }
                
            }
        } catch let err {
            print("----------- FirestoreService -- sendResponse -- catch -- \(err)")
            firebaseDelegate.writingFailed(serviceID: serviceId)
        }
    }
    
    func getResponseFromDB(serviceId: Int, forumId: String, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("responses").document(forumId).collection("comments")
        reference.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("------------- FirestoreService -- getResponseFromDB -- FAILED --  \(err)")
                firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                print("------------- FirestoreService -- getResponseFromDB -- SUCCESS ")
                var responses: [Response] = []
                for document in querySnapshot!.documents {
                    do {
                        let response = try document.data(as: Response.self)
                        if let response = response {
                            responses.append(response)
                        }
                        
                    } catch let err {
                        print("------------- FirestoreService -- getResponseFromDB -- catch -- FAILED -- \(err)")
                        firebaseDelegate.readingFailed(serviceID: serviceId)
                        
                        return
                    }
                }
                
                firebaseDelegate.read(serviceID: serviceId, data: responses as NSObject)
            }
            
        }
    }
    
    func sendReport(serviceId: Int, report: Report, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("reports").document()
        do {
            let _ = try reference.setData(from: report, encoder: .init()) { err in
                if let err = err {
                    print("----------- FirestoreService -- sendReport -- \(err)")
                    firebaseDelegate.writingFailed(serviceID: serviceId)
                } else {
                    print("----------- FirestoreService -- sendReport -- SUCCESS")
                    firebaseDelegate.wrote(serviceID: serviceId, docId: reference.documentID)
                }
            }
        } catch let err {
            print("----------- FirestoreService -- sendReport -- catch -- \(err)")
            firebaseDelegate.writingFailed(serviceID: serviceId)
        }
    }
    
    
    func getReportsFromDB(serviceId: Int, userId: String, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("reports").whereField("user_id", isEqualTo: userId)
        reference.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("------------- FirestoreService -- getReportsFromDB -- FAILED --  \(err)")
                firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                print("------------- FirestoreService -- getReportsFromDB -- SUCCESS ")
                var reports: [Report] = []
                for document in querySnapshot!.documents {
                    do {
                        let report = try document.data(as: Report.self)
                        if let report = report {
                            reports.append(report)
                        }
                        
                    } catch let err {
                        print("------------- FirestoreService -- getReportsFromDB -- catch -- FAILED -- \(err)")
                        firebaseDelegate.readingFailed(serviceID: serviceId)
                        
                        return
                    }
                }
                
                firebaseDelegate.read(serviceID: serviceId, data: reports as NSObject)
            }
            
        }
    }
    
    func getServiceFromDB(serviceId: Int, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let _ = database.collection("services").getDocuments() { (querySnapshot, err) in
            if let err = err {
                    print("------------- FirestoreService -- getServiceFromDB -- FAILED --  \(err)")
                    firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                print("------------- FirestoreService -- getServiceFromDB -- SUCCESS ")
                var services: [Service] = []
                for document in querySnapshot!.documents {
                    do {
                        let service = try document.data(as: Service.self)
                        if let service = service {
                            service.id = document.documentID
                            services.append(service)
                        }
                    } catch let err {
                        print("------------- FirestoreService -- getServiceFromDB -- FAILED --  \(err)")
                        firebaseDelegate.readingFailed(serviceID: serviceId)
                        return
                    }
                }
                
                print("------------- FirestoreService -- getServiceFromDB -- \(services.count)")

                firebaseDelegate.read(serviceID: serviceId, data: services as NSObject)
            }
        }
    }
    
    func getTokenFromDB(serviceId: Int, onDate: String, token: Token, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let _ = database.collection("tokens").whereField("on_date", isEqualTo: onDate)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("------------ FirestoreService -- getTokenFromDB -- \(err)")
                    firebaseDelegate.readingFailed(serviceID: serviceId)
                } else {
                    print("------------ FirestoreService -- getTokenFromDB -- SUCCESS")
                    if let querySnapshot = querySnapshot {
                        let newToken = querySnapshot.documents.count + 1
                        var tokenForSend = token
                        tokenForSend.token = newToken
                        if token.id != nil {
                            self.updateTokenInDB(serviceId: FirestoreService.SERVICE_ID_UPDATE_TOKEN, token: tokenForSend, firebaseDelegate: firebaseDelegate)
                        } else {
                            self.sendToken(serviceId: FirestoreService.SERVICE_ID_SEND_TOKEN,  token: tokenForSend, firebaseDelegate: firebaseDelegate)
                        }
                        
                    } else {
                        print("------------ FirestoreService -- getTokenFromDB -- querySnapshot -- NULL")
                        firebaseDelegate.readingFailed(serviceID: serviceId)
                    }
                }
        }
    }
    
    func sendToken(serviceId: Int, token: Token, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let document = database.collection("tokens").document()
        do {
                try document.setData(from: token, encoder: .init()) { err in
                    if let err = err {
                        print("------------ FirestoreService -- sendToken ------------\(err)")
                        firebaseDelegate.writingFailed(serviceID: serviceId)
                    } else {
                        print("------------ FirestoreService -- sendToken -- SUCCESS \(document.documentID)------------ ")
                        firebaseDelegate.wrote(serviceID: serviceId, docId: document.documentID)
                    }
            }
        } catch let err {
            print("------------ FirestoreService -- sendToken ------------\(err)")
            firebaseDelegate.wrote(serviceID: serviceId, docId: "")
        }
    }
    
    func getTokenDetailsFromDB(serviceId: Int, token: String, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("tokens").document(token)
    
        reference.getDocument() { (document, err) in
            if let err = err {
                print("----------- FirestoreService -- getTokenDetailsFromDB -- \(err) -----------")
                firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                do {
                    if let document = document, document.exists {
                        let token = try document.data(as: Token.self)
                        if let token = token {
                          firebaseDelegate.read(serviceID: serviceId, data: [token] as NSObject)
                        }
                    } else {
                        print("----------- FirestoreService -- getTokenDetailsFromDB -- document does not exist -----------")
                        firebaseDelegate.readingFailed(serviceID: serviceId)
                    }
                    
                } catch let err {
                    print("----------- FirestoreService -- getTokenDetailsFromDB -- catch -- \(err) -----------")
                    firebaseDelegate.readingFailed(serviceID: serviceId)
                }
            }
        }
    }
    
    func getMyTokensFromDB(serviceId: Int, userId: String, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        database.collection("tokens").whereField("user_id", isEqualTo: userId).getDocuments() { (snapshot, err) in
            if let err = err {
                print("------------ FirestoreService -- getMyTokensFromDB -- ERROR -- \(err) -----------")
                firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                print("------------ FirestoreService -- getMyTokensFromDB -- SUCCESS -----------")
                var tokens: [Token] = []
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        do {
                            let token = try document.data(as: Token.self)
                            if var token = token {
                                token.id = document.documentID
                                tokens.append(token)
                            }
                        } catch let err {
                            print("-------- FirestoreService -- getMyTokensFromDB -- CATCH -- \(err)")
                        }
                    }
                }
                
                firebaseDelegate.read(serviceID: serviceId, data: tokens as NSObject)
            }
        }
    }
    
    func updateTokenInDB(serviceId: Int, token: Token, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("tokens").document(token.id)
        reference.updateData(["on_date": token.onDate!, "token_date" : token.tokenDate!, "token": token.token!, "token_time": "N/A"]) { err in
            if let err = err {
                print("-------------- FirestoreService -- updateTokenInDB -- ERROR -- \(err) ------------")
                firebaseDelegate.writingFailed(serviceID: serviceId)
            } else {
                print("-------------- FirestoreService -- updateTokenInDB SUCCESS ------------")
                firebaseDelegate.wrote(serviceID: serviceId, docId: "")
            }
        }
    }
    
    func updateReport(serviceId: Int, forum: Forum, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("forums").document(forum.id)
        reference.updateData(["report_count": forum.reportCount]) { err in
            if let err = err {
                print("-------------- FirestoreService -- updateReport -- ERROR -- \(err) ------------")
                firebaseDelegate.writingFailed(serviceID: serviceId)
            } else {
                print("-------------- FirestoreService -- updateReport SUCCESS ------------")
                firebaseDelegate.wrote(serviceID: serviceId, docId: "")
            }
        }
    }
    
    func updateResponseCount(serviceId: Int, forum: Forum, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        let reference = database.collection("forums").document(forum.id)
        reference.updateData(["response_count": forum.responseCount]) { err in
            if let err = err {
                print("-------------- FirestoreService -- updateResponseCount -- ERROR -- \(err) ------------")
                firebaseDelegate.writingFailed(serviceID: serviceId)
            } else {
                print("-------------- FirestoreService -- updateResponseCount SUCCESS ------------")
                firebaseDelegate.wrote(serviceID: serviceId, docId: forum.id)
            }
        }
    }
    
    func queueUpdate(serviceId: Int, userId: String, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        database.collection("tokens").whereField("user_id", isEqualTo: userId).addSnapshotListener() { (documentSnapshot, err) in
            if let err = err {
                print("---------- FirestoreService -- queueUpdate -- ERROR - \(err) ---------")
                firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                print("---------- FirestoreService -- queueUpdate -- SUCCESS ----------")
                do {
                    guard let documentSnapshot = documentSnapshot else {
                        print("------------- FirestoreService -- queueUpdate -- documentSnapshot -- NULL ----------")
                        return
                    }
                    var tokens: [Token] = []
                    for document in documentSnapshot.documents {
                        let token = try document.data(as: Token.self)
                        if var token = token {
                            token.id = document.documentID
                            tokens.append(token)
                        }
                    }
                    
                    firebaseDelegate.read(serviceID: serviceId, data: tokens as NSObject)
                } catch let err {
                    print("------------- FirestoreService -- queueUpdate -- CATCH -- \(err) ----------")
                    firebaseDelegate.readingFailed(serviceID: serviceId)
                }
            }
        }
    }
    
    func forumUpdate(serviceId: Int, firebaseDelegate: FirebaseDelegate) {
        let database = Firestore.firestore()
        database.collection("forums").addSnapshotListener() { (documentSnapshot, err) in
            if let err = err {
                print("---------- FirestoreService -- forumUpdate -- ERROR - \(err) ---------")
                firebaseDelegate.readingFailed(serviceID: serviceId)
            } else {
                print("---------- FirestoreService -- forumUpdate -- SUCCESS ----------")
                do {
                    guard let documentSnapshot = documentSnapshot else {
                        print("------------- FirestoreService -- forumUpdate -- documentSnapshot -- NULL ----------")
                        return
                    }
                    var forums: [Forum] = []
                    
                    for document in documentSnapshot.documents {
                        let forum = try document.data(as: Forum.self)
                        if var forum = forum {
                            forum.id = document.documentID
                            forums.append(forum)
                        }
                    }
                    
                    firebaseDelegate.read(serviceID: serviceId, data: forums as NSObject)
                } catch let err {
                    print("------------- FirestoreService -- forumUpdate -- CATCH -- \(err) ----------")
                    firebaseDelegate.readingFailed(serviceID: serviceId)
                }
            }
        }
    }
}

