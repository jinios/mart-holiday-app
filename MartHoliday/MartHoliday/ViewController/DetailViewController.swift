//
//  DetailViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, SFSafariViewControllerDelegate, NMapViewDelegate, NMapPOIdataOverlayDelegate {

    @IBOutlet weak var mockUpMapview: UIView!
    @IBOutlet weak var martTitle: UILabel!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var starIcon: UIButton!
    @IBOutlet weak var holidaysCollectionView: UICollectionView!

    var branchData: Branch? {
        didSet {
            guard let branch = branchData else { return }
            holidaysManager = HolidaysCollectionViewManager(dates: branch.holidays)
        }
    }
    var mapView : NMapView?
    var holidaysManager: HolidaysCollectionViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setTitle()
        setAddress()
        setPhoneNumber()
        setStarIcon()
        setMapView()
        setHolidays()
    }

    private func setHolidays() {
        holidaysCollectionView.contentInset = UIEdgeInsets(top: 7, left: 5, bottom: 7, right: 5)
        holidaysCollectionView.scrollIndicatorInsets = holidaysCollectionView.contentInset
        holidaysCollectionView.delegate = holidaysManager
        holidaysCollectionView.dataSource = holidaysManager
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setNavigationItem() {
        guard let branchData = self.branchData else { return }
        self.navigationItem.title = branchData.branchName
    }

    private func setTitle() {
        guard let branchData = self.branchData else { return }
        self.martTitle.text = branchData.branchName
    }

    private func setPhoneNumber() {
        guard let branchData = self.branchData else { return }
        self.phoneNumberLabel.text = branchData.phoneNumber
    }

    private func setAddress() {
        guard let branchData = self.branchData else { return }
        address.text = branchData.address
    }

    @IBAction func goToWebPage(_ sender: Any) {
        guard let branchData = self.branchData else { return }
        guard let url = URL(string: branchData.url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        self.present(safariViewController, animated: true, completion: nil)
    }

    @IBAction func phoneCallTapped(_ sender: Any) {
        guard let branchData = self.branchData else { return }
        let phoneNumber = branchData.phoneNumber.filter { $0 != Character(" ") && $0 != Character("-") }
        if let phoneNumberURL = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(phoneNumberURL, options: [:]) { (success) in
                if success {
                    print("call")
                } else  {
                    print("fail")
                }

            }
        }
    }

    @IBAction func favoriteTapped(_ sender: Any) {
        guard let branchData = self.branchData else { return }
        guard branchData.toggleFavorite() else { return }
        starIcon.toggleSelectedState()
    }

    private func setStarIcon() {
        guard let branchData = self.branchData else { return }
        starIcon.isSelected = branchData.favorite
        starIcon.setStarIconImage()
    }

    private func setMapView() {
        mapView = NMapView()
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self

            // set the application api key for Open MapViewer Library
            guard let keyInfo = MapSetter.loadNMapKeySet() else { return }
            guard let id = keyInfo.id as? String else { return }
            mapView.setClientId(id)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            mockUpMapview.addSubview(mapView)
            mapView.frame = mockUpMapview.bounds
        }
    }

    private func setMapCenter(point: GeoPoint) {
        let x = point.x
        let y = point.y
        mapView!.setMapCenter(NGeoPoint(longitude:x, latitude:y), atLevel:12)
    }


    // MARK: NMapViewDelegate

    public func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            guard let branchData = self.branchData else { return }
            MapSetter.tryGeoRequestTask(address: branchData.address) { geo in
                DispatchQueue.main.async {
                    self.setMapCenter(point: geo)
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

