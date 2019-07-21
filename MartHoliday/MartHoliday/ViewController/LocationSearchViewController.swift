//
//  LocationSearchViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 20/01/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit
import NMapsMap

enum State {
    case disabled
    case tracking
}

enum SearchDistance: Int {
    case near = 2
    case middle = 5
    case far = 7
}


class LocationSearchViewController: IndicatorViewController, NMFMapViewDelegate {

    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var searchAgainButton: UIButton!
    @IBOutlet weak var distanceSlider: UISlider!

    var userLocation: NMGLatLng? {
        didSet {
            guard let userLocation = self.userLocation else { return }
            let isValid = (self.previousUserLocation?.compareDifference(compare: self.locationOverlay!.location, value: 0.0005) ?? true) && userLocation.isNationalValid()
            if isValid {
                self.fetchNearMarts(from: userLocation)
            }
        }
    }

    var previousUserLocation: NMGLatLng?

    var searchDistance: SearchDistance?

    var locationOverlay: NMFLocationOverlay?

    var currentState: State = .disabled

    var infoWindow = NMFInfoWindow()

    var markerInfoWindowDataSource = MarkerInfoWindowDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchAgainButton.alpha = 0
        self.userLocation = self.locationOverlay?.location
        naverMapView.delegate = self
        self.settingDistance = 3

        naverMapView.addObserver(self, forKeyPath: "positionMode", options: [.new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorAlert), name: .apiErrorAlertPopup, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeTrackingStatus), name: .completeFetchNearMart, object: nil)

        naverMapView.positionMode = .direction
        naverMapView.mapView.logoAlign = .rightTop

        startIndicator()

        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + .seconds(2)

        mainQueue.asyncAfter(deadline: deadline) {

            let lng = self.locationOverlay?.location.lng ?? 0
            let lat = self.locationOverlay?.location.lat ?? 0

            self.userLocation = NMGLatLng(lat: lat, lng: lng)
            self.previousUserLocation = self.userLocation // 맨 처음엔 같게 지정

            self.finishIndicator()
        }

    }

    @objc private func showErrorAlert() {
        DispatchQueue.main.async {
            self.presentErrorAlert(type: .DisableNearbyMarts)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func changeTrackingStatus() {
        naverMapView.positionMode = .disabled
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "내 주변 마트 검색"
    }

    var settingDistance: Int? {
        didSet {
            let distanceSettingButton = UIButton(type: .custom)

            let buttonTitle = NSAttributedString(string: "\(self.settingDistance ?? 2)km",
                attributes: [.font: UIFont(name: "NanumSquareRoundOTF", size: 13.5)?.bold(),
                             .foregroundColor: UIColor.white])

            distanceSettingButton.setAttributedTitle(buttonTitle, for: .normal)
            distanceSettingButton.setImage(UIImage(named: "focus"), for: .normal)
            distanceSettingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
            distanceSettingButton.titleEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
            distanceSettingButton.layer.borderColor = UIColor.white.cgColor
            distanceSettingButton.layer.borderWidth = 0.5
            distanceSettingButton.layer.cornerRadius = 8.0
            distanceSettingButton.clipsToBounds = true

            distanceSettingButton.addTarget(self, action: #selector(changeSearchDistance), for: .touchUpInside)
            distanceSettingButton.frame = CGRect(x: 0, y: 0, width: 62, height: 28)

            let homeBarButton = UIBarButtonItem(customView: distanceSettingButton)
            self.navigationItem.setRightBarButtonItems([homeBarButton], animated: false)
        }
    }

    @objc func changeSearchDistance() {

    }

}


extension LocationSearchViewController {

    // 포지션 모드가 변경될때만 호출
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.locationOverlay = naverMapView.mapView.locationOverlay

        if keyPath == "positionMode" {
            self.userLocation = self.locationOverlay!.location
        }
    }

    @IBAction func distanceSegmentedControlChanged(_ sender: UISegmentedControl) {
        guard let userLocation = self.userLocation else { return }
        switch sender.selectedSegmentIndex {
            case 0: self.searchDistance = .near
            case 1: self.searchDistance = .middle
            case 2: self.searchDistance = .far
            default: break
        }
        self.fetchNearMarts(from: userLocation)
        self.naverMapView.positionMode = .normal
    }


    func fetchNearMarts(from geoPoint: NMGLatLng) {
        let distance = self.searchDistance ?? .near
        DistanceSearch.fetch(geoPoint: geoPoint,
                             distance: distance) { (branchRawData) in
                                DispatchQueue.main.async {
                                    let branches = BranchList(branches: branchRawData)
                                    self.showMarkers(of: branches)
                                    NotificationCenter.default.post(name: .completeFetchNearMart, object: nil, userInfo: nil)
            }
        }
    }

    private func showMarkers(of branches: BranchList) {
        let cameraUpdate = NMFCameraUpdate(zoomTo: REDUCTION_MAP_ZOOM_MIN)
        cameraUpdate.animation = .easeOut
        naverMapView.mapView.moveCamera(cameraUpdate)

        branches.branches.forEach({ (mart) in
            let marker = NMFMarker()
            marker.iconImage = NMF_MARKER_IMAGE_LIGHTBLUE
            marker.width = 23
            marker.height = 30
            marker.position = NMGLatLng(lat: mart.latitude, lng: mart.longitude)
            marker.userInfo = ["branch": mart]

            marker.touchHandler = { [weak self] (overlay) in
                if let marker = overlay as? NMFMarker {
                    if let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController {
                        nextVC.branchData = marker.userInfo["branch"] as? Branch

                        let markerInfoDataSource = MarkerInfoWindowDataSource()
                        markerInfoDataSource.branch = marker.userInfo["branch"] as? Branch

                        self?.infoWindow.dataSource = markerInfoDataSource

                        self?.infoWindow.open(with: marker, align: .top)
                        self?.infoWindow.touchHandler = { [weak self] (overlay) in
                            self?.infoWindow.close()
                            self?.navigationController?.pushViewController(nextVC, animated: true)
                            return true
                        }
                    }
                }
                return false // didTapMapView
            }
            marker.mapView = self.naverMapView.mapView
        })
    }


    // MARK: - MapView Delegate

    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latlng.lat, lng: latlng.lng))
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = 0.5
        DispatchQueue.main.async {
            self.naverMapView.mapView.moveCamera(cameraUpdate)
        }
    }

    func mapView(_ mapView: NMFMapView, regionDidChangeAnimated animated: Bool, byReason reason: Int) {
        switch reason {
        case NMFMapChangedByGesture, NMFMapChangedByControl:
            showSearchAgainButton(isShow: true)
        default:
            break
        }
    }

    @IBAction func searchAgainButtonTapped(_ sender: Any) {
        showSearchAgainButton(isShow: false)

        let position = naverMapView.mapView.cameraPosition
        let centerGeoPoint = position.target
        self.fetchNearMarts(from: centerGeoPoint)
    }

    private func showSearchAgainButton(isShow: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.searchAgainButton.alpha = isShow ? 1 : 0
        }
    }
}


