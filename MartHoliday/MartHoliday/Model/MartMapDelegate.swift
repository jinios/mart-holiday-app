//
//  MartMapDelegate.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 30..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MartMapDelegate: NSObject, NMapViewDelegate, NMapPOIdataOverlayDelegate, AddressCopiable {

    static let superViewTag = "superViewTag"

    var addressToShow: String?
    var centerPoint: NGeoPoint?
    var mapView: NMapView?
    var noMapView: UIView?

    var geoPoint: NGeoPoint?

    init(geoPoint: NGeoPoint) {
        self.geoPoint = geoPoint
    }

    func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMapView))
        if (error == nil) {
            DispatchQueue.main.async {
                self.mapView = mapView
                if let geo = self.geoPoint {
                    self.centerPoint = geo
                    mapView.showMarker(at: geo)
                    mapView.setMapCenter(geo, atLevel:12)
                    mapView.setMapEnlarged(true, mapHD: true)
                    mapView.mapViewMode = .vector
                    mapView.addGestureRecognizer(tapGesture)
                } else {
                    let errorView = NoMapView(frame: mapView.bounds)
                    errorView.delegate = self
                    self.noMapView = errorView
                    mapView.addSubview(self.noMapView!)
                    mapView.removeGestureRecognizer(tapGesture)
                }
            }
        } else { // fail
            print(error.code)
            print(error)
            print(error.debugDescription)
            let errorView = NoMapView(frame: mapView.bounds)
            errorView.delegate = self
            self.noMapView = errorView
            mapView.addSubview(self.noMapView!)
            mapView.removeGestureRecognizer(tapGesture)
        }
    }

    @objc func tapMapView() {
        NotificationCenter.default.post(name: .mapViewTapped, object: nil, userInfo: [MartMapDelegate.superViewTag: mapView?.superview?.tag ?? -1])
    }

    func setMapCenter() {
        guard let mapView = mapView else { return }
        guard let centerPoint = centerPoint else { return }
        mapView.setMapCenter(centerPoint, atLevel:12)
    }

    func copyAddress() {
        UIPasteboard.general.string = addressToShow
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
