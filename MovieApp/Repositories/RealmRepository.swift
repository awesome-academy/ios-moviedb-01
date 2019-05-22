//
//  RealmRepository.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

protocol RealmRepository {
    func getObjects<T: Object>(fileName: String, objType: T.Type) -> Observable<Results<T>>
    func deleteObject<T: Object>(fileName: String, object: T) -> Observable<Void>
    func deleteAll(fileName: String) -> Observable<Void>
    func saveObject<T: Object>(fileName: String, object: T) -> Observable<Void>
    func saveObjects<T: Object>(fileName: String, objects: [T]) -> Observable<Void>
    func updateObject(fileName: String, updateFunc: @escaping () -> Void) -> Observable<Void>
}

final class RealmRepositoryImpl: RealmRepository {
    private let database = Database.share
    
    func getObjects<T>(fileName: String, objType: T.Type) -> Observable<Results<T>> where T : Object {
        return database.getObjects(fileName: fileName, objType: objType)
    }
    
    func deleteObject<T>(fileName: String, object: T) -> Observable<Void> where T : Object {
        return database.deleteObject(fileName: fileName, object: object)
    }
    
    func deleteAll(fileName: String) -> Observable<Void> {
        return database.deleteAll(fileName: fileName)
    }
    
    func saveObject<T>(fileName: String, object: T) -> Observable<Void> where T : Object {
        return database.saveObject(fileName: fileName, object: object)
    }
    
    func saveObjects<T: Object>(fileName: String, objects: [T]) -> Observable<Void> {
        return database.saveObjects(fileName: fileName, objects: objects)
    }
    
    func updateObject(fileName: String, updateFunc: @escaping () -> Void) -> Observable<Void> {
        return database.updateObject(fileName: fileName, updateFunc: updateFunc)
    }
}
