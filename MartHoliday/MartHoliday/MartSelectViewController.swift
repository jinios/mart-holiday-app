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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func emartButtonTapped(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "searchVC") as? SearchViewController else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }


    @IBAction func lotteMartButtonTapped(_ sender: Any) {
    }
}

