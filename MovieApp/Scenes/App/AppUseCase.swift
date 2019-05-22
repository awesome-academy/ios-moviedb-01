//
//  AppUseCase.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

protocol AppUseCase {
    func getObjects(fileName: String) -> Observable<Results<Genre>>
}

struct AppUseCaseImpl: AppUseCase {
    let realm: RealmRepository
    
    func getObjects(fileName: String) -> Observable<Results<Genre>> {
        return realm.getObjects(fileName: fileName, objType: Genre.self)
    }
}
