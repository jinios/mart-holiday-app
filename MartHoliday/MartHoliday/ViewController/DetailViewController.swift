//
//  DetailViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, SFSafariViewControllerDelegate, MartMapViewHolder {

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mockUpMapview: UIView!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starCircleButton: StarCircleButton!
    var starButton: StarButton!
    var mapView : NMapView?
    var mapViewDelegate: MartMapDelegate!

    var branchData: Branch? {
        didSet {
            guard let branchData = branchData else { return }
            holidayDatum = FavoriteBranch(branch: branchData)
        }
    }
    var holidayDatum: ExpandCollapseTogglable?
    let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewDelegate = MartMapDelegate(address: branchData!.address)
        setNavigationItem()
        setAddress()
        setBusinessHour()
        setPhoneNumber()
        setMapView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DetailHeaderView", bundle: nil),forHeaderFooterViewReuseIdentifier: "detailHeader")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        mapView?.viewWillAppear()
        mapViewDelegate.setMapCenter()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView?.viewDidDisappear()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
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
        self.navigationController?.navigationBar.largeTitleTextAttributes = makeTextWithAttributes(fontSize: 24)

        starButton = StarBarButton()
        setStarButton()
        starButton.addTarget(self, action: #selector(starBarButtonTapped), for: .touchUpInside)
        starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let starBarButton = UIBarButtonItem(customView: starButton)

        let homeButton = UIButton(type: .custom)
        homeButton.setImage(UIImage(named: "home-nav-button"), for: .normal)
        homeButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        homeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        let homeBarButton = UIBarButtonItem(customView: homeButton)
        self.navigationItem.setRightBarButtonItems([homeBarButton,starBarButton], animated: false)

    }

    private func makeTextWithAttributes(fontSize: CGFloat) -> [NSAttributedStringKey : NSObject?] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let customAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundOTF", size: fontSize)?.bold(),
                                NSAttributedStringKey.foregroundColor: UIColor.white,
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
            mapView.delegate = mapViewDelegate

            // set the application api key for Open MapViewer Library
            guard let keyInfo = MapSetter.loadNMapKeySet() else { return }
            guard let id = keyInfo.id as? String else { return }
            mapView.setClientId(id)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mockUpMapview.addSubview(mapView)
            mapView.frame = mockUpMapview.bounds
//            mapView.setMapGesture(enable: false)
//            mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMapView)))
            NotificationCenter.default.addObserver(self, selector: #selector(tapMapView), name: .mapViewTapped, object: nil)
        }
    }

    @objc func tapMapView() {
        let nextVC = MapViewController()
        guard let branchData = self.branchData else { return }
        nextVC.addressToShow = branchData.address
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

extension DetailViewController: FavoriteTogglable {

    func toggleState() {
        guard let branchData = self.branchData else { return }
        guard branchData.toggleFavorite() else { return }
        starButton.toggleState()
        starCircleButton.toggleState()
        hapticGenerator.impactOccurred()
    }

    func setStarButton() {
        guard let branchData = self.branchData else { return }
        starButton.isSelected = branchData.favorite
        starCircleButton.isSelected = branchData.favorite
        starButton.setImage()
        starCircleButton.setImage()
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource, HeaderDelegate {

    func selectHeader(index: Int) {
        holidayDatum?.toggleExpand()
        tableView.reloadSections([index], with: .automatic)
        tableViewHeight.constant = tableView.contentSize.height
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! HolidayTableViewCell
        guard let holidayDatum = holidayDatum else { return UITableViewCell() }
        cell.setData(holiday: holidayDatum.allHolidays()[indexPath.row + 1])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let holidayDatum = holidayDatum else { return 0 }
        if holidayDatum.isExpanded {
            return holidayDatum.allHolidays().count - 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let holidayDatum = holidayDatum else { return nil }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "detailHeader") as? HolidayHeaderView else { return nil }
        view.delegate = self
        view.set(holiday: holidayDatum.firstHoliday())
        view.setExpand(state: holidayDatum.isExpanded)

        return view
    }

}

