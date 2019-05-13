//
//  CustomRequestAdapter.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/10/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import Alamofire

final class CustomRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let accessToken = UserDefaults.standard.string(forKey: Constants.keyAccessToken) {
            urlRequest.setValue(accessToken, forHTTPHeaderField: "X-AccessToken")
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
