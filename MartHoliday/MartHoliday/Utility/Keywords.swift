//
//  Keywords.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

enum Mart: String, KoreanName, JSONfile, URLHolder {

    case emart
    case lottemart
    case homeplus
    case homeplusExpress

    var koreanName: String {
        switch self {
        case .emart: return "이마트"
        case .lottemart: return "롯데마트"
        case .homeplus: return "홈플러스"
        case .homeplusExpress: return "홈플러스 익스프레스"
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
}

protocol KoreanName {
    var koreanName: String { get }
}

protocol JSONfile {
    var JSONfile: String { get }
}

protocol URLHolder {
    var url: URL? { get }
}
