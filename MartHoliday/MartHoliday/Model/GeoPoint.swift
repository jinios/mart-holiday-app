//
//  GeoPoint.swift
//  MartHoliday
//
//  Created by YOUTH2 on 12/04/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import Foundation
import NMapsMap

class GeoPoint {
    var latitude: Double
    var longitude: Double

    var NMapPoint: NMGLatLng {
        return NMGLatLng(lat: self.latitude, lng: self.longitude)
    }

    init(lat: Double, lng: Double) {
        self.latitude = lat
        self.longitude = lng
    }

}

extension NMGLatLng {
    convenience init(geoPoint: GeoPoint) {
        self.init(lat: geoPoint.latitude, lng: geoPoint.longitude)
    }
}
