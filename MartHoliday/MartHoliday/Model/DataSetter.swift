//
//  DataSetter.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 9. 6..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class DataSetter<T: URLHolder, U: Codable> {

    class func goToSearchViewController(of mart: T, handler: @escaping((T,[U]?) -> Void)) {
        guard let url = mart.url else { return }

        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 3
        let session = URLSession(configuration: configure)

        session.dataTask(with: url) { (data, response, error) in
            var branches = [U]()
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    branches = try JSONDecoder().decode([BranchRawData].self, from: data, keyPath: "data") as! [U]
                    handler(mart,branches)
                } catch {
                    handler(mart,nil)
                }
            } else {
                handler(mart,nil)
            }
            }.resume()
    }
}

