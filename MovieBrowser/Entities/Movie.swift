//
//  Movie.swift
//  MovieBrowser
//
//  Created by Sandro Shanshiashvili on 13.11.22.
//

import Foundation





struct Movie: Codable {
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalTitle: String?
    let popularity: Double?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id, popularity
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
    }
}
