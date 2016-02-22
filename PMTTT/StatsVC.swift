//
//  StatsVC.swift
//  PMTTT
//
//  Created by Pavle Mijatovic on 2/21/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit
import RealmSwift


class StatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var myFunds : Results<StatsRealm>!

    
    @IBAction func clearStats(sender: AnyObject) {
        let uiRealm = try! Realm()
        
        try! uiRealm.write {
            uiRealm.deleteAll()
        }
        
        tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        // Do any additional setup after loading the view.
        self.myFunds = getStatsFromDB()

    }
    
    func getRealmConfiguration () {
        let config = Realm.Configuration()
        Realm.Configuration.defaultConfiguration = config
    }
    
    func getStatsFromDB() -> Results<StatsRealm> {
        getRealmConfiguration()
        
        let results = uiRealm.objects(StatsRealm)
        return results
    }
    
    private func configureTableView() {
        // Table view itself
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.tableFooterView = UIView(frame: CGRectZero)
//        tableView.tableFooterView!.hidden = true
//        tableView.backgroundColor = UIColor.clearColor()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFunds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatCellID", forIndexPath: indexPath)
        
        let message = self.myFunds[indexPath.row]
        cell.textLabel?.text = message.finalMessage
        cell.textLabel?.font = UIFont(name:"Avenir", size:14)
        
        return cell
    }
    
}
