//
//  VisitorCount.swift
//  Realm with Charts
//
//  Created by Rey Cerio on 2017-05-20.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import Foundation
import RealmSwift

class VisitorCount: Object {
    dynamic var date: Date = Date()
    dynamic var count: Int = Int(0)
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}

