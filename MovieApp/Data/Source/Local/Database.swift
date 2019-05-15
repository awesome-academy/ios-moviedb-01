//
//  Database.swift
//  MovieApp
//
//  Created by Phan Dinh Van on 5/21/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import RealmSwift

struct Database {
    static let share = Database()
    
    func getObjects<T: Object>(fileName: String, objType: T.Type) -> Observable<Results<T>> {
        var realmConfig = Realm.Configuration.defaultConfiguration
        if let fileURL = realmConfig.fileURL {
            realmConfig.fileURL = fileURL.deletingLastPathComponent()
                .appendingPathComponent(fileName)
        }
        return Observable<Results<T>>.create { observer -> Disposable in
            do {
                let realm = try Realm(configuration: realmConfig)
                observer.onNext(realm.objects(objType))
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func deleteObject<T: Object>(fileName: String, object: T) -> Observable<Void> {
        var realmConfig = Realm.Configuration.defaultConfiguration
        if let fileURL = realmConfig.fileURL {
            realmConfig.fileURL = fileURL.deletingLastPathComponent()
                .appendingPathComponent(fileName)
        }
        return Observable<Void>.create { observer -> Disposable in
            do {
                let realm = try Realm(configuration: realmConfig)
                try realm.write {
                    realm.delete(object)
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func deleteAll(fileName: String) -> Observable<Void> {
        var realmConfig = Realm.Configuration.defaultConfiguration
        if let fileURL = realmConfig.fileURL {
            realmConfig.fileURL = fileURL.deletingLastPathComponent()
                .appendingPathComponent(fileName)
        }
        return Observable<Void>.create { observer -> Disposable in
            do {
                let realm = try Realm(configuration: realmConfig)
                try realm.write {
                    realm.deleteAll()
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func saveObject<T: Object>(fileName: String, object: T) -> Observable<Void> {
        var realmConfig = Realm.Configuration.defaultConfiguration
        if let fileURL = realmConfig.fileURL {
            realmConfig.fileURL = fileURL.deletingLastPathComponent()
                .appendingPathComponent(fileName)
        }
        return Observable<Void>.create { observer -> Disposable in
            do {
                let realm = try Realm(configuration: realmConfig)
                try realm.write {
                    realm.add(object, update: true)
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func saveObjects<T: Object>(fileName: String, objects: [T]) -> Observable<Void> {
        var realmConfig = Realm.Configuration.defaultConfiguration
        if let fileURL = realmConfig.fileURL {
            realmConfig.fileURL = fileURL.deletingLastPathComponent()
                .appendingPathComponent(fileName)
        }
        return Observable<Void>.create { observer -> Disposable in
            do {
                let realm = try Realm(configuration: realmConfig)
                try realm.write {
                    realm.add(objects, update: true)
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func updateObject(fileName: String, updateFunc: @escaping () -> Void) -> Observable<Void> {
        var realmConfig = Realm.Configuration.defaultConfiguration
        if let fileURL = realmConfig.fileURL {
            realmConfig.fileURL = fileURL.deletingLastPathComponent()
                .appendingPathComponent(fileName)
        }
        return Observable<Void>.create { observer -> Disposable in
            do {
                let realm = try Realm(configuration: realmConfig)
                try realm.write {
                    updateFunc()
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
