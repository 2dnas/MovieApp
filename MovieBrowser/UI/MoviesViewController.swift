//
//  MoviesViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class MoviewViewController: UIViewController {
    let imageBaseURL = "https://image.tmdb.org/t/p/w500/"

    let genre: Genre!
    var movies = [Movie]()
    var currentPage : Int = 2
    var isLoadingList = false
    
    private var MoviesProvider: MoviesProvider
    
    private let tableView = UITableView()
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
        prepareUI()
        getMovies(page: "1")

    }
    
    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        prepareActivityIndicator()
    }
    
    
    private func prepareRootView() {
        view.backgroundColor = .white
        title = genre.name
    }
    
    private func prepareTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
    }
    
    private func prepareActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
    }
    
    // The Api doesn't provide functionality to set limit for a movie per page.
    // There is 20 movie per page so I made 3 request and show first 50 as requested in task.
    private func getMovies(page: String) {
        activityIndicator.startAnimating()
        let genreID = String(genre.id)
        
        MoviesProvider.getMovies(genre: genreID ,page: page) { [weak self] result in
            switch result {
            case .success(let result):
                self?.movies += result
                DispatchQueue.main.async {
                    self?.MoviesProvider.getMovieDuration(movies: self?.movies ?? [], completion: { movie in
                        self?.movies = movie
                        self?.tableView.reloadData()
                    })
                    self?.tableView.reloadData()
                    self?.isLoadingList = false
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("couldn't fetch movies with error \(error)")
            }
        }
    }
}


//There wasn't limit query option in Api. per page was 20 movie item I Had two option
//So I had to make first 3 page calls manually and filter first 50 from the list
//I thought it was bad idea and made paging.
extension MoviewViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
               self.isLoadingList = true
               let page = String(currentPage)
               self.getMovies(page: page)
               currentPage += 1
           }
       }
}


extension MoviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.configure(model: movies[indexPath.row])
        MoviesProvider.fetchImageForCell(cell: cell, indexPath: indexPath, movies: movies)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}



