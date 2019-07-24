//
//  DistanceSearch.swift
//  MartHoliday
//
//  Created by YOUTH2 on 04/02/2019.
//  Copyright © 2019 JINiOS. All rights reserved.
//

import Foundation
import NMapsMap

class DistanceSearch {

    class func fetch(geoPoint: NMGLatLng, distance: Int, handler: @escaping ([BranchRawData]) -> Void) {
        guard let value = KeyInfoLoader.loadValue(of: .BaseURL) else { return }
        var urlComponents = URLComponents(string: value)

        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(geoPoint.lat)),
            URLQueryItem(name: "longitude", value: String(geoPoint.lng)),
            URLQueryItem(name: "distance", value: String(distance))
        ]
        guard let url = urlComponents?.url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var apiResponse = APIResponse()

            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    if let branches = apiResponse.branches {
                        handler(branches)
                    } else {
                        NotificationCenter.default.post(name: .apiErrorAlertPopup, object: nil)
                        let apiErrorMessage = APIErrorMessage(brokenUrl: url,
                                                              httpStatusCode: response.statusCode,
                                                              data: data,
                                                              apiResponse: apiResponse,
                                                              type: .Data)
                        SlackWebhook.fire(message: apiErrorMessage.body())
                    }
                } catch {
                    NotificationCenter.default.post(name: .apiErrorAlertPopup, object: nil)
                    let apiErrorMessage = APIErrorMessage(brokenUrl: url,
                                              httpStatusCode: response.statusCode,
                                              data: data,
                                              apiResponse: apiResponse,
                                              type: .Parsing)
                    SlackWebhook.fire(message: apiErrorMessage.body())
                }
            } else {
                NotificationCenter.default.post(name: .apiErrorAlertPopup, object: nil)
                let apiErrorMessage = APIErrorMessage(brokenUrl: url,
                                                      data: data,
                                                      apiResponse: apiResponse,
                                                      type: .Network)
                SlackWebhook.fire(message: apiErrorMessage.body())
            }
        }.resume()
    }

}
