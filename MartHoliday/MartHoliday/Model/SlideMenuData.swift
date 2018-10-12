//
//  MenuData.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 21..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

enum SelectedSlideMenu {
    case main
    case select
    case sendMail
    case appInfo
}

class SlideMenuData {
    var title: String
    var imageName: String

    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }

    func destinationInfo() -> SelectedSlideMenu {
        switch self.title {
        case "메인으로": return .main
        case "마트검색": return .select
        case "문의하기": return .sendMail
        case "앱 정보": return .appInfo
        default: return .main
        }
    }
}