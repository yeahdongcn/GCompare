//
//  TeamsViewController.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/21.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
        
        if (Core.Shared.selectedOrganization != nil && Core.Shared.teams == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                Core.Shared.client.fetchTeamsForOrganization(Core.Shared.selectedOrganization).collect().subscribeNext({ (x: AnyObject!) -> Void in
                    let teams = x as NSArray
                    Core.Shared.teams = teams
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView!.reloadData()
                    })
                    }, error: { (error: NSError!) -> Void in
                })
                return
            })
        } else if (Core.Shared.teams != nil) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (Core.Shared.teams != nil) {
            return Core.Shared.teams!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell") as TeamCell
        let team = Core.Shared.teams![indexPath.row] as OCTTeam
        cell.textLabel!.text = team.name
        return cell
    }
}