//
//  MovieTests.swift
//  MovieAppTests
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

@testable import MovieApp
import XCTest

final class MovieTests: XCTestCase {
    func test_mapping() {
        let json: [String: Any] = [
            "id": 447_404,
            "title": "Pokémon Detective Pikachu",
            "poster_path": "/wgQ7APnFpf1TuviKHXeEe3KnsTV.jpg",
            "vote_average": 8.5,
            "release_date": "2019-04-24"
        ]
        let movie = Movie(JSON: json)
        
        XCTAssertNotNil(movie)
        XCTAssertEqual(movie?.id, json["id"] as? Int)
        XCTAssertEqual(movie?.title, json["title"] as? String)
        XCTAssertEqual(movie?.posterPath, json["poster_path"] as? String)
        XCTAssertEqual(movie?.voteAverage, json["vote_average"] as? Double)
        XCTAssertEqual(movie?.releaseDate, json["release_date"] as? String)
    }
}
