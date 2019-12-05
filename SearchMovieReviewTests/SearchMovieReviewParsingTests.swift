//
//  SearchMovieReviewTests.swift
//  SearchMovieReviewTests
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import XCTest
@testable import SearchMovieReview

class SearchMovieReviewParsingTests: XCTestCase {

    struct Constant {
        static let movieList = "MovieDataDummy"
        static let json = "json"
        static let imdbId = "tt0775392"
        static let title = "The Mummy Road Show"
    }
    
    let decoder = JSONDecoder()
    var movieResponse: MovieDetails!
    
    override func setUp() {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: Constant.movieList, ofType: Constant.json)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        movieResponse = try! decoder.decode(MovieDetails.self, from: data!)
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberOfmovie() {
        let expectedRows = 10
        guard let searcItem = movieResponse.search else { return }
        XCTAssertEqual(searcItem.count, expectedRows)
    }
    
    func testmovieId() {
        let expectedId = Constant.imdbId
        guard let searcItem = movieResponse.search?.first else { return }
        
        XCTAssertEqual(searcItem.imdbID, expectedId)
    }

}
