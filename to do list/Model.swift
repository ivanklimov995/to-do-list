//
//  Model.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import Foundation
import RealmSwift

class Notes: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var date = Date()
    @objc dynamic var isFavorites = false
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
