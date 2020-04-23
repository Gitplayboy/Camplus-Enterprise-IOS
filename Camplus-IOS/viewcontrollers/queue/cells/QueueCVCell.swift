//
//  QueueCVCell.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 14/04/20.
//  Copyright © 2020 yadhukrishnan E. All rights reserved.
//

import UIKit

class QueueCVCell: UICollectionViewCell {
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var labelPhone: UILabel!
    
    @IBOutlet weak var btnReschedule: UIButton!
    
    var cellInteractionDelegate: QueueCellInteractionDelegate!
    
    func setAppointment(index: Int
        , appointment: Appointment) {
        self.contentView.layer.cornerRadius = 8
        btnReschedule.layer.cornerRadius = 8
        btnReschedule.layer.borderColor = UIColor.white.cgColor
        btnReschedule.layer.borderWidth = 2
        btnReschedule.tag = index
        
        self.labelTitle.text = "Consulation with \(appointment.serviceTitle!)"
        self.labelDate.text = appointment.onDate
        self.labelTime.text = appointment.tokenTime
        self.labelLocation.text = appointment.serviceLocation
        self.labelPhone.text = appointment.servicePhone
        
        if (appointment.isNew == 2) {
            btnReschedule.isHidden = true
        } else {
            btnReschedule.isHidden = false
        }
    }
    
    @IBAction func onRescheduleClicked(_ sender: Any) {
        if let delegate = cellInteractionDelegate {
            let reschedule = sender as! UIButton
            delegate.rescheduleClicked(index: reschedule.tag)
        }
    }
    
}
