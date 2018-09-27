//
//  Extensions.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let slideMenuClose = Notification.Name("slideMenuClose")
    static let slideMenuTapped = Notification.Name("slideMenuClose")
}

enum AppColor: CustomStringConvertible {
    case lightgray
    case midgray
    case mint
    case navy
    case red
    case yellow

    var description: String {
        switch self {
        case .lightgray: return "mh-lightgray"
        case .midgray: return "mh-midgray"
        case .mint: return "mh-mint"
        case .navy: return "mh-navy"
        case .red: return "mh-red"
        case .yellow: return "mh-yellow"
        }
    }
}

extension UIColor {
    class func appColor(color: AppColor) -> UIColor {
        return UIColor(named: color.description)!
    }
}
