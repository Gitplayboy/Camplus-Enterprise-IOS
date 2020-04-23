//
//  QueueThankYouVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 15/04/20.
//  Copyright © 2020 yadhukrishnan E. All rights reserved.
//

import UIKit

class QueueThankYouVC: UIViewController {

    @IBOutlet weak var labelTokenNumber: UILabel!
    @IBOutlet weak var labelAppointmentInfo: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnGoToAppointments: UIButton!
    
    var token: String!
    var service: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        
        let firestore = FirestoreService()
        firestore.getTokenDetailsFromDB(serviceId: FirestoreService.SERVICE_ID_GET_PARTICULAR_TOKEN, token: token, firebaseDelegate: self)
    }
    
    func setupNavigation() {
        if #available(iOS 13.0, *) {
                   let app = UIApplication.shared
                   let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                   
                   let statusbarView = UIView()
                   statusbarView.backgroundColor = UIColor(hexa: "#232F34")
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
                   statusBar?.backgroundColor = UIColor(hexa: "#232F34")
               }
        
        navigationController?.navigationBar.backgroundColor = UIColor(hexa: "#232F34");
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    
    func setupUI() {
        btnGoToAppointments.layer.cornerRadius = 8
        viewContainer.layer.cornerRadius = 8
        viewContainer.layer.shadowOpacity = 0.09
    }
   
    @IBAction func onFinishedClicked(_ sender: Any) {
        
    }
    
    func setTokenDetails(token: Token) {
        labelTokenNumber.text = "Your Token Number is \(token.token!)"
        labelAppointmentInfo.text = "You booked an appointment on \(token.onDate!)"
    }
    
}

extension QueueThankYouVC: FirebaseDelegate {
    
    func writingFailed(serviceID: Int) {
        print("------------- QueueThankYouVC -- writingFailed -----------")
        
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("------------- QueueThankYouVC -- wrote -----------")
    }
    
    func readingFailed(serviceID: Int) {
        print("------------- QueueThankYouVC -- readingFailed -----------")
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("------------- QueueThankYouVC -- read -----------")
        let tokens = data as! [Token]
        if tokens.count > 0 {
            let token = tokens[0]
            setTokenDetails(token: token)
        }
    }
    
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
