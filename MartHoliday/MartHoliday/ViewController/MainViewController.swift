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
    @IBOutlet weak var slideMenuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(detectSelectedMenu(_:)), name: .slideMenuTapped, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let slideLauncher = SlideLauncher()

    @IBAction func slideMenuTapped(_ sender: Any) {
        slideLauncher.delegate = self
        slideLauncher.set()
        slideLauncher.show()
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

protocol SlideLauncherDelegate {

}
