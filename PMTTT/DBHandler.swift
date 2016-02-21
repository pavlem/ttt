//
//  DBHandler.swift
//  UBS Funds
//
//  Created by Pavle Mijatovic on 10/30/15.
//  Copyright © 2015 Namics AG. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

// Share Realm object across all Swift files
let uiRealm = try! Realm()
var isFundInRealmDB = Bool()


class DBHandler {

    func getRealmConfiguration () {
        let config = Realm.Configuration()
        Realm.Configuration.defaultConfiguration = config
    }
    
    func getStatsFromDB() -> Results<StatsRealm> {
        getRealmConfiguration()

        let results = uiRealm.objects(StatsRealm)
        return results
    }
    
    // MARK: Write
    func addStatsToDB(stats: StatsRealm) {
        add(stats)
    }

    private func add(dbObject: Object) {
        getRealmConfiguration()
        let realm = try! Realm()

        do {
            try realm.write {
                realm.add(dbObject)
            }
        } catch {
        }
    }
    
}