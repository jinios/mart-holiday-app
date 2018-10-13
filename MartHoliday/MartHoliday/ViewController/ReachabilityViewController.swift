//
//  ReachabilityViewController.swift
//  MartHoliday
//
//  Created by YOUTH2 on 14/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import UIKit
import Reachability

class RechabilityDetectViewController: UIViewController {

    func setNetworkConnectionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityAlert(notification:)), name: .connectionStatus, object: nil)
    }

    func networkErrorAlert() {
        let alert = UIAlertController.noNetworkAlert()
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func reachabilityAlert(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let connection = userInfo["status"] as? Reachability.Connection else { return }
        switch connection {
        case .none:
            networkErrorAlert()
        default:
            networkAvailable()
        }
    }

    // sub-class must need to override
    func networkAvailable() {
        return
    }

    func networkTimeOutAlert() {
        let alert = UIAlertController.networkTimeOutAlert()
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
