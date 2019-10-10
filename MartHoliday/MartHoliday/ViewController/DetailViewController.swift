//
//  DetailViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit
import SafariServices
import NMapsMap

class DetailViewController: RechabilityDetectViewController, SFSafariViewControllerDelegate {

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var businessHour: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starCircleButton: StarCircleButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var starButton: StarButton!
    private var viewTag = 100
    var martMapView: MartMapView?

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
        setNavigationItem()
        setAddress()
        setBusinessHour()
        setPhoneNumber()
        setMapView()
        setNetworkConnectionObserver()
        setScroll()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "DetailHeaderView", bundle: nil),forHeaderFooterViewReuseIdentifier: "detailHeader")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        // 브랜치이름 Title 설정
        guard let branchData = self.branchData else { return }
        self.navigationItem.title = branchData.branchName

        let naviBar = self.navigationController?.navigationBar

        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.appColor(color: .mint)

            appearance.largeTitleTextAttributes = [.font: UIFont(name: "NanumSquareRoundOTF", size: 24)?.bold() ?? UIFont(),
            .foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [.font: UIFont(name: "NanumSquareRoundOTF", size: UIFont.labelFontSize)?.bold() ?? UIFont(),
            .foregroundColor: UIColor.white]
            appearance.buttonAppearance.normal.titleTextAttributes = [.font: UIFont(name: "NanumSquareRoundOTF", size: UIFont.labelFontSize)?.bold() ?? UIFont(),
            .foregroundColor: UIColor.white]
            naviBar?.standardAppearance = appearance
            naviBar?.scrollEdgeAppearance = appearance

        } else {
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.prefersLargeTitles = true

            self.navigationController?.navigationBar.largeTitleTextAttributes = makeTextWithAttributes(fontSize: 24) as [NSAttributedString.Key : Any]
        }

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

    private func makeTextWithAttributes(fontSize: CGFloat) -> [NSAttributedString.Key : NSObject?] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let customAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                NSAttributedString.Key.font: UIFont(name: "NanumSquareRoundOTF", size: fontSize)?.bold(),
                                NSAttributedString.Key.foregroundColor: UIColor.white,
                                ]
        return customAttributes
    }

    private func setScroll() {
        guard let holidayDatum = holidayDatum else { return }
        let isMaxHeight = UIScreen.main.bounds.height > 820
        if isMaxHeight { // if true
            if holidayDatum.isExpanded {
                scrollView.isScrollEnabled = isMaxHeight // true
            } else {
                scrollView.isScrollEnabled = !isMaxHeight // false
            }
        }
    }

    private func setMapView() {
        let centerPoint = GeoPoint(lat: branchData?.latitude ?? 0, lng: branchData?.longitude ?? 0)

        self.martMapView = MartMapView(frame: self.mapView.bounds, center: centerPoint)
        guard let martMapView = self.martMapView else { return }

        martMapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(martMapView)

        martMapView.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor).isActive = true
        martMapView.topAnchor.constraint(equalTo: self.mapView.topAnchor).isActive = true
        martMapView.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor).isActive = true
        martMapView.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor).isActive = true

        martMapView.addDefaultMarker()
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
    }

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource, HeaderDelegate {

    func selectHeader(index: Int) {
        holidayDatum?.toggleExpand()
        tableView.reloadSections([index], with: .automatic)
        tableViewHeight.constant = tableView.contentSize.height
        setScroll()
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

