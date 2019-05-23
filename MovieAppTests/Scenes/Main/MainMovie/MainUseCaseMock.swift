//
//  MainUseCaseMock.swift
//  MovieAppTests
//
//  Created by nguyen.nam.khanh on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XCTest
import RxSwift
@testable import MovieApp

class MainUseCaseMock: MainUseCase {
    var getUpcommingMovieListCalled = false
    var getPopularMovieListCalled = false
    
    var getUpcommingMovieReturnValue: Observable<[Movie]> = {
        let items = [Movie().with { $0.id = 1}]
        return Observable.just(items)
    }()
    
    var getPopularMovieReturnValue: Observable<[Movie]> = {
        let items = [Movie().with { $0.id = 1}]
        return Observable.just(items)
    }()
    
    func getUpcommingMovie(page: Int) -> Observable<[Movie]> {
        getUpcommingMovieListCalled = true
        return getUpcommingMovieReturnValue
    }
    
    func getPopularMovie(page: Int) -> Observable<[Movie]> {
        getPopularMovieListCalled = true
        return getPopularMovieReturnValue
    }
}
