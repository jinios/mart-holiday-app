//
//  MainViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 16..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var favoritesCollectionView: UICollectionView!

    static let cellID = "cellID"
    static let favoriteCellID = "favoriteCell"

    let slideMenuManager = SlideMenuManager()
    var backgroundView: SlideBackgroundView!
    var slidetopView: SlideTopView!
    var slideMenu: SlideMenu!
    var openFlag: Bool?

    let favoritesCollectionViewTag = 100

    // MARK: override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setSlideBarNavigationButton()
        addSubViews()

        slideMenu.delegate = slideMenuManager
        slideMenu.dataSource = slideMenuManager

        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.tag = favoritesCollectionViewTag

        openFlag = false

        addGestures()
        NotificationCenter.default.addObserver(self, selector: #selector(detectSelectedMenu(_:)), name: .slideMenuTapped, object: nil)

    }

    override func viewWillLayoutSubviews() {

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

        self.backgroundView.frame = self.view.frame
        self.slidetopView.frame = CGRect(x: -(slideWidth), y: topSafeArea, width: slideWidth, height: slideHeight/7)
        self.slideMenu.frame = CGRect(x: -(slideWidth), y: slidetopView.frame.maxY, width: slideWidth, height: (slideHeight*6)/7)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: private functions

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

    private func setSlideBarNavigationButton() {
        let searchImage = UIImage(named: "slidebar")
        let searhButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(toggleSlideMenu))
        navigationItem.leftBarButtonItem = searhButton
    }

    @objc private func handleDismiss() {
        guard let openFlag = self.openFlag else { return }
        if openFlag == true {
            UIView.animate(
                withDuration: 0.5, delay: 0, options: .curveEaseOut,
                animations: {
                    self.backgroundView.dismiss()
                    self.slidetopView.dismiss()
                    self.slideMenu.dismiss()
            }) { complete in
                if complete {
                    self.openFlag! = false
                } else {
                    return
                }
            }
        }
    }

    @objc private func handleOpen() {
        guard let openFlag = self.openFlag else { return }
        if openFlag == false {
            backgroundView.show()
            slidetopView.show()
            slideMenu.show()
            self.openFlag = true
        }
    }

    // MARK: selector functions

    @objc func toggleSlideMenu() {
        // open or dismiss
        if self.openFlag == true {
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

// MARK: CollectionView related

extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoriteList.shared().martList().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let martList = FavoriteList.shared().martList()
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: MainViewController.favoriteCellID, for: indexPath) as! FavoriteCell
//        let holidaysManager = HolidaysCollecionViewManager(dateData: martList[indexPath.row].holidays)
        //        cell.setData(branch: martList[indexPath.row], holidaysManager: holidaysManager)
        cell.setData(branch: martList[indexPath.row])
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.clipsToBounds = true

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let martList = FavoriteList.shared().martList()
        print(martList[indexPath.row].branchName)

    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 140)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10

    }
}
