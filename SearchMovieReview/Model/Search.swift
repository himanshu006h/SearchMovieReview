//
//  Search.swift
//  SearchMovieReview
//
//  Created by Himanshu Saraswat on 05/12/19.
//  Copyright © 2019 Himanshu Saraswat. All rights reserved.
//

import Foundation
struct Search : Codable {
	let title : String?
	let year : String?
	let imdbID : String?
	let type : String?
	let poster : String?

	enum CodingKeys: String, CodingKey {

		case title = "Title"
		case year = "Year"
		case imdbID = "imdbID"
		case type = "Type"
		case poster = "Poster"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		year = try values.decodeIfPresent(String.self, forKey: .year)
		imdbID = try values.decodeIfPresent(String.self, forKey: .imdbID)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		poster = try values.decodeIfPresent(String.self, forKey: .poster)
	}

}
