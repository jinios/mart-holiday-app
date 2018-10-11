//
//  AppInfoViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 11/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var acknowledgementsTextView: UITextView!

    override func viewDidLoad() {
        self.versionLabel.text = setVersionLabel()
        setTextView()
    }

    private func setVersionLabel() -> String {
        guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "Ⓥ 1.0.0"}
        return "버전정보: Ⓥ \(appVersionString)"
    }

    private func setTextView() {
        acknowledgementsTextView.layer.borderWidth = 1.0
        acknowledgementsTextView.layer.borderColor = (UIColor.appColor(color: .midgray)).cgColor
    }
}
