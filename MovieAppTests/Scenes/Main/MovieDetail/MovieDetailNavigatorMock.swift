//
//  MovieDetailNavigatorMock.swift
//  MovieAppTests
//
//  Created by Phan Dinh Van on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

@testable import MovieApp

final class MovieDetailNavigatorMock: MovieDetailNavigator {
    var isToActorCalled = false
    
    func toActor(cast: Cast) {
        isToActorCalled = true
    }
    
    var isBackCalled = false
    
    func back() {
        isBackCalled = true
    }
}
