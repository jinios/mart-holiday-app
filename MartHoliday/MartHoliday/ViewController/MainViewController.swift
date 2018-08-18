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
}

protocol SlideLauncherDelegate {

}
