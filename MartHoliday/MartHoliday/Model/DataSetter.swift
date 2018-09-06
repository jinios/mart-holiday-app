//
//  DataSetter.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 6..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class DataSetter<T: KoreanName & JSONfile & URLHolder, U: Codable> {

    class func goToSearchViewController(of mart: T, handler: @escaping((T,[U]) -> Void)) {
        guard let url = mart.url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                var branches = [U]()
                do {
                    branches = try JSONDecoder().decode([U].self, from: data)
                    handler(mart,branches)
                } catch let error {
                    print("Cannot make Data: \(error)")
                }
            } else {
                print("Network error: \((response as? HTTPURLResponse)?.statusCode)")
            }
            }.resume()
    }
}

