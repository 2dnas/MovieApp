//
//  MoviesProvider.swift
//  MovieBrowser
//
//  Created by Sandro Shanshiashvili on 13.11.22.
//


import UIKit


final class MoviesProvider {
    
    private struct Constants {
        static let imageBaseURL = "https://image.tmdb.org/t/p/w500"

    }
   
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
    
    //I know its not good solution to handle UI related task in provider
    //but I dont know better solution for task like this :D
    //If I don't do something like that when scrolling tableview fast posters are innacurate
    func fetchImageForCell(cell: MovieCell, indexPath: IndexPath, movies: [Movie]) {
        cell.tag = indexPath.row
        let imageURL = URL(string: Constants.imageBaseURL)!.appending(path: movies[indexPath.row].posterPath ?? "")
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                if cell.tag == indexPath.row{
                    let image = UIImage(data: data)
                    cell.setPoster(image: image ?? UIImage(named: "poster-preloading")!)
                }
            }
        }
        task.resume()
    }
    
    func getMovieDuration(movies: [Movie], completion: ([Movie]) -> Void) {
        let dispachGroup = DispatchGroup()
        var movieArray = [Movie]()
        for movie in movies {
            dispachGroup.enter()
            guard let id = movie.id else { continue }
            self.apiManager.makeRequest(request: ApiRequest(endpoint: "/movie/\(id)")) { (response: Result<Movie,Error>) in
                switch response {
                case .success(let movie):
                    movieArray.append(movie)
                    dispachGroup.leave()
                case .failure(let error):
                    print("Error happened while fetching durations with error \(error)")
                    dispachGroup.leave()
                }
            }
        }
        dispachGroup.wait()
        completion(movieArray)
    }
}

private struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
        
}


extension MoviesProvider {
    enum MovieError: Error {
        case ImageFetchError
    }
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



