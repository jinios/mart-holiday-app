//
//  NetworkManager.swift
//  MartHoliday
//
//  Created by YOUTH2 on 12/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {

    var reachability: Reachability?
    static var shared: NetworkManager = NetworkManager()

    override init() {
        super.init()
        reachability = try? Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
    }

    @objc func networkStatusChanged(_ notification: Notification) {
        guard let network = notification.object as? Reachability else { return }
        NotificationCenter.default.post(name: .connectionStatus, object: self, userInfo: ["status": network.connection])
    }

    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {

        if let connection = (NetworkManager.shared.reachability)?.connection, connection == .none {
            completed(NetworkManager.shared)
        }
    }

}
