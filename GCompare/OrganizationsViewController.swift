//
//  OrganizationsViewController.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/14.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit

class OrganizationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    
    var organizations: NSArray?
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Core.Shared.signIn { (object: AnyObject?) -> Void in
            if (object != nil) {
                if (object!.isKindOfClass(OCTClient)) {
                    let client = object as OCTClient
                    client.fetchUserInfo().collect().subscribeNext({ (x: AnyObject!) -> Void in
                        let user = (x as NSArray).firstObject as OCTUser?
                        if (user != nil) {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.nameLabel.text = user!.name
                                self.loginLabel.text = user!.login
                                self.avatarView.setImageWithURL(user!.avatarURL)
                                self.tableView.beginUpdates()
                                self.tableView.tableHeaderView = self.tableHeaderView
                                self.tableView.endUpdates()
                            })
                        }
                    }, error: { (error: NSError!) -> Void in
                        
                    }, completed: { () -> Void in
                        println("fetchUserInfo completed")
                    })
                    
                    client.fetchUserOrganizations().collect().subscribeNext({ (object: AnyObject!) -> Void in
                        self.organizations = object as NSArray?
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                        })
                        }, error: { (error: NSError!) -> Void in
                            
                        }, completed: { () -> Void in
                            println("fetchUserOrganizations completed")
                    })
                } else if (object!.isKindOfClass(NSError)) {
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (organizations != nil) {
            return organizations!.count
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrganizationCell") as UITableViewCell
        let organization = organizations!.objectAtIndex(indexPath.row) as OCTOrganization
        cell.textLabel!.text = organization.name
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}