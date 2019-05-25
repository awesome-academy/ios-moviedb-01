//
//  SearchMovieViewController.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

final class SearchMovieViewController: UIViewController, AlertViewController, BindableType {
    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var movieTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var backButton: UIButton!
    
    var viewModel: SearchMovieViewModel!
    private var pagingViewModel: PagingViewModel!
    private var pagingView: PagingView!
    private let disposeBag = DisposeBag()
    private var selectedGenres = BehaviorRelay<[Genre]>(value: [])
    
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
        let gradientBackground = CAGradientLayer().then {
            $0.frame = view.bounds
            $0.colors = UIColor.gradientBackground
        }
        view.do {
            $0.layer.insertSublayer(gradientBackground, at: 0)
        }
        pagingViewModel = PagingViewModel()
        pagingView = PagingView().then {
            $0.frame = CGRect(x: 0, y: 0, width: movieTableView.frame.width, height: 80)
        }
        searchBar.do {
            $0.setSerchTextcolor(color: .white)
        }
        genreCollectionView.do {
            $0.register(cellType: GenreCell.self)
        }
        if let flowLayout = genreCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        movieTableView.do {
            $0.register(cellType: SearchMovieCell.self)
            $0.rowHeight = 150
            $0.tableFooterView = UIView()
        }
        backButton.do {
            $0.tintColor = .white
            $0.setImage(UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        genreCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func bindViewModel() {
        let input = SearchMovieViewModel.Input(loadTrigger: Driver.just(()),
                                               pageTrigger: pagingView.bind(viewModel: pagingViewModel),
                                               searchTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                               genreSelectTrigger: genreCollectionView.rx.itemSelected.asDriver(),
                                               movieSelectTrigger: movieTableView.rx.itemSelected.asDriver(),
                                               backTrigger: backButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        output.genres
            .drive(genreCollectionView.rx.items) { collectionView, index, genre in
                let indexPath = IndexPath(row: index, section: 0)
                let cell: GenreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.bind(viewModel: GenreItemViewModel(genre: genre))
                cell.updateCell(isSelected: self.selectedGenres.value[indexPath.row].selected)
                return cell
            }
            .disposed(by: disposeBag)
        output.movies
            .drive(movieTableView.rx.items) { tableView, index, movie in
                let indexPath = IndexPath(row: index, section: 0)
                let cell: SearchMovieCell = tableView.dequeueReusableCell(for: indexPath)
                cell.bind(viewModel: SearchMovieItemViewModel(movie: movie))
                return cell
            }
            .disposed(by: disposeBag)
        output.genreSelected
            .drive(selectCellBinding)
            .disposed(by: disposeBag)
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)
        output.indicator
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
        output.selectGenres
            .drive()
            .disposed(by: disposeBag)
        output.selectMovie
            .drive(deselectCellBinding)
            .disposed(by: disposeBag)
        output.totalPages
            .drive(pagingBinding)
            .disposed(by: disposeBag)
        output.seletedGenres
            .drive(selectGenres)
            .disposed(by: disposeBag)
        output.search
            .drive()
            .disposed(by: disposeBag)
        output.back
            .drive()
            .disposed(by: disposeBag)
        output.paging
            .drive()
            .disposed(by: disposeBag)
    }
    
    var selectCellBinding: Binder<IndexPath> {
        return Binder(self.genreCollectionView) { collectionView, indexPath in
            collectionView.deselectItem(at: indexPath, animated: false)
            if let cell = collectionView.cellForItem(at: indexPath) as? GenreCell {
                cell.toggleState()
            }
        }
    }
    
    var selectGenres: Binder<[Genre]> {
        return Binder(self) { vc, selectedGenres in
            vc.selectedGenres.accept(selectedGenres)
        }
    }
    
    var pagingBinding: Binder<Int> {
        return Binder(self) { vc, totalPages in
            if totalPages > 0 {
                vc.pagingViewModel.update(totalPages: totalPages)
                vc.movieTableView.tableFooterView = vc.pagingView
            } else {
                vc.movieTableView.tableFooterView = UIView()
            }
        }
    }
    
    var deselectCellBinding: Binder<IndexPath> {
        return Binder(self.movieTableView) { tableView, indexPath in
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension SearchMovieViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
