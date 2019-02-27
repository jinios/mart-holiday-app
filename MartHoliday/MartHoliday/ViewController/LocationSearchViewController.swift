//
//  LocationSearchViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 20/01/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController, NMapPOIdataOverlayDelegate, NMapViewDelegate, NMapLocationManagerDelegate {

    var mapView: NMapView?
    var userLocation: NGeoPoint?
    var locationTrackingStateButton: UIButton?
    var locationManager: NMapLocationManager?
    var POIdata: POIData? {
        didSet {
            self.showMarkers()
        }
    }

    enum state {
        case disabled
        case tracking
    }

    var currentState: state = .disabled

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()

        // 위치서비스 허용했는지 검사 추가 / 안했으면 setting으로 넘김
        guard let locationManager = NMapLocationManager.getSharedInstance() else { return }
        self.locationManager = locationManager

        mapView = NMapView(frame: CGRect(x: 0, y: 45, width: self.view.frame.width, height: self.view.frame.height-45))

        mapView?.delegate

        if let mapView = mapView {

            // set the delegate for map view
            mapView.delegate = self

            // set the application api key for Open MapViewer Library
            guard let keyInfo = MapSetter.loadNMapKeySet() else { return }
            guard let id = keyInfo.id as? String else { return }
            mapView.setClientId(id)

            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            currentState = .tracking
            locationTrackingStateButton = setLocationTrackingButton()
            enableLocationUpdate()

            view.addSubview(mapView)
            if let button = locationTrackingStateButton {
                self.view.addSubview(button)

            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
        mapView?.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView?.viewDidAppear()
        // showMarkers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
        disableLocationUpdate()
    }

    // MARK: - NMapViewDelegate Methods

    open func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }

    func fetchNearMarts() {
//        DistanceSearch.fetch(geoPoint: userLocation!, distance: 3, handler: { self.setPOIdata(with:) })
        DistanceSearch.fetch(geoPoint: userLocation!, distance: 3)
                            { raw in self.setPOIdata(raw) }
    }

    func setPOIdata(_ rawData: [TempBranchRaw]) {
        self.POIdata = POIData(for: rawData)
    }

    func showMarkers() {
        if let mapOverlayManager = mapView?.mapOverlayManager {

            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {

                poiDataOverlay.initPOIdata(3)

                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.979, latitude: 37.567), title: "마커 1", type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)

                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.974, latitude: 37.566), title: "마커 2", type: UserPOIflagTypeDefault, iconIndex: 1, with: nil)

                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.984, latitude: 37.565), title: "마커 3", type: UserPOIflagTypeInvisible, iconIndex: 2, with: nil)

                poiDataOverlay.endPOIdata()

                // show all POI data
                poiDataOverlay.showAllPOIdata()

                poiDataOverlay.selectPOIitem(at: 2, moveToCenter: false, focusedBySelectItem: true)
            }
        }
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.appColor(color: .mint)
        navigationController?.navigationBar.isTranslucent = false
        // To remove 1px line of under the navigationBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "내 주변 마트 검색"
    }

    private func setLocationTrackingButton() -> UIButton {
        let button = UIButton(type: .custom)

        button.frame = CGRect(x: 15, y: 80, width: 36, height: 36)

        switch currentState {
        case .disabled:
            button.setImage(UIImage(named: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            button.setImage(UIImage(named: "v4_btn_navi_location_selected"), for: .normal)
        }

        button.addTarget(self, action: #selector(locationTrackingButtonTapped(_:)), for: .touchUpInside)

        return button
    }

    @objc func locationTrackingButtonTapped(_ sender: UIButton!) {

        switch currentState {
        case .disabled:
            enableLocationUpdate()
            updateState(.tracking)
        case .tracking:
            disableLocationUpdate()
            updateState(.disabled)
        }
    }

    func updateState(_ newState: state) {

        currentState = newState

        switch currentState {
        case .disabled:
            locationTrackingStateButton?.setImage(UIImage(named: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            locationTrackingStateButton?.setImage(UIImage(named: "v4_btn_navi_location_selected"), for: .normal)
        }
    }

    // MARK: - NMapLocationManagerDelegate

    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        let coordinate = location.coordinate

        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = Float(location.horizontalAccuracy)
        self.userLocation = myLocation

        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        mapView?.setMapCenter(myLocation)
    }


    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {

        var message: String = ""

        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }

        if (!message.isEmpty) {
            let alert = UIAlertController(title:"위치 정보 필요", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                if let systemSettingUrl = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(systemSettingUrl) {
                        UIApplication.shared.open(systemSettingUrl, options: [:], completionHandler: nil)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title:"취소", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }

    // MARK: - Tracking user location

    func enableLocationUpdate() {

        if let lm = NMapLocationManager.getSharedInstance() {

            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }

            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo() // 여기서 앱 위치 허용 물어봄...
            }
        }
    }

    func disableLocationUpdate() {

        if let lm = NMapLocationManager.getSharedInstance() {

            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }

        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }

    // MARK: - NMapPOIdataOverlayDelegate Methods

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected)
    }

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint.zero
    }

    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }

}


// To mark as a poi flag on a map
class POIData {

    var values: [POIDatum]

    init(_ values: [TempBranchRaw]) {
        self.values = values.map { POIDatum(rawData: $0) }
    }

    init(for values: [TempBranchRaw]) {
        var data = [POIDatum]()
        for i in 0..<values.count {
            data.append(POIDatum(rawData: values[i], index: i))
        }
        self.values = data
    }



}

class POIDatum {
//    poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: 126.984, latitude: 37.565), title: "마커 3", type: UserPOIflagTypeDefault, iconIndex: 2, with: nil)

    var title: String
    var longitude: Double
    var latitude: Double
    var id: Int
    var POIindex: Int?

    init(title: String, longitude: Double, latitude: Double, id: Int) {
        self.title = title
        self.longitude = longitude
        self.latitude = latitude
        self.id = id
    }

    init(rawData: TempBranchRaw) {
        self.title = "\(rawData.martType ?? "") \(rawData.branchName ?? "")"
        self.longitude = rawData.longitude ?? 0
        self.latitude = rawData.latitude ?? 0
        self.id = rawData.id ?? 0
    }

    init(rawData: TempBranchRaw, index: Int) {
        self.title = "\(rawData.martType ?? "") \(rawData.branchName ?? "")"
        self.longitude = rawData.longitude ?? 0
        self.latitude = rawData.latitude ?? 0
        self.id = rawData.id ?? 0
        self.POIindex = index
    }
}
