//
//  APIResponse.swift
//  MartHoliday
//
//  Created by YOUTH2 on 07/04/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    var code: String?
    var message: String?
    var info: String?
    var branches: [BranchRawData]?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case info = "info"
        case branches = "data"
    }
}
