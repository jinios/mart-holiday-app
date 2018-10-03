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

extension NMapView {

    func setMapGesture(enable: Bool) {
        self.setPanEnabled(enable)
        self.setZoomEnabled(enable)
        self.isMultipleTouchEnabled = enable
        self.isUserInteractionEnabled = enable
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

