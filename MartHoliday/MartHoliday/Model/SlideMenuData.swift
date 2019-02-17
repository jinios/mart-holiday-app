//
//  MenuData.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 21..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

enum SlideMenu: CaseIterable {
    case main
    case select
//    case location
    case sendMail
    case appInfo

    var value: MenuDatum {
        switch self {
        case .main: return MenuDatum(title: "메인으로", imageName: "home")
        case .select: return MenuDatum(title: "마트검색", imageName: "search-2")
//        case .location: return MenuDatum(title: "위치검색", imageName: "location-search")
        case .sendMail: return MenuDatum(title: "문의하기", imageName: "mail")
        case .appInfo: return MenuDatum(title: "앱 정보", imageName: "appinfo")
        }
    }
}


struct MenuDatum {
    var title: String
    var imageName: String

    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
