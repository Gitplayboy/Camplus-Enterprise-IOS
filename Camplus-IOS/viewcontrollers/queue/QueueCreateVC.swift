//
//  QueueCreateVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 14/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class QueueCreateVC: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var tvServices: UITableView!
    var services: [Service] = []
    
    var lastSelectedServiceIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setupNavigationBar()
        setupUI()
        setupTable()
        getServices()
    }
    
    func setupNavigationBar() {
           self.navigationController?.navigationBar.barStyle = .black
           let titleTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 19)]
           self.navigationController?.navigationBar.titleTextAttributes = titleTextAttribute as [NSAttributedString.Key : Any]
           
           navigationController?.navigationBar.barTintColor = UIColor(hexa: "#232F34");
    }
    
    func setupTable() {
        tvServices.delegate = self
        tvServices.dataSource = self
    }
    
    func setupUI() {
        viewContainer.layer.cornerRadius = 8
        viewContainer.layer.shadowOpacity = 0.09
        
        btnNext.layer.cornerRadius = 8
        
        btnNext.isEnabled = false
    }

    func getServices() {
        let firestoreService = FirestoreService()
        firestoreService.getServiceFromDB(serviceId: FirestoreService.SERVICE_ID_GET_SERVICES, firebaseDelegate: self)
    }
}

extension QueueCreateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let service = services[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_service", for: indexPath) as! ServiceTVCell
        cell.setService(service: service)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ServiceTVCell
        changeSelection(index: indexPath)
        cell.itemSelecteChanged(service: services[indexPath.row])
        if checkSelection() {
            btnNext.isEnabled = true
        } else {
            btnNext.isEnabled = false
        }
    }
    
    func changeSelection(index: IndexPath) {
       
        if lastSelectedServiceIndex != -1 , lastSelectedServiceIndex != index.row {
            services[lastSelectedServiceIndex].isSelected = false
            let indexPath = IndexPath(row: lastSelectedServiceIndex, section: 0)
            let cell = tvServices.cellForRow(at: indexPath) as! ServiceTVCell
            cell.setService(service: services[lastSelectedServiceIndex])
        }
        
        lastSelectedServiceIndex = index.row
    }
    
    func checkSelection() -> Bool {
        var isChecked = false
        for service in services {
            if service.isSelected {
                isChecked = true
                break
            }
        }
        
        return isChecked
    }
}

extension QueueCreateVC: FirebaseDelegate {
    
    func writingFailed(serviceID: Int) {
        print("------------ QueueCreateVC -- writingFailed -----------")
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("------------ QueueCreateVC -- wrote -----------")
    }
    
    func readingFailed(serviceID: Int) {
        print("------------ QueueCreateVC -- readingFailed -----------")
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("------------ QueueCreateVC -- read -----------")
        services = data as! [Service]
        tvServices.reloadData()
    }
}

extension QueueCreateVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! QueueDateTimeVC
        destination.service = services[lastSelectedServiceIndex]
    }
}

