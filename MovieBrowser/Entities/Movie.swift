//
//  Movie.swift
//  MovieBrowser
//
//  Created by Sandro Shanshiashvili on 13.11.22.
//

import UIKit

struct Movie: Codable {
    let backdropPath: String?
    let genreIDS: [Int]?
    var image: UIImage = UIImage(named: "poster-preloading")!
    let id: Int?
    let overview: String?
    let originalTitle: String?
    let releaseDate: String?
    let popularity: Double?
    let posterPath: String?
    let duration: Int?
    

    enum CodingKeys: String, CodingKey {
        case id, popularity, overview
        case duration = "runtime"
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
    }
}
