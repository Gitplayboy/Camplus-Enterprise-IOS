//
//  QueueDateTimeVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 15/04/20.
//  Copyright © 2020 yadhukrishnan E. All rights reserved.
//

import UIKit
import GCCalendar

class QueueDateTimeVC: UIViewController {

    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var calendarViewContainer: UIView!
    var calendarView : GCCalendarView!
    
    var service: Service!
    var selectedDate: Date!
    var tokenId: String!
    
    var token: Token!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendarView = GCCalendarView()
        self.calendarView.delegate = self
        self.calendarView.displayMode = .month
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.calendarViewContainer.addSubview(self.calendarView)
        
        addConstraints()
        
        setDate()
        
        setupNextButton()
    }
    
    func setupNextButton() {
        btnNext.layer.cornerRadius = 8
    }
    
    func setDate() {
        if (token != nil) {
            let dateToSelect = token.onDate
            let dateFormatter = DateFormatter()
            let calendar = Calendar.init(identifier: .gregorian)
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy MMMM dd", options: 0, locale: calendar.locale)
            let date = dateFormatter.date(from: dateToSelect!)
            calendarView.select(date: date!)
        }
    }
    
    
    @IBAction func onNextClicked(_ sender: Any) {
        let dateFormatter = DateFormatter()
        let calendar = Calendar.init(identifier: .gregorian)
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMMM yyyy", options: 0, locale: calendar.locale)
        let sendDate = dateFormatter.string(from: selectedDate)
        
        let firestoreService = FirestoreService()
        
        if token == nil {
            var token = Token()
            token.onDate = sendDate
            token.tokenDate = selectedDate.millisecondsSince1970
            token.status = 1
            token.timestamp = Date().millisecondsSince1970
            token.userId = appDelegate.userDetails.userId!
            token.serviceId = service.id
            token.serviceTitle = service.title
            token.serviceLocation = service.location
            token.servicePhone = service.phone
            
            firestoreService.getTokenFromDB(serviceId: FirestoreService.SERVICE_ID_GET_TOKEN, onDate: sendDate, token: token, firebaseDelegate: self)
        } else {
            token.onDate = sendDate
            token.tokenDate = selectedDate.millisecondsSince1970
            
            firestoreService.getTokenFromDB(serviceId: FirestoreService.SERVICE_ID_GET_TOKEN, onDate: sendDate, token: token, firebaseDelegate: self)
        }
    }
}

fileprivate extension QueueDateTimeVC {
    
    func addConstraints() {
        self.calendarView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.calendarView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.calendarView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
}

extension QueueDateTimeVC: GCCalendarViewDelegate {
    
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar) {
        self.selectedDate = date
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: calendar.locale)
        self.labelMonth.text = dateFormatter.string(from: date)
    }
    
    func pastDatesEnabled(calendarView: GCCalendarView) -> Bool {
        false
    }
}

extension QueueDateTimeVC: FirebaseDelegate {
    func writingFailed(serviceID: Int) {
        print("----------- QueueDateTimeVC -- writingFailed -----------")
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("----------- QueueDateTimeVC -- wrote \(docId)-----------")
        if (token == nil) {
            tokenId = docId
        } else {
            tokenId = token.id
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "segue_select_date_to_thank_you", sender: nil)
        }
    }
    
    func readingFailed(serviceID: Int) {
        print("----------- QueueDateTimeVC -- readingFailed -----------")
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("----------- QueueDateTimeVC -- read -----------")
    }
}

extension QueueDateTimeVC {
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let token = tokenId, !token.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! QueueThankYouVC
        destination.token = tokenId
        destination.service = service.id
    }
}
