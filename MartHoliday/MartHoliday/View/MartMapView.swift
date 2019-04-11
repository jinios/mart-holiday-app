//
//  MartMapView.swift
//  MartHoliday
//
//  Created by YOUTH2 on 11/04/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit
import NMapsMap

class MartMapView: UIView {

    var mapView = NMFMapView()

    convenience init(frame: CGRect, center: GeoPoint) {
        self.init(frame: frame)

        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)

        mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        let mapCenter = NMFCameraPosition(NMGLatLng(geoPoint: center), zoom: DEFAULT_MAP_ZOOM)
        DispatchQueue.main.async {
            self.mapView.moveCamera(NMFCameraUpdate(position: mapCenter))
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        self.addSubview(mapView)
        mapView.frame = self.frame
    }

    func addDefaultMarker() {
        DispatchQueue.main.async {
            let marker = NMFMarker(position: self.mapView.cameraPosition.target)
            marker.iconImage = DEFAULT_MAP_MARKER_IMAGE
            marker.mapView = self.mapView
        }
    }

    func setUserGestureEnable(_ allow: Bool) {
        self.mapView.isScrollGestureEnabled = allow
        self.mapView.isZoomGestureEnabled = allow
        self.mapView.isTiltGestureEnabled = allow
        self.mapView.isRotateGestureEnabled = allow
    }

    func setPinchAndPanGesture(_ allow: Bool) {
        let pinchGes = UIPinchGestureRecognizer(target: self, action: #selector(pinchMapView))
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(pinchMapView))
        mapView.addGestureRecognizer(pinchGes)
        mapView.addGestureRecognizer(panGes)
    }

    @objc func pinchMapView() {

    }

    @objc func tapMapView() {

    }
}

