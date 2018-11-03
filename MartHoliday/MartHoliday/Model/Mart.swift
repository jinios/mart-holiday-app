//
//  Keywords.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

protocol URLHolder {
    var url: URL? { get }
}

protocol CIImageHolder {
    var imageName: String { get }
    var grayImageName: String { get }
}

enum Mart: String, URLHolder, CIImageHolder, CustomStringConvertible {

    case emart
    case lottemart
    case homeplus
    case homeplusExpress

    var description: String {
        switch self {
        case .emart: return "이마트"
        case .lottemart: return "롯데마트"
        case .homeplus: return "홈플러스"
        case .homeplusExpress: return "홈플러스EX"
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
