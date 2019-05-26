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
        let alert = UIAlertController.make(message: .NetworkError)
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
        let alert = UIAlertController.make(message: .NetworkTimeout)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class SlackWebhook {
    enum Keyword: String {
        case url = "https://hooks.slack.com/services/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"
        case httpPostRequest = "POST"
        case dataType = "application/json"
        case headerField = "Content-Type"
    }

    class func fire(message: String? = nil) {
        guard let url = URL(string: SlackWebhook.Keyword.url.rawValue) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(SlackWebhook.Keyword.dataType.rawValue, forHTTPHeaderField: SlackWebhook.Keyword.headerField.rawValue)

        var payload: [String:String] = [:]
        payload["text"] = message ?? "none"
        payload["icon_emoji"] = self.selectRandomEmoji()

        guard let httpBody = try? JSONSerialization.data(withJSONObject: payload, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request).resume()
    }

    private class func selectRandomEmoji() -> String {
        let emoji = [":smiling_imp:", ":hankey::ghost:", ":skull_and_crossbones:", ":scream_cat:", ":boom:", ":scream:", ":exploding_head:", ":face_with_symbols_on_mouth:"]
        return emoji.randomElement() ?? ":exploding_head:"
    }

}



struct APIErrorMessage {

    enum ErrorType: String { case Parsing, Data, Network }

    var brokenUrl: URL?
    var httpStatusCode: Int?
    var data: Data?
    var apiResponse: APIResponse?
    var type: ErrorType

    init(brokenUrl: URL?, httpStatusCode: Int? = nil, data: Data? = nil, apiResponse: APIResponse? = nil, type: ErrorType) {
        self.brokenUrl = brokenUrl
        self.httpStatusCode = httpStatusCode
        self.data = data
        self.apiResponse = apiResponse
        self.type = type
    }

    func body() -> String {

        return """
        >>>문제가 터졌다:bomb:\n얼른고쳐라 닝겐\n
        URL: \(self.brokenUrl?.absoluteString ?? "none")\n
        StatusCode: \(self.httpStatusCode ?? 0)\n
        Code: \(self.apiResponse?.code ?? "none")\n
        Message: \(self.apiResponse?.message ?? "none")\n
        type: \(self.type.rawValue)\n
        """
    }
}
