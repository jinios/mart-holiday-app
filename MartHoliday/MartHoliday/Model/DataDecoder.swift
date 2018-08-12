//
//  DataDecoder.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 11..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import UIKit

class DataDecoder<T: Codable> {
    
    class func makeData(assetName: String) -> [T]? {
        var result = [T]()
        let asset = NSDataAsset(name: assetName, bundle: Bundle.main)
        do {
            result = try JSONDecoder().decode([T].self, from: asset!.data)
        } catch let error {
            print("Cannot make Data: \(error)")
            return nil
        }
        return result
    }
}
