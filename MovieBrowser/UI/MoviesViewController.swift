//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviewViewController: UIViewController {
    let genre: Genre!
    var movies = [Movie]()
    
    private var MoviesProvider: MoviesProvider
    
    private let activityIndicator = UIActivityIndicatorView()

    
    init(genre: Genre, movieProvider: MoviesProvider ) {
        self.genre = genre
        self.MoviesProvider = movieProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        title = genre.name
        getMovies(page: "1")
    }
    
    // The Api doesn't provide functionality to set limit for a movie per page.
    // There is 20 movie per page so I made 3 request and show first 50 as requested in task.
    
    private func getMovies(page: String) {
        activityIndicator.startAnimating()
        let genreID = String(genre.id)
        
        MoviesProvider.getMovies(genre: genreID ,page: page) { [weak self] result in
            switch result {
            case .success(let result):
                self?.movies = result
            case .failure(let error):
                print("couldn't fetch movies with error \(error)")
            }
        }
    }
}
