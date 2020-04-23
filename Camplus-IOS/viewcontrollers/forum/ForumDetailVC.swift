//
//  ForumDetailVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 11/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class ForumDetailVC: UIViewController {

    @IBOutlet weak var tableDetails: UITableView!
    var forumDetails : [ForumTableDelegate] = []
    var forum: Forum!
    
    @IBOutlet weak var tfComment: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableDetails.delegate = self
        tableDetails.dataSource = self
        
        tableDetails.rowHeight = UITableView.automaticDimension
        tableDetails.estimatedRowHeight = 300
        
        forumDetails.append(forum)
        getResponses()
    }
    
    func setupSendButton() {
        btnSend.layer.cornerRadius = 20
    }
    
    @IBAction func onSendClicked(_ sender: Any) {
        if validate() {
            let comment = tfComment.text
            var response = Response()
            response.comment = comment!
            response.timestamp = Date().millisecondsSince1970
            response.user_name = appDelegate.userDetails.userName!
            response.user_id = appDelegate.userDetails.userId!
            
            let firestoreService = FirestoreService()
            firestoreService.sendResponse(serviceId: FirestoreService.SERVICE_ID_SEND_RESPONSE, forumId: forum.id, response: response, firebaseDelegate: self)
            
            self.tfComment.text = ""
            
            forumDetails.append(response)
            let indexPath = IndexPath(row: forumDetails.count - 1, section: 0)
            tableDetails.beginUpdates()
            tableDetails.insertRows(at: [indexPath], with: .automatic)
            tableDetails.endUpdates()
            
            tableDetails.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
 
    func validate() -> Bool {
        let comment = tfComment.text
        if let comment = comment, !comment.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        
        return false
    }
}

extension ForumDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forumDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = forumDetails[indexPath.row]
        if (item is Forum) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_forum_detail_header", for: indexPath) as! ForumDetailHeaderCell;
            cell.setForum(forum: item as! Forum)
            return cell;
        } else {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell_forum_response", for: indexPath) as! ForumResponseCell;
            cell.setResponse(response: item as! Response)
            return cell;
        }
    }
}

extension ForumDetailVC {
    func getResponses() {
        let firestoreService = FirestoreService()
        firestoreService.getResponseFromDB(serviceId: FirestoreService.SERVICE_ID_GET_RESPONSES, forumId: forum.id, firebaseDelegate: self)
    }
}

extension ForumDetailVC: FirebaseDelegate {
    func writingFailed(serviceID: Int) {
        print("------------ ForumDetailVC -- writingFailed ------------ ")
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("------------ ForumDetailVC -- wrote ------------ ")
    }
    
    func readingFailed(serviceID: Int) {
        print("------------ ForumDetailVC -- readingFailed ------------ ")
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("------------ ForumDetailVC -- read ------------ ")
        let responses = data as! [Response]
        forumDetails.append(contentsOf: responses)
        tableDetails.reloadData()
    }
}
