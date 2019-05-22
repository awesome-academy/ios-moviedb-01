//
//  MainViewController.swift
//  MovieApp
//
//  Created by nguyen.nam.khanh on 5/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class MainViewController: UIViewController {
    private enum LayoutOptions {
        static let movieDisplayHeight = 350
        static let movieDisplayWidth = 200
        static let offSet: CGFloat = 300
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var homeExtensionButton: UIButton!
    @IBOutlet private weak var upcommingCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: MainViewModel!
    private let movieRepository: MovieRepository  = MovieRepositoryImpl(api: APIService.share)
    private let popularLoadMoreTrigger = PublishSubject<Void>()
    private let upcommingLoadMoreTrigger = PublishSubject<Void>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindViewModel()
    }
    
    private func configureView() {
        collectionView.do {
            $0.register(cellType: MovieDisplayCell.self)
            $0.rx.setDelegate(self).disposed(by: disposeBag)
        }
        upcommingCollectionView.do {
            $0.register(cellType: MovieDisplayCell.self)
            $0.rx.setDelegate(self).disposed(by: disposeBag)
        }
        logoImageView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = $0.layer.frame.width/2
        }
    }
    
    func bindViewModel() {
        let navigator = DefaultMainNavigator(navigationController: self.navigationController)
        viewModel =  MainViewModel(movieRepository: movieRepository, navigator: navigator)
        
        let input =  MainViewModel.Input(popularLoadMoreTrigger: popularLoadMoreTrigger.asDriverOnErrorJustComplete(),
                                         upcommingLoadMoreTrigger: upcommingLoadMoreTrigger.asDriverOnErrorJustComplete(),
                                         popularSelectTrigger: collectionView.rx.itemSelected.asDriver(),
                                         upcommingSelectTrigger: upcommingCollectionView.rx.itemSelected.asDriver(),
                                         searchButtonTrigger: searchButton.rx.tap.asDriver(),
                                         homeExtensionButtonTrigger: homeExtensionButton.rx.tap.asDriver(),
                                         loaded: Driver.just(()))
            let output = viewModel.transform(input: input)
        output.popularMovies
            .drive(collectionView.rx.items) { cv, index, movie in                
                let indexPath = IndexPath(row: index, section: 0)
                let cell: MovieDisplayCell = cv.dequeueReusableCell(for: indexPath)
                cell.setContent(movie: movie)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.upcommingMovies
            .drive(upcommingCollectionView.rx.items) { cv, index, movie in
                let indexPath = IndexPath(row: index, section: 0)
                let cell: MovieDisplayCell = cv.dequeueReusableCell(for: indexPath)
                cell.setContent(movie: movie)
                return cell
            }
            .disposed(by: disposeBag)
        
        output.indicator
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.searchAction
            .drive()
            .disposed(by: disposeBag)
        
        output.homeAction
            .drive()
            .disposed(by: disposeBag)
        
        output.popularLoaded
            .drive()
            .disposed(by: disposeBag)        
        
        output.upcommingLoaded
            .drive()
            .disposed(by: disposeBag)
        
        output.popularLoadMore
            .drive()
            .disposed(by: disposeBag)
        
        output.upcommingLoadMore
            .drive()
            .disposed(by: disposeBag)
        
        output.popularSelected
            .drive()
            .disposed(by: disposeBag)
        
        output.upcommingSelected
            .drive()
            .disposed(by: disposeBag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let bottomEdge = scrollView.contentOffset.x + scrollView.frame.size.width
            if (bottomEdge + LayoutOptions.offSet >= scrollView.contentSize.width) {
                scrollView == collectionView ? popularLoadMoreTrigger.onNext() : upcommingLoadMoreTrigger.onNext()
            }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        
        return CGSize(width: LayoutOptions.movieDisplayWidth, height: LayoutOptions.movieDisplayHeight)
    }
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
