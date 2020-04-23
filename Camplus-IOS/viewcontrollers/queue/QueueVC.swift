//
//  QueueVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 14/04/20.
//  Copyright © 2020 yadhukrishnan E. All rights reserved.
//

import UIKit

class QueueVC: UIViewController {

    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var labelEmpty: UILabel!
    @IBOutlet weak var cvQueues: UICollectionView!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var ivEmptyImage: UIImageView!
    
    var appointments: [Appointment] = []
    var upcomingAppointments: [Appointment] = []
    var postAppointments: [Appointment] = []
    
    var reschedulingAppointment: Appointment!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        self.tabBarController!.navigationItem.rightBarButtonItem?.customView?.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupSegment()
        setupUI()
        getTokens()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "Queue"
           self.navigationController?.navigationBar.barStyle = .black
           let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 17)]
           self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute as [NSAttributedString.Key : Any]
           
    }
    
    func setupSegment() {
        let textAttribute = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 14)]
        segmentController.setTitleTextAttributes(textAttribute as [NSAttributedString.Key : Any], for: .normal)
    }
    
    func setupUI() {
        btnBook.layer.cornerRadius = 8
        cvQueues.delegate = self
        cvQueues.dataSource = self
    }
    
    
    @IBAction func onSegmentChanged(_ sender: Any) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            print("------- SEGMENT ONE --------")
            btnBook.isHidden = false
            loadUPCOMINGAppointment()
        case 1:
            print("------- SEGMENT TWO --------")
            btnBook.isHidden = true
            loadPOSTAppointment()
        default:
            print("--------- Nothing selected --------")
        }
    }
    
    func loadUPCOMINGAppointment() {
        appointments.removeAll()
        appointments.append(contentsOf: upcomingAppointments)
        if (appointments.count > 1) {
            sortArray()
        }
        cvQueues.reloadData()
        checkEmpty(which: 0)
    }
    
    func loadPOSTAppointment() {
        appointments.removeAll()
        appointments.append(contentsOf: postAppointments)
        if (appointments.count > 1) {
            sortArray()
        }
        cvQueues.reloadData()
        checkEmpty(which: 1)
    }
    
    func getTokens() {
       let firestoreService = FirestoreService()
        firestoreService.getMyTokensFromDB(serviceId: FirestoreService.SERVICE_ID_GET_MY_TOKEN, userId: appDelegate.userDetails.userId!, firebaseDelegate: self)
    }
    
    @IBAction func unwindToQueueList(segue: UIStoryboardSegue) {
        print("----------- QueueVC -- unwindToQueueList ------------")
        
    }

}

extension QueueVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appointments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_token", for: indexPath) as! QueueCVCell
        cell.setAppointment(index: indexPath.row, appointment: appointments[indexPath.row])
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.cellInteractionDelegate = self
        return cell
    }
}

extension QueueVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: cvQueues.frame.height)
    }
}

extension QueueVC: FirebaseDelegate {
    
    func writingFailed(serviceID: Int) {
        print("----------- QueueVC -- writingFailed ------------")
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("----------- QueueVC -- wrote ------------")
    }
    
    func readingFailed(serviceID: Int) {
        print("----------- QueueVC -- readingFailed ------------")
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("----------- QueueVC -- read \(serviceID)------------")
        if serviceID == FirestoreService.SERVICE_ID_LISTEN_TOKEN_UPDATE {
            let tokens = data as![Token]
            print("----------- QueueVC -- read UPDATED SOMEBODY -- \(tokens.count) ------------")
            updateAppointment(tokens: tokens)
        } else {
            let tokens = data as! [Token]
            if tokens.count > 0 {
                print("-------------- TOKEN COUNT -- \(tokens.count) ---------")
                addAppointment(tokens: tokens)
                let firestoreService = FirestoreService()
                firestoreService.queueUpdate(serviceId: FirestoreService.SERVICE_ID_LISTEN_TOKEN_UPDATE, userId: appDelegate.userDetails.userId!, firebaseDelegate: self)
            }
        }
    }
    
