//
//  AppInfoViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 11/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import UIKit
import Firebase

class AppInfoViewController: IndicatorViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var acknowledgementsTextView: UITextView!

    override func viewDidLoad() {
        startIndicator()
        self.versionLabel.text = setVersionLabel()
        setTextView()
        self.navigationItem.title = ProgramDescription.AppInfo.rawValue
    }

    private func setVersionLabel() -> String {
        guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return ProgramDescription.DefaultVersion.rawValue}
        return "버전정보: ⓥ \(appVersionString)"
    }

    private func setTextView() {
        acknowledgementsTextView.layer.borderWidth = 1.0
        acknowledgementsTextView.layer.borderColor = (UIColor.appColor(color: .midgray)).cgColor
        StorageAPI.downloadFile(keyInfo: .AcknowledgementsURL) { (content) in
            self.acknowledgementsTextView.text = String(content)
            self.finishIndicator()
        }
    }


}
