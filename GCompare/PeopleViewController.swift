//
//  PeopleViewController.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/19.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "PeopleCell", bundle: nil), forCellReuseIdentifier: "PeopleCell")
        
        if (SharedCore.selectedOrganization != nil && SharedCore.teams == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                SharedCore.client.fetchTeamsForOrganization(SharedCore.selectedOrganization).collect().subscribeNext({ (x: AnyObject!) -> Void in
                    let teams = x as NSArray
                    SharedCore.teams = teams
                    }, error: { (error: NSError!) -> Void in
                })
                return
            })
        } else if (SharedCore.teams != nil) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PeopleCell") as PeopleCell
        return cell
    }
    
    // MARK: UITableViewDelegate
}
