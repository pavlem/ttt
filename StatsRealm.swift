//
//  StatsRealm.swift
//  PMTTT
//
//  Created by Pavle Mijatovic on 2/21/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation
import RealmSwift

class StatsRealm: Object {
    dynamic var player1 = ""
    dynamic var player2 = ""
    dynamic var date = ""
    dynamic var finalMessage = ""
}
