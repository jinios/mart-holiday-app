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
        case .emart: return URL(string: "http://ec2-13-209-38-224.ap-northeast-2.compute.amazonaws.com/api/mart/EMART/list")
        case .lottemart: return URL(string: "http://ec2-13-209-38-224.ap-northeast-2.compute.amazonaws.com/api/mart/LOTTEMART/list")
        case .homeplus: return URL(string: "http://ec2-13-209-38-224.ap-northeast-2.compute.amazonaws.com/api/mart/HOMEPLUS/list")
        case .homeplusExpress: return URL(string: "http://ec2-13-209-38-224.ap-northeast-2.compute.amazonaws.com/api/mart/HOMEPLUS_EXPRESS/list")
        }
    }

    var imageName: String {
        switch self {
        case .emart: return "emart-ci"
        case .lottemart: return "lottemart-ci"
        case .homeplus: return "homeplus-ci"
        case .homeplusExpress: return "homeplus-express-ci"
        }
    }

    static let allValues: [Mart] = [emart, lottemart, homeplus, homeplusExpress]
}
