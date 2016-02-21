//
//  StatsVC.swift
//  PMTTT
//
//  Created by Pavle Mijatovic on 2/21/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class StatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
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
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatCellID", forIndexPath: indexPath)
        cell.textLabel?.text = ""
        return cell
    }
}
