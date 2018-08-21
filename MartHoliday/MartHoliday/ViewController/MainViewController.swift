//
//  MainViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 16..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var firstFavoriteLabel: UILabel!
    @IBOutlet weak var secondFavoriteLabel: UILabel!
    @IBOutlet weak var thirdFavoriteLabel: UILabel!

    static let cellID = "cellID"

    var backgroundView: SlideBackgroundView!
    var slidetopView: SlideTopView!
    var slideMenu: SlideMenu!
    var openFlag: Bool?

    let menuData = [MenuData(title: "메인으로", imageName: "home"),
                    MenuData(title: "마트검색", imageName: "search-2")]


    // MARK: override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        setSlideBarNavigationButton()
        addSubViews()

        slideMenu.delegate = self
        slideMenu.dataSource = self

        openFlag = false

        addGestures()
        NotificationCenter.default.addObserver(self, selector: #selector(detectSelectedMenu(_:)), name: .slideMenuTapped, object: nil)
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
        view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(toggleSlideMenu)))
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

    private func handleDismiss() {
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

    private func handleOpen() {
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
        case .main: return
        case .select:
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "martSelectVC") as? MartSelectViewController else { return }
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

}

// MARK: CollectionView related

extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = slideMenu.dequeueReusableCell(withReuseIdentifier: MainViewController.cellID, for: indexPath) as! SlideMenuCell
        cell.setData(menu: menuData[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuData = self.menuData[indexPath.row]
        UIView.animate(
            withDuration: 0.5, delay: 0, options: .curveEaseOut,
            animations: {
                self.backgroundView.dismiss()
                self.slidetopView.dismiss()
                self.slideMenu.dismiss()
                self.openFlag = false
        }) { (completed: Bool) in
            NotificationCenter.default.post(name: .slideMenuTapped, object: nil, userInfo: ["next": menuData.destinationInfo()])
        }
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: slideMenu.frame.width, height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
