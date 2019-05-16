//
//  MovieListCell.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

final class MovieListCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    func setContent(movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.voteAverage)/10"
        let processor = DownsamplingImageProcessor(size: posterImageView.frame.size)
            >> RoundCornerImageProcessor(cornerRadius: 10)
        posterImageView.do {
            $0.kf.indicatorType = .activity
            $0.kf.setImage(with: URL(string: "\(URLs.posterApi)\(movie.posterPath)"), placeholder: UIImage(named: "img_placeholder"), options: [.cacheOriginalImage, .processor(processor)])
        }
    }
}
