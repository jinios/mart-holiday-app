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
    @IBOutlet weak var homeplusButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var expLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
        self.navigationItem.title = "마트 선택"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setScrollView() {
        scrollView.contentSize.width = UIScreen.main.bounds.width
        scrollView.contentSize.height = (UIScreen.main.bounds.height)*2

        scrollView.addSubview(emartButton)
        scrollView.addSubview(lotteMartButton)
        scrollView.addSubview(homeplusButton)
        scrollView.addSubview(expLabel)
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

