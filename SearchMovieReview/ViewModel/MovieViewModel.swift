//
//  MovieViewModel.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation

protocol MovieInformation: class {
    func updateMovieDetails(movieDetails: Any?, error: Error?)
}

struct MovieViewModel {
    //MARK:- Properties
    var movieInfo : MovieDetails?
    weak var movieDelegate: MovieInformation?
    
    func fetchMovieDetails(searchText: String, pageNumber: Int) {
        
        // Fetch data from the API
        NetworkDataLoader().loadResult(with: .fetchMovie(searchText: searchText, pageNumber: pageNumber) , completion: { result in
            switch result {
            case let .success(feedInfo):
                self.movieDelegate?.updateMovieDetails(movieDetails: feedInfo, error: nil)
                // We had handle the error more precisely rather then just printing to console.
            // The specific type of error can generate specific error for the user
            case let .failure(error) :
                self.movieDelegate?.updateMovieDetails(movieDetails: nil, error: error)
            }
        })
    }
}
