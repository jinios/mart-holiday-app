//
//  MartMapView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 21..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MartMapDelegate: NSObject, NMapViewDelegate, NMapPOIdataOverlayDelegate {

    var addressToShow: String

    init(address: String) {
        self.addressToShow = address
    }

    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) {
            MapSetter.tryGeoRequestTask(address: addressToShow) { geo in
                DispatchQueue.main.async {
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


extension NMapView {

    convenience init(customFrame: CGRect) {
        self.init(frame: customFrame)
        guard let keyInfo = MapSetter.loadNMapKeySet() else { return }
        guard let id = keyInfo.id as? String else { return }
        self.setClientId(id)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    func setMapGesture(enable: Bool) {
        self.setPanEnabled(enable)
        self.setZoomEnabled(enable)
        self.isMultipleTouchEnabled = enable
    }

    func setDelegate(_ customDelegate: NMapPOIdataOverlayDelegate & NMapViewDelegate) {
        self.delegate = customDelegate
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


