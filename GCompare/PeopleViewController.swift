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
        
        if (Core.Shared.selectedOrganization != nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                Core.Shared.client.fetchTeamsForOrganization(Core.Shared.selectedOrganization).collect().subscribeNext({ (x: AnyObject!) -> Void in
                    let teams = x as NSArray
                    println(teams)
                    }, error: { (error: NSError!) -> Void in
                })
                return
            })
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
