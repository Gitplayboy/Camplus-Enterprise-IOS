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
        
        let firestoreService = FirestoreService()
        firestoreService.getForumsFromDB(serviceId: FirestoreService.SERVICE_ID_GET_FORUMS, firebaseDelegate: self)
    }
    
    func setupTableView() {
        tableForum.delegate = self;
        tableForum.dataSource = self;
        
        tableForum.rowHeight = UITableView.automaticDimension
        tableForum.estimatedRowHeight = 200
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "Public forum"
        self.navigationController?.navigationBar.barStyle = .black
        let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 20)]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute as [NSAttributedString.Key : Any]
       
    }
    
    func setupPlus() {
        btnPlus.layer.cornerRadius = 28
    }
    
    @IBAction func onTextChanged(_ sender: Any) {
        let text = tfSearchBar.text!
        if text.isEmpty {
            forums.removeAll()
            forums.append(contentsOf: tempForum)
            tableForum.reloadData()
        } else {
            search(searchText: text)
        }
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
        var forums = data as! [Forum]
        if serviceID == FirestoreService.SERVICE_ID_LISTEN_FORUM_UPDATE {
            print("------ FORUM COUNT -- \(forums.count) ----------")
            checkForumExistance(newForums: forums)
        } else {
            forums.sort() { (forumX, forumY) in
                return forumX.timestamp > forumY.timestamp
            }
            
            for forum in forums {
                self.forums.append(forum)
                self.tempForum.append(forum)
            }
            
            tableForum.reloadData()
            
            let firestoreService = FirestoreService()
            firestoreService.forumUpdate(serviceId: FirestoreService.SERVICE_ID_LISTEN_FORUM_UPDATE, firebaseDelegate: self)
        }
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
        forums = forums.filter() { forum in
            return forum.title.lowercased().contains(searchText.lowercased())
        }
        
        tableForum.reloadData()
    }
}

extension ForumVC: ForumActionDelegate {
    func report(index: Int) {
        var forum = forums[index]
        forum.reportCount = forum.reportCount + 1
        let firestoreService = FirestoreService()
        firestoreService.updateReport(serviceId: FirestoreService.SERVICE_ID_UPDATE_REPORT, forum: forum, firebaseDelegate: self)
    }
}

extension ForumVC {
    func showReportAlert() {
        let alert = AlertControler.showOKAlert(message: "You have successfully reported")
        self.present(alert, animated: true, completion: nil)
    }
}
