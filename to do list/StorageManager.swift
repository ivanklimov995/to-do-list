//
//  StorageManager.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import Foundation
import RealmSwift

// чухня, чтобы сохранять в память, чисто логика - по идее можно пиздить и будет везде работать

let realm = try! Realm ()

class StoragemManager{
    
    static func  saveObject(_ newNotes: Notes){
        try! realm.write({
            realm.add(newNotes)
        })
    }
    
    static func deleteObgect(_ notes: Notes){
        try! realm.write({
            realm.delete(notes)
        })
    }
}

