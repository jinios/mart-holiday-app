//
//  AppInfoViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 11/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import UIKit
import Firebase

class AppInfoViewController: UIViewController {

    let storage = Storage.storage()

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var acknowledgementsTextView: UITextView!

    override func viewDidLoad() {
        self.versionLabel.text = setVersionLabel()
        setTextView()
    }

    private func setVersionLabel() -> String {
        guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "Ⓥ 1.0.0"}
        return "버전정보: ⓥ \(appVersionString)"
    }

    private func setTextView() {
        acknowledgementsTextView.layer.borderWidth = 1.0
        acknowledgementsTextView.layer.borderColor = (UIColor.appColor(color: .midgray)).cgColor
        downloadFile { (content) in
            self.acknowledgementsTextView.text = String(content)
        }
    }

    private func downloadFile(handler: @escaping((NSString)->Void)) {

        guard let urlStr = KeyInfoLoader.loadValue(of: .AcknowledgementsURL) else { return }
        let pathReference = storage.reference(forURL: urlStr)

        // Download in memory with a maximum allowed size of 1KB (1 * 1024 bytes)
        pathReference.getData(maxSize: 1 * 1024) { data, _ in
            guard let data = data else { return }
            guard let content = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
            handler(content)
        }
    }


}
