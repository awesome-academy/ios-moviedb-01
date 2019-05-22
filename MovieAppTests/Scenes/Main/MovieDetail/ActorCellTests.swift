//
//  ActorCellTests.swift
//  MovieAppTests
//
//  Created by Phan Dinh Van on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

@testable import MovieApp
import XCTest

final class ActorCellTests: XCTestCase {
    var cell: ActorCell!
    
    override func setUp() {
        super.setUp()
        cell = ActorCell.loadFromNib()
    }
    
    func test_ibOutlets() {
        XCTAssertNotNil(cell)
    }
}
