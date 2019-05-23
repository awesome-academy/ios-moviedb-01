//
//  MainNavigatorMock.swift
//  MovieAppTests
//
//  Created by nguyen.nam.khanh on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XCTest
@testable import MovieApp

final class MainNavigatorMock: MainNavigator {
    var toSearchCalled = false
    var toDetailMovieCalled = false
    var toHomeExtensionCalled = false
    
    func toSearch() {
        toSearchCalled = true
    }
    
    func toDetailMovie(movie: Movie) {
        toDetailMovieCalled = true
    }
    
    func toHomeExtension() {
        toHomeExtensionCalled = true
    }
}
