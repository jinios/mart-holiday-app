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

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var detailContentView: UIView!

    @IBOutlet weak var mockUpMapview: UIView!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var starButton: StarButton!
    var isExpanded = false
    var branchData: Branch?
    var mapView : NMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setAddress()
        setBusinessHour()
        setPhoneNumber()
        setStarButton()
        setMapView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        mapView?.viewWillAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView?.viewDidDisappear()
    }

    var navBarDefalutColor: UIColor?

    override func viewDidLayoutSubviews() {
        tableViewHeight.constant = tableView.contentSize.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setNavigationItem() {
        self.navigationController?.navigationBar.isTranslucent = false

        // 브랜치이름 Title 설정
        guard let branchData = self.branchData else { return }

        self.navigationItem.title = branchData.branchName
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = makeTextWithAttributes(fontSize: 30)

        starButton = StarBarButton()
        starButton.setImage()
        starButton.addTarget(self, action: #selector(starBarButtonTapped), for: .touchUpInside)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let starBarButton = UIBarButtonItem(customView: starButton)

        let homeButton = UIButton(type: .custom)
        homeButton.setImage(UIImage(named: "home-nav-button"), for: .normal)
        homeButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        homeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        let homeBarButton = UIBarButtonItem(customView: homeButton)
        homeBarButton.tintColor = UIColor(named: AppColor.lightgray.description)
        self.navigationItem.setRightBarButtonItems([homeBarButton,starBarButton], animated: false)

    }

    private func makeTextWithAttributes(fontSize: CGFloat) -> [NSAttributedStringKey : NSObject?] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let customAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundOTF", size: fontSize)?.bold(),
                                NSAttributedStringKey.foregroundColor: UIColor(named: AppColor.lightgray.description),
                                ]
        return customAttributes
    }


    private func setPhoneNumber() {
        guard let branchData = self.branchData else { return }
        self.phoneNumberLabel.text = branchData.phoneNumber
    }

    private func setAddress() {
        guard let branchData = self.branchData else { return }
        address.text = branchData.address
    }

    private func setBusinessHour() {
        guard let branchData = self.branchData else { return }
        businessHour.text = branchData.openingHours
    }

    @objc func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
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
        toggleState()
    }

    @objc func starBarButtonTapped() {
        toggleState()
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
            mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMapView)))
        }
    }

    @objc func tapMapView() {
        let nextVC = MapViewController()
        guard let branchData = self.branchData else { return }
        nextVC.addressToShow = branchData.address
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    private func setMapCenter(point: GeoPoint) {
        let x = point.x
        let y = point.y
        mapView!.setMapCenter(NGeoPoint(longitude:x, latitude:y), atLevel:12)
    }

    private func showMapMarker(point: GeoPoint) {
        let x = point.x
        let y = point.y

        if let mapOverlayManager = mapView?.mapOverlayManager {

            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {

                poiDataOverlay.initPOIdata(1)

                poiDataOverlay.addPOIitem(atLocation: NGeoPoint(longitude: x, latitude: y), title: branchData!.branchName, type: UserPOIflagTypeDefault, iconIndex: 0, with: nil)

                poiDataOverlay.endPOIdata()
                poiDataOverlay.showAllPOIdata()
            }
        }
    }

    // MARK: NMapViewDelegate

    public func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            guard let branchData = self.branchData else { return }
            MapSetter.tryGeoRequestTask(address: branchData.address) { geo in
                DispatchQueue.main.async {
                    self.showMapMarker(point: geo)
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

extension DetailViewController: FavoriteTogglable {

    func toggleState() {
        guard let branchData = self.branchData else { return }
        guard branchData.toggleFavorite() else { return }
        starButton.toggleState()
    }

    func setStarButton() {
        guard let branchData = self.branchData else { return }
        starButton.isSelected = branchData.favorite
        starButton.setImage()
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource, HeaderDelegate {

    func toggleHeader() {
        self.isExpanded = !isExpanded
        tableView.reloadSections([0], with: .automatic)
        tableViewHeight.constant = tableView.contentSize.height
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! HolidayTableViewCell
        guard let branchData = branchData else { return UITableViewCell() }
        cell.setData(holiday:branchData.holidays[indexPath.row+1])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let branchData = branchData else { return 0 }
        if isExpanded {
            return branchData.holidays.count - 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let branchData = branchData else { return UIView() }
        let view = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HolidayHeaderCell
        view.delegate = self
        view.set(holiday: branchData.holidays.isEmpty ? nil:branchData.holidays[0])
        let contentView = view.contentView
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader)))
        return contentView
    }

    @objc func tapHeader() {
        toggleHeader()
    }

}

