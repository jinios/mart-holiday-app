//
//  MapViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 22..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import NMapsMap

public let DEFAULT_MAP_ZOOM: Double = 15.0
public let REDUCTION_MAP_ZOOM_MIN: Double = 12.0
public let REDUCTION_MAP_ZOOM_MAX: Double = 9.0
public let DEFAULT_MAP_MARKER_IMAGE: NMFOverlayImage = NMF_MARKER_IMAGE_LIGHTBLUE

class MapViewController: UIViewController {

    var mapView: MartMapView?
    var centerPoint: GeoPoint? // 0일때 그냥 기본 맵뷰

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ProgramDescription.MartLocation.rawValue
        guard let centerPoint = self.centerPoint else { return }
        self.mapView = MartMapView(frame: self.view.frame, center: centerPoint)
        if let mapView = self.mapView {
            self.view.addSubview(mapView)
            self.mapView?.addDefaultMarker()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

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

    func setTapGesture() {
        let ges = UITapGestureRecognizer(target: self, action: #selector(tapMapView))
        mapView.addGestureRecognizer(ges)
    }

    func setUserGestureEnable(_ allow: Bool) {
        self.mapView.isScrollGestureEnabled = allow
        self.mapView.isZoomGestureEnabled = allow
        self.mapView.isTiltGestureEnabled = allow
        self.mapView.isRotateGestureEnabled = allow
    }

    func setPinchAndPanGesture() {
        let pinchGes = UIPinchGestureRecognizer(target: self, action: #selector(pinchMapView))
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(pinchMapView))
        mapView.addGestureRecognizer(pinchGes)
        mapView.addGestureRecognizer(panGes)
    }

    @objc func pinchMapView() {
        // 토스트 "지도를 탭하면 큰 지도가 표시됩니다"
    }

    @objc func tapMapView() {
        // push to mapvc
    }
}

extension NMGLatLng {
    //NMGLatLng(lat: centerPoint.lat, lng: centerPoint.lng)
    convenience init(geoPoint: GeoPoint) {
        self.init(lat: geoPoint.latitude, lng: geoPoint.longitude)
    }

    func compareDifference(compare: NMGLatLng ,value: Double) -> Bool {
        if self.lat - compare.lat > 0.0005 || self.lng - compare.lng > 0.0005 {
            return true
        } else {
            return false
        }
    }
}

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
