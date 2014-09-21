//
//  OrganizationsViewController.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/14.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit

class OrganizationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarView.layer.cornerRadius = avatarView.bounds.size.width / 2.0
        avatarView.clipsToBounds = true
        
        tableView.registerNib(UINib(nibName: "OrganizationCell", bundle: nil), forCellReuseIdentifier: "OrganizationCell")
        tableView.tableHeaderView = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SharedCore.signIn { (object: AnyObject?) -> Void in
            if (object != nil) {
                if (object!.isKindOfClass(OCTClient)) { // Completed handling
                    let client = object as OCTClient
                    
                    // Starred Repositories
                    client.fetchUserStarredRepositories().collect().subscribeNext({ (x: AnyObject!) -> Void in
                        SharedCore.starredRepositories = (x as NSArray)
                        }, error: { (error: NSError!) -> Void in
                        }, completed: { () -> Void in
                    })
                    
                    // User Info
                    client.fetchExtendedUserInfo().collect().subscribeNext({ (x: AnyObject!) -> Void in
                        SharedCore.user = (x as NSArray).firstObject as OCTExtendedUser?
                        if (SharedCore.user != nil) {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                println(SharedCore.user!.followers)
                                self.nameLabel.text = SharedCore.user!.name
                                self.loginLabel.text = SharedCore.user!.login
                                self.avatarView.setImageWithURL(SharedCore.user!.avatarURL)
                                self.tableView.beginUpdates()
                                self.tableView.tableHeaderView = self.tableHeaderView
                                self.tableView.endUpdates()
                            })
                        }
                        }, error: { (error: NSError!) -> Void in
                            
                        }, completed: { () -> Void in
                            
                    })
                    
                    client.fetchUserOrganizations().collect().subscribeNext({ (x: AnyObject!) -> Void in
                        SharedCore.organizations = (x as NSArray)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                        })
                        }, error: { (error: NSError!) -> Void in
                            
                        }, completed: { () -> Void in
                            
                    })
                } else if (object!.isKindOfClass(NSError)) { // Error handling
                    
                }
            } else { // Error handling
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (SharedCore.organizations != nil) {
            return SharedCore.organizations!.count
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrganizationCell") as OrganizationCell
        let organization = SharedCore.organizations!.objectAtIndex(indexPath.row) as OCTOrganization
        cell.textLabel?.text = organization.name
        cell.imageView?.setImageWithURL(organization.avatarURL, placeholderImage: UIImage())
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        SharedCore.selectedOrganization = SharedCore.organizations!.objectAtIndex(indexPath.row) as? OCTOrganization
        
        self.performSegueWithIdentifier("ShowTab", sender: self)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("StatisticCell", forIndexPath: indexPath) as UICollectionViewCell
        return cell
    }
}