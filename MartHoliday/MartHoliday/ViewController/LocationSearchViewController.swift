//
//  LocationSearchViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 20/01/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import UIKit
import NMapsMap
import Toaster

public let DEFAULT_MAP_ZOOM: Double = 15.0
public let REDUCTION_MAP_ZOOM_MIN: Double = 13.0
public let REDUCTION_MAP_ZOOM_MID: Double = 11.0
public let REDUCTION_MAP_ZOOM_MAX: Double = 10.0
public let DEFAULT_MAP_MARKER_IMAGE: NMFOverlayImage = NMF_MARKER_IMAGE_LIGHTBLUE

enum State {
    case disabled
    case tracking
}

class LocationSearchViewController: IndicatorViewController, NMFMapViewDelegate, TickMarkSliderDelegate {

    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var searchAgainButton: UIButton!

    @IBOutlet weak var distanceSearchView: UIView!
    @IBOutlet weak var sliderView : UIView!
    @IBOutlet weak var sliderViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var distanceLabel: UILabel!

    var userLocation: NMGLatLng? {
        didSet {
            guard let userLocation = self.userLocation else { return }
            let isValid = (self.previousUserLocation?.compareDifference(compare: self.locationOverlay!.location, value: 0.0005) ?? true) && userLocation.isNationalValid()
            if isValid {
                self.fetchNearMarts(from: userLocation)
            }
        }
    }

    var distanceSlider: TickMarkSlider?

    var previousUserLocation: NMGLatLng?

    var locationOverlay: NMFLocationOverlay?

    var currentState: State = .disabled

    var infoWindow = NMFInfoWindow()

    var markerInfoWindowDataSource = MarkerInfoWindowDataSource()

    var isDistanceSearchViewShown = true
    var previousDistance: Int?

    var settingDistance: Int? {
        didSet {
            self.distanceLabel.text = "\(self.settingDistance ?? 2)km"
        }
    }

    var markers = [NMFMarker]()
    let nMapViewObserverKeypath = "positionMode"

    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchAgainButtonBorder()
        self.searchAgainButton.alpha = 0
        self.userLocation = self.locationOverlay?.location
        naverMapView.delegate = self

        naverMapView.addObserver(self, forKeyPath: nMapViewObserverKeypath, options: [.new], context: nil)
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

        distanceSlider = TickMarkSlider(tick: 8, minimumValue: 0, maximumValue: 8, initialValue: 2.0, frame: self.sliderView.bounds)
        distanceSlider!.addTickMarks()
        distanceSlider!.delegate = self
        self.sliderView.addSubview(distanceSlider!)

        self.settingDistance = Int(distanceSlider!.value)
        setNaviBarSearchButtonTitle()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc private func showErrorAlert() {
        DispatchQueue.main.async {
            self.presentErrorAlert(type: .DisableNearbyMarts)
        }
    }

    @objc func changeTrackingStatus() {
        naverMapView.positionMode = .disabled
    }

    @objc func changeSearchDistance() {
        self.showAndHideDistanceView()
        guard !self.isDistanceSearchViewShown else { return }
        fetchNearMarts(from: self.getMapCenter())
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "내 주변 마트 검색"
    }

    private func setSearchAgainButtonBorder() {
        self.searchAgainButton.layer.cornerRadius = searchAgainButton.frame.height/2
        self.searchAgainButton.clipsToBounds = true
    }

    private func getMapCenter() -> NMGLatLng {
        let position = naverMapView.mapView.cameraPosition
        let centerGeoPoint = position.target
        return centerGeoPoint
    }

