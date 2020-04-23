//
//  EnhancedUIColor.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 14/04/20.
//  Copyright © 2020 vibin joby. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hexa: String) {
        var hexSanitized = hexa.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt32 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension Date {
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    var millisecondsSince1970 : Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    static func getCurrentDate(format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: Date())
    }
    
    static func toNewFormat(format : String, milliSecond : Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(milliSecond) / 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        print(formatter.string(from: date))
        print(date.timeIntervalSinceReferenceDate)
        
        return formatter.string(from: date)
    }
}
