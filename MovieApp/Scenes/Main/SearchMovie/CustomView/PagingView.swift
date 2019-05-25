//
//  PagingView.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/22/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

final class PagingView: UIView, NibOwnerLoadable {
    @IBOutlet private weak var firstPageButton: UIButton!
    @IBOutlet private weak var lastPageButton: UIButton!
    @IBOutlet private weak var prevPageButton: UIButton!
    @IBOutlet private weak var nextPageButton: UIButton!
    @IBOutlet private weak var pageOneButton: UIButton!
    @IBOutlet private weak var pageTwoButton: UIButton!
    @IBOutlet private weak var pageThreeButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var viewModel: PagingViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    
    private func configView() {
        loadNibContent()
        [firstPageButton,
         lastPageButton,
         prevPageButton,
         nextPageButton,
         pageOneButton,
         pageTwoButton,
         pageThreeButton].forEach {
            $0?.setBorder(borderWidth: 1, borderColor: .white, cornerRadius: 0)
        }
    }
    
    func bind(viewModel: PagingViewModel) -> Driver<Int> {
        self.viewModel = viewModel
        let input = PagingViewModel.Input(loadTrigger: Driver.just(()),
                                          firstPageTrigger: firstPageButton.rx.tap.asDriver(),
                                          lastPageTrigger: lastPageButton.rx.tap.asDriver(),
                                          prevPageTrigger: prevPageButton.rx.tap.asDriver(),
                                          nextPageTrigger: nextPageButton.rx.tap.asDriver(),
                                          pageOneTrigger: pageOneButton.rx.tap.asDriver(),
                                          pageTwoTrigger: pageTwoButton.rx.tap.asDriver(),
                                          pageThreeTrigger: pageThreeButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
        output.firstPage
            .drive()
            .disposed(by: disposeBag)
        output.lastPage
            .drive()
            .disposed(by: disposeBag)
        output.prevPage
            .drive()
            .disposed(by: disposeBag)
        output.nextPage
            .drive()
            .disposed(by: disposeBag)
        output.pageOne
            .drive()
            .disposed(by: disposeBag)
        output.pageTwo
            .drive()
            .disposed(by: disposeBag)
        output.pageThree
            .drive()
            .disposed(by: disposeBag)
        output.isPageTwoHidden
            .drive(pageTwoButton.rx.isHidden)
            .disposed(by: disposeBag)
        output.isPageThreeHidden
            .drive(pageThreeButton.rx.isHidden)
            .disposed(by: disposeBag)
        output.pageOneButton
            .drive(pageOneButton.rx.title())
            .disposed(by: disposeBag)
        output.pageTwoButton
            .drive(pageTwoButton.rx.title())
            .disposed(by: disposeBag)
        output.pageThreeButton
            .drive(pageThreeButton.rx.title())
            .disposed(by: disposeBag)
        output.currentPage
            .drive(hightlighCurrentPage)
            .disposed(by: disposeBag)
        return output.currentPage
    }
    
    var hightlighCurrentPage: Binder<Int> {
        return Binder(self) { view, currentPage in
            [view.pageOneButton, view.pageTwoButton, view.pageThreeButton].forEach {
                $0.backgroundColor = .lightGray
            }
            let index = currentPage % 3
            switch index {
            case 0:
                view.pageThreeButton.backgroundColor = .darkGray
            case 1:
                view.pageOneButton.backgroundColor = .darkGray
            case 2:
                view.pageTwoButton.backgroundColor = .darkGray
            default:
                view.pageOneButton.backgroundColor = .darkGray
            }
        }
    }
}
