//
//  SearchMovieCell.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Kingfisher

final class SearchMovieCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(viewModel: SearchMovieItemViewModel) {
        movieTitleLabel.do {
            $0.text = viewModel.title
        }
        ratingLabel.do {
            $0.text = "\(viewModel.voteAverage ?? 0)/10"
        }
        releaseDateLabel.do {
            $0.text = viewModel.releaseDate
        }
        let imageUrl = URL(string: URLs.posterApi + (viewModel.posterPath ?? ""))
        posterImage.do {
            let processor = DownsamplingImageProcessor(size: posterImage.frame.size)
                >> RoundCornerImageProcessor(cornerRadius: 10)
            $0.kf.indicatorType = .activity
            $0.kf.setImage(with: imageUrl,
                           placeholder: UIImage(),
                           options: [.cacheOriginalImage, .processor(processor)])
        }
    }
}
