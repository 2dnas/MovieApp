//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

final class GenresViewController: UIViewController {
    private enum Constants {
        static let cellId = "GenresCell"
        static let title = "Genres"
    }

    private let genresProvider: GenresProvider
    private let MoviesProvider: MoviesProvider

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()

    private var genres = [Genre]()

    init(genresProvider: GenresProvider,moviesProvider: MoviesProvider) {
        self.genresProvider = genresProvider
        self.MoviesProvider = moviesProvider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        getGenres()
    }

    private func prepareUI() {
        prepareRootView()
        prepareTableView()
        prepareActivityIndicator()
    }

    private func prepareRootView() {
        title = Constants.title
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)
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

    private func getGenres() {
        activityIndicator.startAnimating()

        genresProvider.getGenres { [weak self] result in
            switch result {
            case let .success(genres):
                self?.genres = genres
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                }
            case let .failure(error):
                print("Cannot get genres, reason: \(error)")
            }
        }
    }
    
    private func presentMovieController(genre: Genre) {
        let movieController = MoviewViewController(genre: genre,movieProvider: MoviesProvider)
        navigationController?.pushViewController(movieController, animated: true)
    }
}

extension GenresViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let content = cell?.contentView as? UIListContentView
        let configuration = content?.configuration as? UIListContentConfiguration
        if let text = configuration?.text {
            let genre = genres.first {
                $0.name == text
            }
            presentMovieController(genre: genre ?? Genre(id: 1, name: ""))
        }
    }
}

extension GenresViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = genres[indexPath.row].name
        cell.contentConfiguration = configuration
        return cell
    }
}