    func addAppointment(tokens: [Token]) {
        for token in tokens {
            let appointment = Appointment()
            appointment.id = token.id
            appointment.serviceTitle = token.serviceTitle
            appointment.isNew = token.status
            appointment.onDate = token.onDate
            appointment.serviceId = token.serviceId
            appointment.serviceLocation = token.serviceLocation
            appointment.servicePhone = token.servicePhone
            appointment.tokenDate = token.tokenDate
            appointment.tokenTime = token.tokenTime
            if token.status == 2 {
                 postAppointments.append(appointment)
            } else {
                upcomingAppointments.append(appointment)
            }
        }
        
        loadUPCOMINGAppointment()
    }
    
    func updateAppointment(tokens: [Token]) {
        for token in tokens {
            var isNotAvail = false
            for appointment in upcomingAppointments {
                if token.id == appointment.id {
                    isNotAvail = true
                    appointment.serviceTitle = token.serviceTitle
                    appointment.isNew = token.status
                    appointment.onDate = token.onDate
                    appointment.serviceId = token.serviceId
                    appointment.serviceLocation = token.serviceLocation
                    appointment.servicePhone = token.servicePhone
                    appointment.tokenDate = token.tokenDate
                    appointment.tokenTime = token.tokenTime
                }
            }
            
            for appointment in postAppointments {
                if token.id == appointment.id {
                    isNotAvail = true
                    appointment.serviceTitle = token.serviceTitle
                    appointment.isNew = token.status
                    appointment.onDate = token.onDate
                    appointment.serviceId = token.serviceId
                    appointment.serviceLocation = token.serviceLocation
                    appointment.servicePhone = token.servicePhone
                    appointment.tokenDate = token.tokenDate
                    appointment.tokenTime = token.tokenTime
                }
            }
            
            if !isNotAvail {
                let appointment = Appointment()
                appointment.id = token.id
                appointment.serviceTitle = token.serviceTitle
                appointment.isNew = token.status
                appointment.onDate = token.onDate
                appointment.serviceId = token.serviceId
                appointment.serviceLocation = token.serviceLocation
                appointment.servicePhone = token.servicePhone
                appointment.tokenDate = token.tokenDate
                appointment.tokenTime = token.tokenTime
                if token.status == 2 {
                     postAppointments.append(appointment)
                } else {
                    upcomingAppointments.append(appointment)
                }
            }
        }
        
        loadUPCOMINGAppointment()
    }
    
    func checkEmpty(which: Int) {
        
        if which == 0, upcomingAppointments.count == 0 {
            cvQueues.isHidden = true
            labelEmpty.isHidden = false
            ivEmptyImage.isHidden = false
        } else if which == 1, postAppointments.count == 0 {
            cvQueues.isHidden = true
            labelEmpty.isHidden = false
            ivEmptyImage.isHidden = false
        } else {
            cvQueues.isHidden = false
            labelEmpty.isHidden = true
            ivEmptyImage.isHidden = true
        }
    }
    
    func sortArray() {
        self.appointments.sort() { (appointmentX, appointmentY) in
            return appointmentX.tokenDate < appointmentY.tokenDate
        }
    }
}

extension QueueVC: QueueCellInteractionDelegate {
    func rescheduleClicked(index: Int) {
        self.reschedulingAppointment = appointments[index]
        self.performSegue(withIdentifier: "segue_reschedule_to_date_screen", sender: nil)
    }
}

extension QueueVC {
        
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segue_reschedule_to_date_screen", self.reschedulingAppointment == nil {
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if let identifier = identifier {
            if identifier == "segue_reschedule_to_date_screen" {
                var token = Token()
                token.id = self.reschedulingAppointment.id
                token.onDate = self.reschedulingAppointment.onDate
                
                let service = Service()
                service.id = self.reschedulingAppointment.serviceId
                service.location = self.reschedulingAppointment.serviceLocation
                service.title = self.reschedulingAppointment.serviceTitle
                service.phone = self.reschedulingAppointment.servicePhone
                
               
                let destination = segue.destination as! QueueDateTimeVC
                destination.service = service
                destination.token = token
            }
        }
    }
}
