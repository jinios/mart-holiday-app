//
//  MainViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 16..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, SlideLauncherDelegate {

    @IBOutlet weak var firstFavoriteLabel: UILabel!
    @IBOutlet weak var secondFavoriteLabel: UILabel!
    @IBOutlet weak var thirdFavoriteLabel: UILabel!
    let slideLauncher = SlideLauncher()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSlideBarButton()
        slideLauncher.delegate = self
        slideLauncher.set()
        NotificationCenter.default.addObserver(self, selector: #selector(detectSelectedMenu(_:)), name: .slideMenuTapped, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func toggleSlideMenu() {
        // open or dismiss
        if slideLauncher.isOpened() {
            slideLauncher.handleDismiss()
        } else {
            slideLauncher.show()
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

    private func setSlideBarButton() {
        let searchImage = UIImage(named: "slidebar")
        let searhButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(toggleSlideMenu))
        navigationItem.leftBarButtonItem = searhButton
    }

}

protocol SlideLauncherDelegate {

}
