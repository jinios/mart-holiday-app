//
//  MapSetter.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 29..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class MapSetter {

    class func tryGeoRequestTask(address: String, handler: @escaping((GeoPoint?) -> Void)) {
        guard let geoCodeURL = KeyInfoLoader.loadValue(of: .NMapGeoCodeURL) else { return }

        // append queryItem to url
        var urlComponents = URLComponents(string: geoCodeURL)!

        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: String(address.utf8)),
        ]
        let requestURL = urlComponents.url

        // get applicationID and secretKey from plist file
        guard let keyInfoID = KeyInfoLoader.loadValue(of: .NMapClientID) else { return }

        guard let keyInfoSecretKey = KeyInfoLoader.loadValue(of: .NMapSecretKey) else { return }

        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        request.addValue(keyInfoID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(keyInfoSecretKey, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request){(data, response, error) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    let result = try JSONDecoder().decode(AddressDatum.self, from: data)
                    let geoPoint = result.geoPoint()
                    handler(geoPoint)
                } catch _ {
                    handler(nil)
                }
            } else {
                handler(nil)
            }
            }.resume()
    }

    class func loadNMapKeySet() -> (id: Any, secretKey: Any)? {
        if let path = Bundle.main.path(forResource: "KeyInfo", ofType: "plist"){
            guard let myDict = NSDictionary(contentsOfFile: path) else { return nil }
            let appID = myDict["NMapClientID"]!
            let secretKey = myDict["NMapSecretKey"]!
            return (id: appID, secretKey: secretKey)
        }
        return nil
    }


}

