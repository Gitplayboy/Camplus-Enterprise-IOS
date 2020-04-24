//
//  ForumVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 08/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class ForumVC: UIViewController {

    @IBOutlet weak var tableForum: UITableView!
    @IBOutlet weak var btnPlus: UIButton!
    
    @IBOutlet weak var tfSearchBar: UITextField!
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    
    @IBOutlet var viewNoItem: UIView!
    
    var tempForum: [Forum] = []
    var forums: [Forum] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        self.tabBarController!.navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlus()
        
        setupTableView()
        setupSearchField()
        
        let firestoreService = FirestoreService()
        firestoreService.getForumsFromDB(serviceId: FirestoreService.SERVICE_ID_GET_FORUMS, firebaseDelegate: self)
    }
    
    func setupTableView() {
        tableForum.delegate = self;
        tableForum.dataSource = self;
        
        tableForum.backgroundView = viewNoItem
        tableForum.rowHeight = UITableView.automaticDimension
        tableForum.estimatedRowHeight = 200
    }
    
    func setupSearchField() {
        tfSearchBar.delegate  = self
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "Public forum"
        self.navigationController?.navigationBar.barStyle = .black
        let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "ProximaNova-Bold", size: 20)]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute as [NSAttributedString.Key : Any]
       
    }
    
    func setupPlus() {
        btnPlus.layer.cornerRadius = 28
    }
    
    @IBAction func onTextChanged(_ sender: Any) {
        let text = tfSearchBar.text!.trimmingCharacters(in: .whitespaces)
        if text.isEmpty {
            forums.removeAll()
            forums.append(contentsOf: tempForum)
            tableForum.reloadData()
        } else {
            search(searchText: text)
        }
        
        checkEmpty()
    }
}

extension ForumVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ForumVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forum_header", for: indexPath) as! ForumTableHeaderCell
        let forum = forums[indexPath.row]
        cell.initForumUI(indexPath.row, actionDelegate: self);
        cell.setForum(form: forum)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func checkEmpty() {
        if forums.count == 0 {
            viewNoItem.isHidden = false
        } else {
            viewNoItem.isHidden = true
        }
    }
}

extension ForumVC: InteractionDelegate {
    func itemAdded(item: Forum) {

    }
}

extension ForumVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let id = segue.identifier
        if (id == "segue_forum_to_create_forum") {
            let createVC = segue.destination as! ForumCreateVC
            createVC.interactionDelegate = self
        } else if (id == "segue_forum_to_detail_forum") {
            let indexPath = tableForum.indexPath(for: sender as! UITableViewCell)
            if let indexPath = indexPath {
                let detailForum = segue.destination as! ForumDetailVC
                detailForum.forum = forums[indexPath.row]
                detailForum.rowPosition = indexPath.row
                detailForum.responseDelegate = self
            }
        }
    }
}

extension ForumVC: FirebaseDelegate {
    
    func writingFailed(serviceID: Int) {
        print("------------ ForumVC --  writingFailed ----------")
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("------------ ForumVC --  wrote ----------")
        if serviceID == FirestoreService.SERVICE_ID_UPDATE_REPORT {
            self.showReportAlert()
        }
    }
    
    func readingFailed(serviceID: Int) {
        print("------------ ForumVC --  readingFailed ----------")
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("------------ ForumVC --  read ----------")
        
        if serviceID == FirestoreService.SERVICE_ID_LISTEN_FORUM_UPDATE {
            print("------ IF FORUM COUNT -- \(forums.count) ----------")
            let forums = data as! [Forum]
            checkForumExistance(newForums: forums)
        } else if serviceID ==  FirestoreService.SERVICE_ID_GET_REPORTS {
            print("------ FORUM GET REPORTS ----------")
            let reports = data as! [Report]
            if reports.count > 0 {
                for report in reports {
                    var i = 0
                    while i < forums.count {
                        if report.forumId == forums[i].id {
                            forums[i].isReport = true
                            
                            tableForum.beginUpdates()
                            let indexPath = IndexPath(row: i, section: 0)
                            tableForum.reloadRows(at: [indexPath], with: .automatic)
                            tableForum.endUpdates()
                        }
                        
                        i = i + 1
                    }
                    
                    for forum in tempForum {
                        var form = forum
                        if report.forumId == forum.id {
                            form.isReport = true
                        }
                    }
                    
                }
                
                
            }
        } else {
            print("------ ELSE FORUM COUNT -- \(forums.count) ----------")
            var forums = data as! [Forum]
            if (forums.count > 1) {
                forums.sort() { (forumX, forumY) in
                    return forumX.timestamp > forumY.timestamp
                }
            }
            
            for forum in forums {
                self.forums.append(forum)
                self.tempForum.append(forum)
            }
            
            tableForum.reloadData()
            checkEmpty()
            
            let firestoreService = FirestoreService()
            firestoreService.forumUpdate(serviceId: FirestoreService.SERVICE_ID_LISTEN_FORUM_UPDATE, firebaseDelegate: self)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            firestoreService.getReportsFromDB(serviceId: FirestoreService.SERVICE_ID_GET_REPORTS, userId: appDelegate.userDetails.userId!, firebaseDelegate: self)
            
        }
        
        checkEmpty()
    }
    
    func checkForumExistance(newForums: [Forum]) {
        for forum in newForums {
            var isExist = false
            for oldForum in forums {
                if oldForum.id == forum.id {
                    isExist = true
                    break
                }
            }
            
            if !isExist {
                forums.insert(forum, at: 0)
                tempForum.insert(forum, at: 0)
                
                tableForum.beginUpdates()
                let indexPath = IndexPath(row: 0, section: 0)
                tableForum.insertRows(at: [indexPath], with: .top)
                tableForum.endUpdates()
            }
        }
    }
    
    
}

extension ForumVC {
    func search(searchText: String) {
        forums = tempForum.filter() { forum in
            return forum.title.lowercased().contains(searchText.lowercased())
        }
        
        tableForum.reloadData()
    }
}

extension ForumVC: ForumActionDelegate {
    func report(index: Int) {
        var forum = forums[index]
        if (!forum.isReport) {
            forum.reportCount = forum.reportCount + 1
            let firestoreService = FirestoreService()
            firestoreService.updateReport(serviceId: FirestoreService.SERVICE_ID_UPDATE_REPORT, forum: forum, firebaseDelegate: self)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let report = Report()
            report.forumId = forum.id
            report.userId = appDelegate.userDetails.userId!
            firestoreService.sendReport(serviceId: FirestoreService.SERVICE_ID_SEND_REPORT, report: report, firebaseDelegate: self)
            
            forums[index].isReport = true
            tableForum.beginUpdates()
            let indexPath = IndexPath(row: index, section: 0)
            tableForum.reloadRows(at: [indexPath], with: .automatic)
            tableForum.endUpdates()
        } else {
            let alert = AlertControler.showOKAlert(message: "You have already reported")
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

extension ForumVC {
    func showReportAlert() {
        let alert = AlertControler.showOKAlert(message: "you have reported an issue")
        self.present(alert, animated: true, completion: nil)
    }
}

extension ForumVC: ResponseDelegate {
    func updateCount(row: Int, count: Int) {
        forums[row].responseCount = count
        let indexPath = IndexPath(row: row, section: 0)
        tableForum.reloadRows(at: [indexPath], with: .automatic)
    }
}

