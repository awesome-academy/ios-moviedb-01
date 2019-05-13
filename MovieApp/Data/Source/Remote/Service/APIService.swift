//
//  APIService.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/10/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

struct APIService {    
    static let share = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func request<T: Mappable>(input: BaseRequest) ->  Observable<T> {
        
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")
        
        return Observable.create { observer in
            self.alamofireManager.request(input.url,
                                          method: input.requestType,
                                          parameters: input.body,
                                          encoding: input.encoding)
                .validate(statusCode: 200..<511)
                .responseJSON { response in
                    print(response.request?.url ?? "Error")
                    print(response)
                    switch response.result {
                    case .success(let value):
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let object = Mapper<T>().map(JSONObject: value) {
                                    observer.onNext(object)
                                }
                            } else {
                                if let object = Mapper<ErrorResponse>().map(JSONObject: value) {
                                    observer.onError(BaseError.apiFailure(error: object))
                                } else {
                                    observer.onError(BaseError.httpError(httpCode: statusCode))
                                }
                            }
                        } else {
                            observer.on(.error(BaseError.unexpectedError))
                        }
                        observer.onCompleted()
                    case .failure:
                        observer.onError(BaseError.networkError)
                        observer.onCompleted()
                    }                    
                }
            return Disposables.create()
        }
    }
}

