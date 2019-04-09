//
//  StorageAPI.swift
//  MartHoliday
//
//  Created by YOUTH2 on 11/10/2018.
//  Copyright © 2018 JINiOS. All rights reserved.
//

import Foundation
import Firebase

class StorageAPI {
    static let storage = Storage.storage()

    class func downloadFile(keyInfo: KeyInfo, handler: @escaping((NSString)->Void)) {

        guard let urlStr = KeyInfoLoader.loadValue(of: keyInfo) else { return }
        let pathReference = storage.reference(forURL: urlStr)

        // Download in memory with a maximum allowed size of 1KB (1 * 1024 bytes)
        pathReference.getData(maxSize: 100 * 1024) { data, _ in
            guard let data = data else { return }
            guard let content = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
            handler(content)
        }
    }


}