    private func showAndHideDistanceView() {
        self.isDistanceSearchViewShown = !self.isDistanceSearchViewShown
        setNaviBarSearchButtonTitle()

        self.sliderViewTopConstraint.constant = self.isDistanceSearchViewShown ? 0 : -distanceSearchView.bounds.height

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.distanceSearchView.alpha = self.isDistanceSearchViewShown ? 1 : 0
            self.view.layoutIfNeeded()
            })
    }

    private func setNaviBarSearchButtonTitle() {
        let titleText = isDistanceSearchViewShown ? "검색" : "\(self.settingDistance ?? 2)km"

        let distanceSettingButton = UIButton(type: .custom)
        let buttonTitle = NSAttributedString(string: titleText,
                                             attributes: [.font: UIFont(name: "NanumSquareRoundOTF", size: 13.5)?.bold(),
                                                          .foregroundColor: UIColor.white])

        distanceSettingButton.setAttributedTitle(buttonTitle, for: .normal)
        distanceSettingButton.setImage(UIImage(named: "focus"), for: .normal)
        distanceSettingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        distanceSettingButton.titleEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
        distanceSettingButton.layer.borderColor = UIColor.white.cgColor
        distanceSettingButton.layer.borderWidth = 1.0
        distanceSettingButton.layer.cornerRadius = 13.0
        distanceSettingButton.clipsToBounds = true

        distanceSettingButton.addTarget(self, action: #selector(changeSearchDistance), for: .touchUpInside)
        distanceSettingButton.frame = CGRect(x: 0, y: 0, width: 68, height: 30)

        let homeBarButton = UIBarButtonItem(customView: distanceSettingButton)
        self.navigationItem.setRightBarButtonItems([homeBarButton], animated: false)
    }

}


extension LocationSearchViewController {

    // 포지션 모드가 변경될때만 호출
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.locationOverlay = naverMapView.mapView.locationOverlay

        if keyPath == nMapViewObserverKeypath {
            self.userLocation = self.locationOverlay!.location
        }
    }


    func fetchNearMarts(from geoPoint: NMGLatLng) {
        guard let distance = self.settingDistance else { return }
        DistanceSearch.fetch(geoPoint: geoPoint,
                             distance: distance) { (branchRawData) in
                                self.completeReceiveBranches(branchRawData) }
    }

    private func completeReceiveBranches(_ branches: [BranchRawData]) {
        let hasSettingDistance = !(self.settingDistance == nil)
        let distaceGuideText = hasSettingDistance ? "\(self.settingDistance!)km 반경 내에서" : "요청하신 거리 내에서"

        ToastView.appearance().bottomOffsetPortrait = UIScreen.main.bounds.height / 2

        DispatchQueue.main.async {
            let branches = BranchList(branches: branches)

            if branches.count() == 0 {
                Toast(text: "\(distaceGuideText) 마트가 없습니다.").show()
            } else {
                Toast(text: "\(distaceGuideText) \(branches.count())곳의 마트가 검색되었습니다.").show()
                self.showMarkers(of: branches)
            }

            NotificationCenter.default.post(name: .completeFetchNearMart, object: nil, userInfo: nil)
        }
    }

    private func zoomLevel() -> Double {
        guard let distance = self.settingDistance else { return DEFAULT_MAP_ZOOM }
        switch distance {
        case 0...2: return REDUCTION_MAP_ZOOM_MIN
        case 3...6: return REDUCTION_MAP_ZOOM_MID
        case 7...8: return REDUCTION_MAP_ZOOM_MAX
        default: return DEFAULT_MAP_ZOOM
        }
    }

    private func makeMarkers(of mart: Branch) -> NMFMarker {
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_LIGHTBLUE
        marker.width = 23
        marker.height = 30
        marker.position = NMGLatLng(lat: mart.latitude, lng: mart.longitude)
        marker.userInfo = ["branch": mart]

        return marker
    }

    private func showMarkers(of branches: BranchList) {
        let cameraUpdate = NMFCameraUpdate(zoomTo: self.zoomLevel())
        cameraUpdate.animation = .easeOut
        naverMapView.mapView.moveCamera(cameraUpdate)
        self.markers.forEach { $0.mapView = nil }

        branches.branches.forEach({ (mart) in
            let marker = self.makeMarkers(of: mart)

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
            self.markers.append(marker)
        })
    }

    // MARK: - TickMarkSlider Delegate

    func valueChanged(_ sender: UISlider) {
        self.settingDistance = Int(distanceSlider!.value)
    }

    // MARK: - MapView Delegate

    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latlng.lat, lng: latlng.lng), zoomTo: DEFAULT_MAP_ZOOM)
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


