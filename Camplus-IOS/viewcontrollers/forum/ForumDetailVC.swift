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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfComment: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    var normalBottomConstraint: CGFloat!
    
    var rowPosition: Int!
    var responseDelegate: ResponseDelegate!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        tfComment.delegate = self
        tableDetails.delegate = self
        tableDetails.dataSource = self
        
        tableDetails.rowHeight = UITableView.automaticDimension
        tableDetails.estimatedRowHeight = 300
        
        normalBottomConstraint = bottomConstraint.constant
        forumDetails.append(forum)
        getResponses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupNavigation() {
           if #available(iOS 13.0, *) {
                      let app = UIApplication.shared
                      let statusBarHeight: CGFloat = app.statusBarFrame.size.height

                      let statusbarView = UIView()
                      statusbarView.backgroundColor = UIColor(hexa: "#022834")
                      view.addSubview(statusbarView)

                      statusbarView.translatesAutoresizingMaskIntoConstraints = false
                      statusbarView.heightAnchor
                          .constraint(equalToConstant: statusBarHeight).isActive = true
                      statusbarView.widthAnchor
                          .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                      statusbarView.topAnchor
                          .constraint(equalTo: view.topAnchor).isActive = true
                      statusbarView.centerXAnchor
                          .constraint(equalTo: view.centerXAnchor).isActive = true

                  } else {
                      let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                      statusBar?.backgroundColor = UIColor(hexa: "#022834")
                  }

           navigationController?.navigationBar.backgroundColor = UIColor(hexa: "#022834");
           navigationController?.navigationBar.tintColor = UIColor.white
        
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
            
            tfComment.resignFirstResponder()
            
            forum.responseCount = forum.responseCount + 1
            
            firestoreService.updateResponseCount(serviceId: FirestoreService.SERVICE_ID_UPDATE_RESPONSE_COUNT, forum: forum, firebaseDelegate: self)
        }
    }
 
    func validate() -> Bool {
        let comment = tfComment.text
        if let comment = comment, !comment.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        
        return false
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                if self.bottomConstraint.constant < 300 {
                    self.bottomConstraint.constant += keyboardHeight - 35
                }
            }
            
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.bottomConstraint.constant = normalBottomConstraint!
    }
}

extension ForumDetailVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
            cell.setForum(forum: item as! Forum, actionDelegate: self)
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
        if (serviceID == FirestoreService.SERVICE_ID_UPDATE_REPORT) {
            let alert = AlertControler.showOKAlert(message: "you have reported an issue")
            self.present(alert, animated: true) {
                
            }
        } else if serviceID == FirestoreService.SERVICE_ID_UPDATE_RESPONSE_COUNT {
            if let delegate = responseDelegate {
                delegate.updateCount(row: rowPosition, count: forumDetails.count - 1)
            }
        }
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

extension ForumDetailVC: ForumActionDelegate {
    func report(index: Int) {
        let forum = forumDetails[0] as! Forum
        let firestoreService = FirestoreService()
        firestoreService.updateReport(serviceId: FirestoreService.SERVICE_ID_UPDATE_REPORT, forum: forum, firebaseDelegate: self)
    }
}
