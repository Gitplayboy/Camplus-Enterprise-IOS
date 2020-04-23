//
//  ServiceTVCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 14/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit

class ServiceTVCell: UITableViewCell {

    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var labelService: UILabel!
    
    func setService(service: Service) {
        labelService.text = service.title
        if service.isSelected {
            viewCircle.backgroundColor = UIColor(hexa: "#FFAA20")
            viewCircle.layer.borderColor = UIColor.gray.cgColor
        } else {
            viewCircle.backgroundColor = UIColor(hexa: "#00000017")
            viewCircle.layer.borderColor = UIColor.gray.cgColor
        }
        
        viewCircle.layer.cornerRadius = 8
        
    }
    
    func itemSelecteChanged(service: Service) {
        if (!service.isSelected) {
            service.isSelected = true
        } else {
            service.isSelected = false
        }
        
        setService(service: service)
    }
    
}
