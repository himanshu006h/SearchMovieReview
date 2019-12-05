//
//  MovieDetails.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation
struct MovieDetails : Codable {
	let search : [Search]?
	let totalResults : String?
	let response : String?

	enum CodingKeys: String, CodingKey {

		case search = "Search"
		case totalResults = "totalResults"
		case response = "Response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		search = try values.decodeIfPresent([Search].self, forKey: .search)
		totalResults = try values.decodeIfPresent(String.self, forKey: .totalResults)
		response = try values.decodeIfPresent(String.self, forKey: .response)
	}

}
