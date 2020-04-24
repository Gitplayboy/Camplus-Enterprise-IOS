//
//  ForumCtreateVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 11/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ForumCreateVC: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var interactionDelegate: InteractionDelegate!
    
    var categories: [Category] = []
    
    var forum: Forum!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTextView()
        setupSubmit()
        getCategoriesFromDB()
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
    
    func setupColletionView() {
        cvCategory.delegate = self
        cvCategory.dataSource = self
    }
    
    func setupSubmit() {
        btnSubmit.layer.cornerRadius = 4
    }
    
    func setupTextView() {
        tvDescription.layer.borderColor = UIColor(hexa: "#00000017")?.cgColor
        tvDescription.layer.borderWidth = 0.4
        tvDescription.layer.cornerRadius = 4
        tvDescription.delegate = self
        tfTitle.delegate = self
        addDoneButtonOnKeyboard()
    }

    func getCategoriesFromDB() {
        let dbService = FirestoreService()
        dbService.getForumCategories(serviceId: FirestoreService.SERVICE_ID_GET_CATEGORIES, self);
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        if !validateData() {
            let alert = AlertControler.showOKAlert(message: "You need to enter a valid data")
            self.present(alert, animated: true) {
                
            }
            return
        }
        
        let title = tfTitle.text!.trimmingCharacters(in: .whitespaces)
        let description = tvDescription.text!.trimmingCharacters(in: .whitespaces)
        let categories = getCategories()
        
        forum = Forum()
        forum.title = title
        forum.description = description
        forum.categories = categories
        forum.timestamp = Date().millisecondsSince1970
        forum.user_id = appDelegate.userDetails.userId!
        forum.user_name = appDelegate.userDetails.userName
        
        let firestoreService = FirestoreService()
        firestoreService.sendForumToDB(serviceId: FirestoreService.SERVICE_ID_CREATE_FORUM, forum: forum, firebaseDelegate: self)
    }
    
    func getCategories() -> [String] {
        var catArray: [String] = []
        for category in categories {
            if (category.selectStatus == true) {
                catArray.append(category.title)
            }
        }
        
        return catArray
    }
    
    func validateData() -> Bool {
        let title = tfTitle.text!.trimmingCharacters(in: .whitespaces)
        let description = tvDescription.text!.trimmingCharacters(in: .whitespaces)
        let categories = getCategories()
        
        if title.count > 0, description.count > 0, categories.count > 0 {
            return true
        } else {
            return false
        }
    }
}

extension ForumCreateVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_category", for: indexPath) as! ForumCategoryCell
        cell.setCategory(category: category)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ForumCategoryCell
        cell.itemSelected(categories[indexPath.row])
    }
}

extension ForumCreateVC: FirebaseDelegate {
    
    func writingFailed(serviceID: Int) {
        print("------------ ForumCreateVC -- writingFailed -----------")
        if InternetConnectionManager.isConnectedToNetwork() {
            print("connected")
        } else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            navigationController?.pushViewController(noInternetVC, animated: true)
        }
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("------------ ForumCreateVC -- wrote -----------")
        self.forum.id = docId
        self.interactionDelegate.itemAdded(item: self.forum)
        self.navigationController?.popViewController(animated: true)
    }
    
    func readingFailed(serviceID: Int) {
        print("------------ ForumCreateVC -- readingFailed -----------")
        if InternetConnectionManager.isConnectedToNetwork() {
            print("connected")
        } else{
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let noInternetVC = mainStoryboard.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            navigationController?.pushViewController(noInternetVC, animated: true)
        }
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("------------ ForumCreateVC -- read -----------")
        categories = data as! [Category]
        setupColletionView()
    }
}

extension ForumCreateVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let description = textView.text!
        if (description == "Description") {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        tvDescription.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        tvDescription.resignFirstResponder()
    }
    
}

extension ForumCreateVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tvDescription.becomeFirstResponder()
    }
}


