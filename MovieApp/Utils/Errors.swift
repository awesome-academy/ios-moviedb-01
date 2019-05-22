//
//  Errors.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/14/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

enum Errors: BaseError, Error {
    case cantInitRealm
    case catchError(message: String)
    
    var errorMessage: String? {
        switch self {
        case .cantInitRealm:
            return "Failed to init Realm Database."
        case .catchError(let message):
            return message
        }
    }
}
