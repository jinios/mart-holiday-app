//
//  ViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 10..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class MartSelectViewController: UIViewController {

    @IBOutlet weak var emartButton: UIButton!
    @IBOutlet weak var lotteMartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func emartButtonTapped(_ sender: Any) {
        pushSearchViewController(mart: JSONFiles.emartList.rawValue)
    }

    @IBAction func lotteMartButtonTapped(_ sender: Any) {
        pushSearchViewController(mart: JSONFiles.lottemartList.rawValue)
    }

    private func pushSearchViewController(mart: String) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as? SearchViewController else { return }
        guard let branches = DataDecoder<Branch>.makeData(assetName: mart) else  { return }
        nextVC.list = BranchList(branches: branches)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

