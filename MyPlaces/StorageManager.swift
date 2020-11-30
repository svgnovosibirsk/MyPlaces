//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Sergey Golovin on 30.11.2020.
//  Copyright © 2020 GoldenWindGames LLC. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deliteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
    
}
