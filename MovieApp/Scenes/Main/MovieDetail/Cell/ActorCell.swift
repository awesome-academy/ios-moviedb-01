//
//  ActorCell.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Kingfisher

final class ActorCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var profileName: UILabel!
    
    func bind(viewModel: ActorItemViewModel) {
        profileName.text = viewModel.actorName
        let imageUrl = URL(string: URLs.posterApi + (viewModel.profilePath ?? ""))
        profileImage.do {
            let processor = DownsamplingImageProcessor(size: profileImage.frame.size)
                >> RoundCornerImageProcessor(cornerRadius: 10)
            $0.kf.indicatorType = .activity
            $0.kf.setImage(with: imageUrl,
                           placeholder: UIImage(named: "default_profile"),
                           options: [.cacheOriginalImage, .processor(processor)])
        }
    }
}
