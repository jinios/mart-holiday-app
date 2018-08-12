//
//  SearchViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var list: BranchList?
    var mart: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setNavigationBarTitle() {
        guard let mart = self.mart else { return }
        self.navigationItem.title = mart
    }

}
