//
//  PagingViewModel.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/23/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

final class PagingViewModel: ViewModelType {
    private var currentPage = BehaviorRelay<Int>(value: 1)
    private var totalPages = BehaviorRelay<Int>(value: 1)
    
    func update(totalPages: Int) {
        self.totalPages.accept(totalPages)
        self.currentPage.accept(1)
    }
    
    func transform(input: PagingViewModel.Input) -> PagingViewModel.Output {
        let isPageThreeHidden = currentPage
            .asDriver()
            .map({ currentPage -> Bool in
                return (Int(currentPage / 3) == Int(self.totalPages.value / 3) &&
                    (currentPage % 3 != 0) &&
                    self.totalPages.value % 3 != 0) ||
                    (self.totalPages.value < 3)
            })
        
        let isPageTwoHidden = currentPage
            .asDriver()
            .map({ currentPage -> Bool in
                return (Int(currentPage / 3) == Int(self.totalPages.value / 3) &&
                    (currentPage % 3 != 0) &&
                    self.totalPages.value % 3 == 1) ||
                    (self.totalPages.value < 3)
            })
        
        let firstPage = input.firstPageTrigger
            .withLatestFrom(currentPage.asDriver()) { _, currentPage in
                if currentPage != 1 {
                    self.currentPage.accept(1)
                }
            }
        let lastPage = input.lastPageTrigger
            .withLatestFrom(currentPage.asDriver()) { _, currentPage in
                if currentPage != self.totalPages.value {
                    self.currentPage.accept(self.totalPages.value)
                }
            }
        let prevPage = input.prevPageTrigger
            .withLatestFrom(currentPage.asDriver()) { _, currentPage in
                if currentPage > 1 {
                    self.currentPage.accept(currentPage - 1)
                }
            }
        let nextPage = input.nextPageTrigger
            .withLatestFrom(currentPage.asDriver()) { _, currentPage in
                if currentPage < self.totalPages.value {
                    self.currentPage.accept(currentPage + 1)
                }
            }
        let pageOne = input.pageOneTrigger
            .withLatestFrom(currentPage.asDriver()) { _, currentPage in
                let index = Int(currentPage / 3)
                let page = currentPage == 3 * index ? 3 * (index - 1) + 1 : 3 * index + 1
                if currentPage != page {
                   self.currentPage.accept(page)
                }
            }
        let pageTwo = input.pageTwoTrigger
            .withLatestFrom(currentPage.asDriver()) { _, currentPage in
                let index = Int(currentPage / 3)
                let page = currentPage == 3 * index ? 3 * (index - 1) + 2 : 3 * index + 2
                if currentPage != page {
                    self.currentPage.accept(page)
                }
            }
        let pageThree = input.pageThreeTrigger
            .withLatestFrom(currentPage.asDriver()) { _, currentPage in
                let index = Int(currentPage / 3)
                let page = currentPage == 3 * index ? 3 * (index - 1) + 3 : 3 * index + 3
                if currentPage != page {
                    self.currentPage.accept(page)
                }
            }
        let pageOneButton = currentPage
            .asDriver()
            .map { currentPage -> String in
                let index = Int(currentPage / 3)
                return currentPage == 3 * index ? String (3 * (index - 1) + 1) : String(3 * index + 1)
            }
        
        let pageTwoButton = currentPage
            .asDriver()
            .map { currentPage -> String in
                let index = Int(currentPage / 3)
                return currentPage == 3 * index ? String (3 * (index - 1) + 2) : String(3 * index + 2)
            }
        let pageThreeButton = currentPage
            .asDriver()
            .map { currentPage -> String in
                let index = Int(currentPage / 3)
                return currentPage == 3 * index ? String (3 * (index - 1) + 3) : String(3 * index + 3)
            }
        return Output(firstPage: firstPage,
                      lastPage: lastPage,
                      prevPage: prevPage,
                      nextPage: nextPage,
                      pageOne: pageOne,
                      pageTwo: pageTwo,
                      pageThree: pageThree,
                      currentPage: currentPage.asDriver(),
                      pageOneButton: pageOneButton,
                      pageTwoButton: pageTwoButton,
                      pageThreeButton: pageThreeButton,
                      isPageTwoHidden: isPageTwoHidden,
                      isPageThreeHidden: isPageThreeHidden)
    }
}

extension PagingViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let firstPageTrigger: Driver<Void>
        let lastPageTrigger: Driver<Void>
        let prevPageTrigger: Driver<Void>
        let nextPageTrigger: Driver<Void>
        let pageOneTrigger: Driver<Void>
        let pageTwoTrigger: Driver<Void>
        let pageThreeTrigger: Driver<Void>
    }
    
    struct Output {
        let firstPage: Driver<Void>
        let lastPage: Driver<Void>
        let prevPage: Driver<Void>
        let nextPage: Driver<Void>
        let pageOne: Driver<Void>
        let pageTwo: Driver<Void>
        let pageThree: Driver<Void>
        let currentPage: Driver<Int>
        let pageOneButton: Driver<String>
        let pageTwoButton: Driver<String>
        let pageThreeButton: Driver<String>
        let isPageTwoHidden: Driver<Bool>
        let isPageThreeHidden: Driver<Bool>
    }
}
