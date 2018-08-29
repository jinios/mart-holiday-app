//
//  MapSetter.swift
//  MartHoliday
//
//  Created by YOUTH2 on 2018. 8. 29..
//  Copyright © 2018년 JINiOS. All rights reserved.
//

import Foundation

class MapSetter {

    class func tryGeoRequestTask(url: String, address: String, handler: @escaping((GeoPoint) -> Void)) {
        // append queryItem to url
        var urlComponents = URLComponents(string: url)!

        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: String(address.utf8)),
        ]
        let requestURL = urlComponents.url

        // get applicationID and secretKey from plist file
        let keyInfo = MapSetter.loadNMapKeySet()!

        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        request.addValue(keyInfo.id as! String, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(keyInfo.secretKey as! String, forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request){(data, response, error) in
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    let result = try JSONDecoder().decode(AddressDatum.self, from: data)
                    let geoPoint = result.geoPoint()
                    handler(geoPoint)
                } catch let decodeErr {
                    print(decodeErr)
                }
            } else {
                print(error)
            }
            }.resume()
    }

    private class func loadNMapKeySet() -> (id: Any, secretKey: Any)? {
        if let path = Bundle.main.path(forResource: "KeyInfo", ofType: "plist"){
            guard let myDict = NSDictionary(contentsOfFile: path) else { return nil }
            let appID = myDict["NMapClientID"]!
            let secretKey = myDict["NMapSecretKey"]!
            return (id: appID, secretKey: secretKey)
        }
        return nil
    }


}

