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
    static let mapViewTapped = Notification.Name("mapViewTapped")
    static let connectionStatus = Notification.Name("connectionStatus")
}

enum AppColor: CustomStringConvertible {
    case lightgray
    case midgray
    case lightmint
    case mint
    case navy
    case red
    case yellow

    var description: String {
        switch self {
        case .lightgray: return "mh-lightgray"
        case .midgray: return "mh-midgray"
        case .lightmint: return "mh-lightmint"
        case .mint: return "mh-mint"
        case .navy: return "mh-navy"
        case .red: return "mh-red"
        case .yellow: return "mh-yellow"
        }
    }
}

extension UIAlertController {
    class func noNetworkAlert() -> UIAlertController {
        let alert = UIAlertController(title: ProgramDescription.networkErrorTitle.rawValue,
                                      message: ProgramDescription.noNetworkErrorMsg.rawValue,
                                      preferredStyle: .alert)
        return alert
    }

    class func networkTimeOutAlert() -> UIAlertController {
        let alert = UIAlertController(title: ProgramDescription.sorryErrorTitle.rawValue,
                                      message: ProgramDescription.networkTimeoutMsg.rawValue,
                                      preferredStyle: .alert)
        return alert
    }

}

extension UIColor {
    class func appColor(color: AppColor) -> UIColor {
        return UIColor(named: color.description)!
    }
}

extension UIFont {
    func bold() -> UIFont {
        let desc = self.fontDescriptor.withSymbolicTraits(.traitBold)
        return UIFont(descriptor: desc!, size: self.pointSize)
    }
}

extension UIButton {
    func setArrowImage() {
        self.setImage(UIImage(named: "downArrow"), for: .normal)
        self.setImage(UIImage(named: "upArrow"), for: .selected)
    }
}

extension UILabel {
    func partialBackgroundChange(fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.appColor(color: .yellow) , range: range)
        self.attributedText = attribute
    }
}

extension NMapView {

    func setMapGesture(enable: Bool) {
        self.setPanEnabled(enable)
        self.setZoomEnabled(enable)
        self.isMultipleTouchEnabled = enable
    }

    func setCenter(point: GeoPoint) {
        let x = point.x
        let y = point.y
        self.setMapCenter(NGeoPoint(longitude:x, latitude:y), atLevel:12)
    }

    func showMarker(at point: GeoPoint) {
        let x = point.x
        let y = point.y

        if let mapOverlayManager = self.mapOverlayManager {

            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {

                poiDataOverlay.initPOIdata(1)

                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: x, latitude: y), title: "", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)

                poiDataOverlay.endPOIdata()
                poiDataOverlay.showAllPOIdata()
            }
        }
    }

}

extension Collection where Index == Int {

    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }

}

