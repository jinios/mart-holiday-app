//
//  RemoteConfigManager.swift
//  MartHoliday
//
//  Created by YOUTH2 on 27/03/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import Foundation
import Firebase

enum RemoteConfigKey: String {
    case updateStatus = "update_status"
    case minimumVersion = "minimum_version"
    case latestVersion = "latest_version"
    case baseURL = "base_url"
}

// App Initializer
class RemoteConfigManager: NSObject {

    var baseURL: URL?

    private static var sharedInstance = RemoteConfigManager()

    private override init() {
        super.init()
    }

    static func shared() -> RemoteConfigManager {
        return sharedInstance
    }

    func launch(handler: @escaping ((ConfigResult) -> Void)) {
        let remoteConfig = RemoteConfig.remoteConfig()

        remoteConfig.fetch(withExpirationDuration: TimeInterval(60)) { (status, err) in
            if status == .success {
                remoteConfig.activateFetched()
                let updateStatus = remoteConfig[RemoteConfigKey.updateStatus.rawValue].boolValue
                let min = remoteConfig[RemoteConfigKey.minimumVersion.rawValue].stringValue
                let latest = remoteConfig[RemoteConfigKey.latestVersion.rawValue].stringValue

                let appConfig = AppConfig(status: updateStatus, min: min, latest: latest)
                let configResult = appConfig.compare()
//                self.setBaseURL(url: remoteConfig[RemoteConfigKey.baseURL.rawValue].stringValue)
                handler(configResult)
            } else {
                // fetch 실패시 앱 실행
                handler(.executeApp)
            }
        }
    }

    private func appVersion() -> Double {
        guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return 0 }
        return Double(appVersionString) ?? 0
    }

    private func setBaseURL(url: String?) {
        guard let url = URL(string: url ?? "") else { return }

        CoreUserDefaults.set(value: url, key: .baseURL, type: URL.self)
        self.baseURL = CoreUserDefaults.load(key: .baseURL) as? URL
    }

}


enum ConfigResult {
    case forcedUpdate
    case optionalUpdate
    case comparingFailure
    case executeApp
}

class AppConfig {
    var updateStatus: Bool?
    var minVersion: Double?
    var latestVersion: Double?
    var appVersion: Double {
        guard let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return 0 }
        return Double(appVersionString) ?? 0
    }

    init(status: Bool?, min: String?, latest: String?) {
        self.updateStatus = status ?? false
        self.minVersion = Double(min ?? "0")
        self.latestVersion = Double(latest ?? "0")
    }

    func compare() -> ConfigResult {
        guard let updateStatus = self.updateStatus else { return .comparingFailure }
        guard updateStatus == true else { return .executeApp }
        guard let minVersion = self.minVersion else { return .comparingFailure }
        guard let latestVersion = self.latestVersion else { return .comparingFailure }
        guard minVersion != 0 && latestVersion != 0 else { return .comparingFailure }

        switch appVersion {
            case latestVersion: return .executeApp
            case 0..<minVersion: return .forcedUpdate
            case minVersion..<latestVersion: return .optionalUpdate
            default: return .comparingFailure
        }
    }

}

enum CoreUserDefaults: String {

    case baseURL = "baseURL"

    static func set<T: Equatable & Codable>(value: Any, key: CoreUserDefaults, type: T.Type) {
        if let loadedData = self.load(key: key), compare(type: type, rhs: loadedData, lhs: value) {
            return
        }
        guard let encodedValue = try? JSONEncoder().encode(value as! T) else { return }
        UserDefaults.standard.set(encodedValue, forKey: key.rawValue)
    }

    static func load(key: CoreUserDefaults) -> Any? {
        if let loadedData = UserDefaults.standard.data(forKey: key.rawValue) {
            return loadedData
        }
        return nil
    }

    static func compare<T: Equatable>(type: T.Type, rhs: Any, lhs: Any) -> Bool {
        guard let rhs = rhs as? T, let lhs = lhs as? T else { return false }
        return rhs == lhs
    }

}

