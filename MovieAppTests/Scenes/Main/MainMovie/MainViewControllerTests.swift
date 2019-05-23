//
//  MainViewControllerTests.swift
//  MovieAppTests
//
//  Created by nguyen.nam.khanh on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XCTest
@testable import MovieApp

final class MainViewControllerTests: XCTestCase {
    private var viewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        viewController = MainViewController.instantiate()
    }
}
