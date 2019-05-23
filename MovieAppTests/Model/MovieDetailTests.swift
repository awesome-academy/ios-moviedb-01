//
//  MovieDetailTests.swift
//  MovieAppTests
//
//  Created by Phan Dinh Van on 5/22/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

@testable import MovieApp
import XCTest

final class MovieDetailTests: XCTestCase {
    func test_mapping() {
        let json: [String: Any] = [
            "backdrop_path": "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
            "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
            "title": "Fight Club",
            "vote_average": 7.8,
            "id": 550,
            "poster_path": "",
        ]
        let movieDetail = MovieDetail(JSON: json)
        
        XCTAssertNotNil(movieDetail)
        XCTAssertEqual(movieDetail?.id, json["id"] as? Int)
        XCTAssertEqual(movieDetail?.title, json["title"] as? String)
        XCTAssertEqual(movieDetail?.voteAverage, json["vote_average"] as? Double)
        XCTAssertEqual(movieDetail?.posterPath, json["poster_path"] as? String)
        XCTAssertEqual(movieDetail?.overview, json["overview"] as? String)
        XCTAssertEqual(movieDetail?.backDropPath, json["backdrop_path"] as? String)
    }
}
