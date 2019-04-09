//
//  DistanceSearch.swift
//  MartHoliday
//
//  Created by YOUTH2 on 04/02/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import Foundation

class DistanceSearch {

    class func fetch(geoPoint: NGeoPoint, distance: Int, handler: @escaping ([BranchRawData]) -> Void) {
        guard let value = KeyInfoLoader.loadValue(of: .BaseURL) else { return }
        var urlComponents = URLComponents(string: value)

        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(geoPoint.latitude)),
            URLQueryItem(name: "longitude", value: String(geoPoint.longitude)),
            URLQueryItem(name: "distance", value: String(distance))
        ]
        guard let url = urlComponents?.url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var branches = [BranchRawData]()
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    branches = try JSONDecoder().decode([BranchRawData].self, from: data, keyPath: "data")
                    handler(branches)
                } catch {

                }
            } else {

            }
        }.resume()
    }

}
