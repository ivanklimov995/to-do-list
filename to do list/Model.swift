//
//  Model.swift
//  to do list
//
//  Created by Иван Климов on 29.09.2022.
//

import Foundation
import RealmSwift

class Notes: Object {
    @objc var text: String = ""
    @objc var date = Date()
    @objc var isFavorites = false
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
