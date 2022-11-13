//
//  MoviesProvider.swift
//  MovieBrowser
//
//  Created by Sandro Shanshiashvili on 13.11.22.
//

import Foundation


final class MoviesProvider {
   
    private let apiManager: ApiManager!
    
    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }
    
    func getMovies(genre: String, page: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        apiManager.makeRequest(request: ApiRequest(endpoint: "/discover/movie",
                                                   params: [
                                                    URLQueryItem(name: ParamsKey.sortBy.rawValue, value: ParamsValue.descending.rawValue),
                                                    URLQueryItem(name: ParamsKey.genre.rawValue, value: genre),
                                                    URLQueryItem(name: ParamsKey.page.rawValue, value: page)
                                                   ]))
        { (response: Result<MoviesResponse, Error>) in
            switch response {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
        
}

                               
            
extension MoviesProvider {
    private enum ParamsKey: String {
        case page = "page"
        case sortBy = "sort_by"
        case genre = "with_genres"
    }
    
    private enum ParamsValue: String {
        case descending = "popularity.desc"
        case ascending = "popularity.asc"
    }
}
