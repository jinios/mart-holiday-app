//
//  MartMapDelegate.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 30..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MartMapDelegate: NSObject, NMapViewDelegate, NMapPOIdataOverlayDelegate {

    var addressToShow: String
    var centerPoint: GeoPoint?
    var mapView: NMapView?

    init(address: String) {
        self.addressToShow = address
    }

    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        print(mapView)
        print(self)
        if (error == nil) {
            MapSetter.tryGeoRequestTask(address: addressToShow) { geo in
                DispatchQueue.main.async {
                    self.centerPoint = geo
                    self.mapView = mapView
                    mapView.showMarker(at: geo)
                    mapView.setCenter(point: geo)
                    mapView.setMapEnlarged(true, mapHD: true)
                    mapView.mapViewMode = .vector
                }
            }
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }

    func setMapCenter() {
        guard let mapView = mapView else { return }
        guard let centerPoint = centerPoint else { return }
        mapView.setCenter(point: centerPoint)
    }


    // MARK: NMapPOIdataOverlayDelegate

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }

}