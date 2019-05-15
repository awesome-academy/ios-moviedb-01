//
//  ErrorResponse.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/10/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import ObjectMapper

final class ErrorResponse: Mappable {
    var statusCode = 0
    var statusMessage = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        statusCode <- map["status_code"]
        statusMessage <- map["status_message"]
    }
}
