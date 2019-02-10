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

enum Mart: String, URLHolder, CIImageHolder, CustomStringConvertible, CaseIterable {

    case emart
    case traders
    case lottemart
    case costco
    case homeplus
    case homeplusExpress

    var description: String {
        switch self {
        case .emart: return "이마트"
        case .traders: return "트레이더스"
        case .lottemart: return "롯데마트"
        case .costco: return "코스트코"
        case .homeplus: return "홈플러스"
        case .homeplusExpress: return "홈플러스EX"
        }
    }

    var url: URL? {
        switch self {
        case .emart: return loadURL(.EmartList)
        case .traders: return loadURL(.TradersList)
        case .lottemart: return loadURL(.LottemartList)
        case .costco: return loadURL(.CostcoList)
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
        case .traders: return "traders-ci"
        case .lottemart: return "lottemart-ci"
        case .costco: return "costco-ci"
        case .homeplus: return "homeplus-ci"
        case .homeplusExpress: return "homeplus-express-ci"
        }
    }

    var grayImageName: String {
        switch self {
        case .emart: return "emart-ci-gray"
        case .traders: return "traders-ci-gray"
        case .lottemart: return "lottemart-ci-gray"
        case .costco: return "costco-ci-gray"
        case .homeplus: return "homeplus-ci-gray"
        case .homeplusExpress: return "homeplus-express-ci-gray"
        }
    }

}
