//
//  GettingStartedViewController.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

final class GettingStartedViewController: UIViewController, AlertViewController, BindableType {
    @IBOutlet private weak var genreListCollectionView: UICollectionView!
    @IBOutlet private weak var doneButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: GettingStartedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configView() {
        let gradientBackground = CAGradientLayer().then {
            $0.frame = view.bounds
            $0.colors = UIColor.gradientGettingStartedBackground
        }
        
        view.do {
            $0.layer.insertSublayer(gradientBackground, at: 0)
        }
        genreListCollectionView.do {
            $0.register(cellType: GettingStartedGenreCell.self)
            $0.rx.setDelegate(self).disposed(by: disposeBag)
        }
        doneButton.do {
            $0.setBorder(borderWidth: 0, borderColor: .white, cornerRadius: 10)
            $0.backgroundColor = UIColor.gettingStartedButton
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    func bindViewModel() {
        let input = GettingStartedViewModel.Input(loadTrigger: Driver.just(()),
                                                  selectTrigger: genreListCollectionView.rx.itemSelected.asDriver(),
                                                  doneButtonTrigger: doneButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        output.genres
            .drive(genreListCollectionView.rx.items) { collectionView, index, genre in
                let indexPath = IndexPath(row: index, section: 0)
                let cell: GettingStartedGenreCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.bind(viewModel: GenreItemViewModel(genre: genre))
                return cell
            }
            .disposed(by: disposeBag)
        
        output.selected
            .drive(selectCellBinding)
            .disposed(by: disposeBag)
        
        output.doneButton
            .drive()
            .disposed(by: disposeBag)
        
        output.isDoneButtonEnabled
            .drive(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.indicator
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)
    }
    
    var selectCellBinding: Binder<IndexPath> {
        return Binder(self.genreListCollectionView) { (collectionView, indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
            if let cell = self.genreListCollectionView.cellForItem(at: indexPath) as? GettingStartedGenreCell {
                cell.toggleState()
            }
        }
    }
}

extension GettingStartedViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.gettingStarted
}

extension GettingStartedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 32) / 2
        return CGSize(width: cellWidth, height: 50)
    }
}
