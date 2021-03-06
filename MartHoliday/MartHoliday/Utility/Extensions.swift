//
//  Extensions.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 15..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let slideMenuClose = Notification.Name("slideMenuClose")
    static let slideMenuTapped = Notification.Name("slideMenuClose")
    static let mapViewTapped = Notification.Name("mapViewTapped")
    static let connectionStatus = Notification.Name("connectionStatus")
    static let apiErrorAlertPopup = Notification.Name("apiErrorAlertPopup")
    static let completeFetchNearMart = Notification.Name("completeFetchNearMart")
}

enum AppColor: CustomStringConvertible {
    case lightgray
    case midgray
    case lightmint
    case mint
    case navy
    case red
    case yellow

    var description: String {
        switch self {
        case .lightgray: return "mh-lightgray"
        case .midgray: return "mh-midgray"
        case .lightmint: return "mh-lightmint"
        case .mint: return "mh-mint"
        case .navy: return "mh-navy"
        case .red: return "mh-red"
        case .yellow: return "mh-yellow"
        }
    }
}

extension UIAlertController {

    class func make(message: AlertMessage) -> UIAlertController {
        let alert = UIAlertController(title: message.rawValue.title,
                                      message: message.rawValue.body,
                                      preferredStyle: .alert)
        return alert
    }

    enum AlertMessage: RawRepresentable {
        case DisableNearbyMarts
        case NetworkError
        case NetworkTimeout
        case SuccessSendingMail
        case FailureSendingMail
        case ForcedUpdate
        case OptionalUpdate

        var rawValue: (title: String, body: String) {
            switch self {
            case .DisableNearbyMarts:
                return (title:"위치 검색", body: "마트 위치검색에 문제가 발생했습니다.\n잠시 후 다시 시도해주세요.")
            case .NetworkError:
                return (title:"에러!💥", body: "네트워크를 찾을 수 없습니다.\n앱을 구동하기위해 인터넷 연결을 확인해주세요.")
            case .NetworkTimeout:
                return (title: "죄송합니다😰", body: "서버에 문제가 발생했습니다.\n잠시 후 다시 시도해주세요.")
            case .SuccessSendingMail:
                return (title: "감사합니다❤️", body:"소중한 의견 감사합니다 :)")
            case .FailureSendingMail:
                return (title: "메일 전송 실패😢", body:"아이폰 기본 '메일'앱에서 계정을 추가해주세요!")
            case .ForcedUpdate:
                return (title: "업데이트", body: "필수 업데이트가 있습니다.\n앱을 구동하기위해 업데이트해주세요.😍")
            case .OptionalUpdate:
                return (title: "업데이트", body: "새 버전이 출시됐습니다.\n업데이트 하러 갈래요?😆")
            }

        }

        init?(rawValue: (title: String, body: String)) {
            switch rawValue {
            case (title:"위치 검색", body: "마트 위치검색에 문제가 발생했습니다.\n잠시 후 다시 시도해주세요."):
                self = .DisableNearbyMarts
            case (title:"에러!💥", body: "네트워크를 찾을 수 없습니다.\n앱을 구동하기위해 인터넷 연결을 확인해주세요."):
                self = .NetworkError
            case (title: "죄송합니다😰",body: "서버에 문제가 발생했습니다.\n잠시 후 다시 시도해주세요."):
                self = .NetworkTimeout
            default: return nil
            }
        }

    }
}

extension UIColor {
    class func appColor(color: AppColor) -> UIColor {
        return UIColor(named: color.description)!
    }
}

extension UIFont {
    func bold() -> UIFont {
        let desc = self.fontDescriptor.withSymbolicTraits(.traitBold)
        return UIFont(descriptor: desc!, size: self.pointSize)
    }
}

extension UIButton {
    func setArrowImage() {
        self.setImage(UIImage(named: "downArrow"), for: .normal)
        self.setImage(UIImage(named: "upArrow"), for: .selected)
    }
}

extension UILabel {
    func partialBackgroundChange(fullText : String , changeText : String ) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.appColor(color: .yellow) , range: range)
        self.attributedText = attribute
    }
}


extension Collection where Index == Int {

    func randomElement() -> Iterator.Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(endIndex)))]
    }

}

///Identifier 찾기

extension UIDevice {

    class func deviceModelName() -> String {
        let model = UIDevice.current.model

        switch model {
        case "iPhone":
            return self.iPhoneModel()
        default:
            return "Unknown Model : \(model)"
        }
    }

    private class func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }


    private class func iPhoneModel() -> String {
        let identifier = self.getDeviceIdentifier()
        switch identifier {
        case "iPhone1,1" :
            return "iPhone"
        case "iPhone1,2" :
            return "iPhone3G"
        case "iPhone2,1" :
            return "iPhone3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3" :
            return "iPhone4"
        case "iPhone4,1" :
            return "iPhone4s"
        case "iPhone5,1", "iPhone5,2" :
            return "iPhone5"
        case "iPhone5,3", "iPhone5,4" :
            return "iPhone5c"
        case "iPhone6,1", "iPhone6,2" :
            return "iPhone5s"
        case "iPhone7,2" :
            return "iPhone6"
        case "iPhone7,1" :
            return "iPhone6 Plus"
        case "iPhone8,1" :
            return "iPhone6s"
        case "iPhone8,2" :
            return "iPhone6s Plus"
        case "iPhone8,4" :
            return "iPhone SE"
        case "iPhone9,1", "iPhone9,3" :
            return "iPhone7"
        case "iPhone9,2", "iPhone9,4" :
            return "iPhone7 Plus"
        case "iPhone10,1", "iPhone10,4" :
            return "iPhone8"
        case "iPhone10,2", "iPhone10,5" :
            return "iPhone8 Plus"
        case "iPhone10,3", "iPhone10,6" :
            return "iPhoneX"
        case "iPhone11,2" :
            return "iPhoneXS"
        case "iPhone11,4" :
            return "iPhoneXS MAX"
        case "iPhone11,8" :
            return "iPhoneXR"
        default:
            return "Unknown iPhone : \(identifier)"
        }

    }

}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
}
