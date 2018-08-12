//
//  Keywords.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

enum Mart: String, KoreanName, JSONfile {

    case emart
    case lottemart

    var koreanName: String {
        switch self {
        case .emart: return "이마트"
        case .lottemart: return "롯데마트"
        }
    }

    var JSONfile: String {
        switch self {
        case .emart: return "emartList"
        case .lottemart: return "lottemartList"
        }
    }
}

protocol KoreanName {
    var koreanName: String { get }
}

protocol JSONfile {
    var JSONfile: String { get }
}
