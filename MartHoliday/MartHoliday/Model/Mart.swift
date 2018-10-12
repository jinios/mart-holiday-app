//
//  Keywords.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

protocol KoreanName {
    var koreanName: String { get }
}

protocol JSONfile {
    var JSONfile: String { get }
}

protocol URLHolder {
    var url: URL? { get }
}

protocol CIImageHolder {
    var imageName: String { get }
    var grayImageName: String { get }
}

enum Mart: String, KoreanName, JSONfile, URLHolder, CIImageHolder {

    case emart
    case lottemart
    case homeplus
    case homeplusExpress

    var koreanName: String {
        switch self {
        case .emart: return "이마트"
        case .lottemart: return "롯데마트"
        case .homeplus: return "홈플러스"
        case .homeplusExpress: return "홈플러스EX"
        }
    }

    var JSONfile: String {
        switch self {
        case .emart: return "emartList"
        case .lottemart: return "lottemartList"
        default: return ""
        }
    }

    var url: URL? {
        switch self {
        case .emart: return loadURL(.EmartList)
        case .lottemart: return loadURL(.LottemartList)
        case .homeplus: return loadURL(.HomeplusList)
        case .homeplusExpress: return loadURL(.HomeplusExpressList)
        }
    }

    func loadURL(_ keyInfoType: KeyInfo) -> URL? {
        guard let urlStr = KeyInfoLoader.loadValue(of: keyInfoType) else { return nil }
        return URL(string: urlStr)
    }

    var imageName: String {
        switch self {
        case .emart: return "emart-ci"
        case .lottemart: return "lottemart-ci"
        case .homeplus: return "homeplus-ci"
        case .homeplusExpress: return "homeplus-express-ci"
        }
    }

    var grayImageName: String {
        switch self {
        case .emart: return "emart-ci-gray"
        case .lottemart: return "lottemart-ci-gray"
        case .homeplus: return "homeplus-ci-gray"
        case .homeplusExpress: return "homeplus-express-ci-gray"
        }
    }

    static let allValues: [Mart] = [emart, lottemart, homeplus, homeplusExpress]
}
