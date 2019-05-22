//
//  MovieDisplayCell.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

final class MovieDisplayCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    private func configureCell() {
        posterImageView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10
        }
    }
    
    func bind(viewModel: MovieDisplayItemViewModel) {
        titleLabel.text = viewModel.title
        ratingLabel.text = "\(viewModel.voteAverage ?? 0)/10"
        let processor = DownsamplingImageProcessor(size: posterImageView.frame.size)
            >> RoundCornerImageProcessor(cornerRadius: 10)
        posterImageView.do {
            $0.kf.indicatorType = .activity
            $0.kf.setImage(with: URL(string: "\(URLs.posterApi)\(viewModel.posterPath ?? "")"),
                           placeholder: UIImage(named: "img_placeholder"),
                           options: [.cacheOriginalImage, .processor(processor)])
        }
    }
}
