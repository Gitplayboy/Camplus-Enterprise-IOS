//
//  AlertDialog.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 22/04/20.
//  Copyright © 2020 yadhukrishnan E. All rights reserved.
//

import Foundation
import UIKit

class AlertControler {
    
    public static let TITLE = "Camplus"
    
    static func showOKAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: AlertControler.TITLE, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        
        }))
       
        return alert
    }
}
