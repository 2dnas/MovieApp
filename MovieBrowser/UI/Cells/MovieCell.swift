//
//  MovieCell.swift
//  MovieBrowser
//
//  Created by Sandro Shanshiashvili on 14.11.22.
//

import UIKit


final class MovieCell: UITableViewCell {
    typealias Colors = MovieCell.MovieColors
    let placeHolderImage = UIImage(named: "poster-preloading")!
    let movieTimeFormatter = MovieTimeFormatter()
    
    static let identifier = "MovieCell"
    
    
    override func prepareForReuse() {
        movieTitleLabel.text = ""
        movieReleaseYearLabel.text = ""
        moviePoster.image = placeHolderImage
    }
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.titleColor
        label.textAlignment = .left
        return label
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Colors.descriptionColor
        label.textAlignment = .left
        return label
    }()
    
    private let movieReleaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.releaseYearColor
        label.textAlignment = .left
        return label
    }()
    
    private let movieDuration: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.durationColor
        label.textAlignment = .left
        return label
    }()
    
    private let movieDurationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Shape"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var moviePoster: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 118, height: 167))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "poster-preloading")
        imageView.image = image
        imageView.layer.cornerRadius = 13
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        setupPoster()
        setupTitle()
        setupReleaseYear()
        setupDurationIcon()
        setupDescriptionLabel()
        setupDurationLabel()
    }
    
    func configure(model: Movie) {
        movieTitleLabel.text = model.originalTitle
        movieReleaseYearLabel.text = movieTimeFormatter.getOnlyYearFromDate(date: model.releaseDate)
        movieDescriptionLabel.text = model.overview
        movieDuration.text = movieTimeFormatter.minutesToHours(minutes: model.duration ?? 0)
    }
    
    func setPoster(image: UIImage) {
        moviePoster.alpha = 0
        UIView.animate(withDuration: 2) {
            self.moviePoster.alpha = 1.0
        }
        moviePoster.image = image
    }
    
    private func setupPoster() {
        addSubview(moviePoster)
        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            moviePoster.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            moviePoster.widthAnchor.constraint(equalToConstant: 118),
            moviePoster.heightAnchor.constraint(equalToConstant: 167)
        ])
    }
    
    
    private func setupTitle() {
        addSubview(movieTitleLabel)
        NSLayoutConstraint.activate([
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 16),
            movieTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupReleaseYear() {
        addSubview(movieReleaseYearLabel)
        NSLayoutConstraint.activate([
            movieReleaseYearLabel.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 16),
            movieReleaseYearLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 8),
            movieReleaseYearLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupDurationIcon() {
        addSubview(movieDurationIcon)
        NSLayoutConstraint.activate([
            movieDurationIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            movieDurationIcon.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 16)
        ])
    }
    
    private func setupDescriptionLabel() {
        addSubview(movieDescriptionLabel)
        NSLayoutConstraint.activate([
            movieDescriptionLabel.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 16),
            movieDescriptionLabel.topAnchor.constraint(equalTo: movieReleaseYearLabel.bottomAnchor, constant: 8),
            movieDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            movieDescriptionLabel.bottomAnchor.constraint(equalTo: movieDurationIcon.topAnchor, constant: -16)
        ])
    }
    
    private func setupDurationLabel() {
        addSubview(movieDuration)
        NSLayoutConstraint.activate([
            movieDuration.leadingAnchor.constraint(equalTo: movieDurationIcon.trailingAnchor, constant: 8),
            movieDuration.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 15)
        ])
    }
    
}


extension MovieCell {
    struct MovieColors {
        static let titleColor = UIColor(red: 29/255, green: 34/255, blue: 56/255, alpha: 1.0)
        static let descriptionColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        static let releaseYearColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
        static let durationColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1.0)
    }
}

