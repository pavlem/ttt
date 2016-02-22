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
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var myFunds : Results<StatsRealm>!

    
    // MARK: - Actions
    @IBAction func clearStats(sender: AnyObject) {
        DBHandler().clearAllData()
        tableView.reloadData()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        self.myFunds = DBHandler().getStatsFromDB()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    
    // MARK: - Private
    private func configureTableView() {
        // Table view itself
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - Delegates
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFunds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatCellID", forIndexPath: indexPath)
        let message = self.myFunds[indexPath.row]
        cell.textLabel?.text = message.finalMessage
        cell.textLabel?.font = UIFont(name:"Avenir", size:14)
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}