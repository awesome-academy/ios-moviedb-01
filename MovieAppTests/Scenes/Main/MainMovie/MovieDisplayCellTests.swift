//
//  MovieDisplayCellTests.swift
//  MovieAppTests
//
//  Created by nguyen.nam.khanh on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XCTest
@testable import MovieApp

final class MovieDisplayCellTests: XCTestCase {
    var cell: MovieDisplayCell!
    
    override func setUp() {
        super.setUp()
        cell = MovieDisplayCell.loadFromNib()
    }
    
    func test_ibOutlets() {
        XCTAssertNotNil(cell)
    }
}
