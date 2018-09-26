//
//  MainViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 16..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

protocol FavoriteConvertible {
    var favoriteList: BranchList { get set }
    func fetchFavoriteBranch(handler: @escaping(()->Void))
}

protocol FooterDelegate {
    var favoriteData: [ExpandCollapseTogglable] { get set }
    func toggleFooter(index: Int)
}

class MainViewController: UIViewController, FavoriteConvertible, FooterDelegate {

    @IBOutlet weak var tableView: UITableView!
    let slideMenuManager = SlideMenuManager()
    var backgroundView: SlideBackgroundView!
    var slidetopView: SlideTopView!
    var slideMenu: SlideMenu!
    var slideOpenFlag: Bool?
    var favoriteList = BranchList()
    var favoriteData = [ExpandCollapseTogglable]()

    // MARK: override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setSlideBarNavigationButton()

        addSubViews()
        slideMenu.delegate = slideMenuManager
        slideMenu.dataSource = slideMenuManager
        slideOpenFlag = false

        addGestures()
        NotificationCenter.default.addObserver(self, selector: #selector(detectSelectedMenu(_:)), name: .slideMenuTapped, object: nil)

        self.view.backgroundColor = UIColor(named: AppColor.lightgray.description)
    }

    private func setNoDataView() {
        let noDataView = UIView(frame: self.view.frame)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: noDataView.frame.width, height: 50))
        label.text = "즐겨찾는 마트를 추가해주세요!"
        label.adjustsFontSizeToFitWidth = true
        noDataView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: noDataView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: noDataView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: noDataView.widthAnchor, constant: 0.9).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.view.addSubview(noDataView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "마트휴무알리미"
        setTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var topSafeArea: CGFloat
        var bottomSafeArea: CGFloat

        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }

        let slideWidth = self.view.frame.width/2
        let slideHeight = (self.view.frame.height - topSafeArea - bottomSafeArea)

        self.slidetopView.frame = CGRect(x: -(slideWidth), y: topSafeArea, width: slideWidth, height: slideHeight/7)
        self.slideMenu.frame = CGRect(x: -(slideWidth), y: slidetopView.frame.maxY, width: slideWidth, height: (slideHeight*6)/7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setSlideBarNavigationButton() {
        let searchImage = UIImage(named: "slidebar")
        let searhButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(toggleSlideMenu))
        navigationItem.leftBarButtonItem = searhButton
    }

    private func setTableView() {
        if FavoriteList.shared().isEmpty() {
            setNoDataView()
        } else {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 44.0
            tableView.backgroundColor = UIColor(named: AppColor.lightgray.description)
            tableView.register(UINib(nibName: "MainHeaderView", bundle: nil),forHeaderFooterViewReuseIdentifier: "mainHeader")
            loadFavoritesTableView()
        }
    }

    func toggleFooter(index: Int) {
        print("푸터 인덱스 번호: \(index)")
        favoriteData[index].toggleExpand()
        tableView.reloadSections([index], with: .automatic)
    }

    private func loadFavoritesTableView() {
        fetchFavoriteBranch {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func fetchFavoriteBranch(handler: @escaping (() -> Void)) {
        let ids = FavoriteList.shared().ids()
        let idstr = ids.map{String($0)}.joined(separator: ",")
        guard let baseURL = URL(string: "http://ec2-13-209-38-224.ap-northeast-2.compute.amazonaws.com/api/mart/branch") else { return }
        let url = baseURL.appendingPathComponent(idstr)

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                var branches = [BranchRawData]()
                var mainFavorites = [FavoriteBranch]()
                do {
                    branches = try JSONDecoder().decode([BranchRawData].self, from: data)
                    self.favoriteList = BranchList(branches: branches)

                    for fav in self.favoriteList.branches {
                        mainFavorites.append(FavoriteBranch(branch: fav))
                        self.favoriteData = mainFavorites
                    }
                    handler()
                } catch let error {
                    print("Cannot make Data: \(error)")
                }
            } else {
                print("Network error: \((response as? HTTPURLResponse)?.statusCode)")
            }
        }.resume()
    }

}

    // MARK: TableView Related

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let branch = favoriteData[section] as? FavoriteBranch else { return 1 }
        let countOfHoliday = branch.allHolidays().count
        guard countOfHoliday != 0 else { return 1 }
        if favoriteData[section].isExpanded {
            return countOfHoliday
        } else {
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return favoriteData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as! MainTableViewCell
        if favoriteData.count == 0 {
            return UITableViewCell()
        } else {
            guard let branch = favoriteData[indexPath.section] as? FavoriteBranch else { return UITableViewCell() }
            cell.setData(text: branch.allHolidays()[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mainHeader") as? MainTableViewHeader else { return nil }
        guard let branch = favoriteData[section] as? FavoriteBranch else { return nil }
        headerView.name = branch.branchName()
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = MainTableViewFooter(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.delegate = self
        view.sectionindex = section
        let state = favoriteData[section].isExpanded
        view.setExpand(state: state)
        return view
    }

}

    // MARK: SlideMenu Related

extension MainViewController {

    private func addGestures() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSlideMenu)))
        let swipeToRight = UISwipeGestureRecognizer(target: self, action: #selector(handleOpen))
        swipeToRight.direction = .right
        view.addGestureRecognizer(swipeToRight)
        let swipeToLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
        swipeToLeft.direction = .left
        view.addGestureRecognizer(swipeToLeft)
    }

    private func addSubViews() {
        backgroundView = SlideBackgroundView()
        view.addSubview(backgroundView)

        slidetopView = SlideTopView()
        view.addSubview(slidetopView)

        slideMenu = SlideMenu(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(slideMenu)
    }

    @objc private func handleDismiss() {
        guard let openFlag = self.slideOpenFlag else { return }
        if openFlag == true {
            UIView.animate(
                withDuration: 0.5, delay: 0, options: .curveEaseOut,
                animations: {
                    self.backgroundView.dismiss()
                    self.slidetopView.dismiss()
                    self.slideMenu.dismiss()
            }) { complete in
                if complete {
                    self.slideOpenFlag! = false
                } else {
                    return
                }
            }
        }
    }

    @objc private func handleOpen() {
        guard let openFlag = self.slideOpenFlag else { return }
        if openFlag == false {
            backgroundView.show()
            slidetopView.show()
            slideMenu.show()
            self.slideOpenFlag = true
        }
    }

    // MARK: selector functions

    @objc func toggleSlideMenu() {
        // open or dismiss
        if self.slideOpenFlag == true {
            handleDismiss()
        } else {
            handleOpen()
        }
    }

    @objc func detectSelectedMenu(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let destination = userInfo["next"] as? SelectedSlideMenu else {return}
        switch destination {
        case .main:
            handleDismiss()
        case .select:
            handleDismiss()
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "martSelectVC") as? MartSelectViewController else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

}
