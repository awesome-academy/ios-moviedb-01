//
//  VideoTests.swift
//  MovieAppTests
//
//  Created by Phan Dinh Van on 5/22/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

@testable import MovieApp
import XCTest

final class VideoTests: XCTestCase {
    func test_mapping() {
        let json: [String: Any] = [
            "key": "SUXWAEX2jlg",
            "name": "Trailer 1"
        ]
        let video = Video(JSON: json)
        
        XCTAssertNotNil(video)
        XCTAssertEqual(video?.key, json["key"] as? String)
        XCTAssertEqual(video?.name, json["name"] as? String)
    }
}
