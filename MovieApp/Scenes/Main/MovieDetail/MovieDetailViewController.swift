//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher

final class MovieDetailViewController: UIViewController, AlertViewController, BindableType {
    @IBOutlet private weak var trailerWebView: WKWebView!
    @IBOutlet private weak var titleMovieLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var mainActorCollectionView: UICollectionView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var overviewView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: MovieDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configView() {
        mainActorCollectionView.do {
            $0.register(cellType: ActorCell.self)
            $0.rx.setDelegate(self).disposed(by: disposeBag)
        }
        backButton.do {
            $0.tintColor = .white
            $0.setImage(UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        trailerWebView.isOpaque = false
        [titleView, overviewView].forEach {
            $0?.addBottomBorderWithColor(color: .lightGray, width: 1)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentView.do {
            $0.roundCorners([.topRight, .topLeft], radius: 50)
        }
    }
    
    func bindViewModel() {
        let input = MovieDetailViewModel.Input(loadTrigger: Driver.just(()),
                                               actorSelectTrigger: mainActorCollectionView.rx.itemSelected.asDriver(),
                                               likeTrigger: likeButton.rx.tap.asDriver(),
                                               backTrigger: backButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.cast
            .drive(mainActorCollectionView.rx.items) { collectionView, index, cast in
                let indexPath = IndexPath(row: index, section: 0)
                let cell: ActorCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.bind(viewModel: ActorItemViewModel(cast: cast))
                return cell
            }
            .disposed(by: disposeBag)
        
        output.backgroundImage
            .drive(backgroundImage)
            .disposed(by: disposeBag)
        
        output.titleMovie
            .drive(titleMovieLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.voteAverage
            .drive(ratingLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.movieOverview
            .drive(overviewLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.liked
            .drive(likedMovie)
            .disposed(by: disposeBag)
        
        output.likeTapped
            .drive(likeButtonTapped)
            .disposed(by: disposeBag)
        
        output.trailer
            .drive(loadTrailer)
            .disposed(by: disposeBag)
        
        output.actorSelected
            .drive()
            .disposed(by: disposeBag)
        
        output.backTapped
            .drive()
            .disposed(by: disposeBag)
        
        output.indicator
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)
    }
    
    var loadTrailer: Binder<[Video]> {
        return Binder(self) { (viewController, videos) in
            guard !videos.isEmpty else { return }
            if let url = URL(string: URLs.youtubeEmbed + "/\(videos[0].key)") {
                let request = URLRequest(url: url)
                viewController.do {
                    $0.trailerWebView.load(request)
                }
            }
        }
    }
    
    var likeButtonTapped: Binder<Void> {
        return Binder(self) { (viewController, _) in
            let currentImage = viewController.likeButton.currentImage == UIImage(named: "ic_like") ?
                UIImage(named: "ic_unlike") :
                UIImage(named: "ic_like")
            viewController.likeButton.setImage(currentImage, for: .normal)
        }
    }
    
    var likedMovie: Binder<Bool> {
        return Binder(self) { (viewController, liked) in
            let currentImage = liked ? UIImage(named: "ic_like") : UIImage(named: "ic_unlike")
            viewController.likeButton.setImage(currentImage, for: .normal)
        }
    }
    
    var backgroundImage: Binder<URL?> {
        return Binder(self) { (vc, url) in
            guard let url = url else { return }
            KingfisherManager.shared.retrieveImage(with: url, completionHandler: { (result) in
                switch result {
                case .success(let value):
                    vc.view.backgroundColor = UIColor(patternImage: value.image)
                case .failure(let error):
                    vc.showErrorAlert(message: error.errorDescription)
                }
            })
        }
    }
}

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.height
        let width = collectionView.bounds.width / 3
        return CGSize(width: width, height: size)
    }
}
