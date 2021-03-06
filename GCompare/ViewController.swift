//
//  ViewController.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/10.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit
import Security

extension NSDate {
    private class func dayInSeconds() -> Double { return 86400 }
    
    func day() -> Int { return self.components().day }
    
    // MARK: Components
    private class func componentFlags() -> NSCalendarUnit { return .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .WeekCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit | .WeekdayCalendarUnit | .WeekdayOrdinalCalendarUnit | .CalendarUnitWeekOfYear }
    
    private class func components(#fromDate: NSDate) -> NSDateComponents! {
        return NSCalendar.currentCalendar().components(NSDate.componentFlags(), fromDate: fromDate)
    }
    
    private func components() -> NSDateComponents  {
        return NSDate.components(fromDate: self)!
    }
    
    // MARK: Decomposing Dates
    
    func firstDayOfWeek () -> Int {
        let distanceToStartOfWeek = NSDate.dayInSeconds() * Double(self.components().weekday - 1)
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return NSDate(timeIntervalSinceReferenceDate: interval).day()
    }
    
    func lastDayOfWeek () -> Int {
        let distanceToStartOfWeek = NSDate.dayInSeconds() * Double(self.components().weekday - 1)
        let distanceToEndOfWeek = NSDate.dayInSeconds() * Double(7)
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return NSDate(timeIntervalSinceReferenceDate: interval).day()
    }
    
    func dateAtStartOfWeek() -> NSDate
    {
        let flags :NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .WeekCalendarUnit | .WeekdayCalendarUnit
        var components = NSCalendar.currentCalendar().components(flags, fromDate: self)
        components.weekday = 1 // Sunday
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    func dateAtEndOfWeek() -> NSDate
    {
        let flags :NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .WeekCalendarUnit | .WeekdayCalendarUnit
        var components = NSCalendar.currentCalendar().components(flags, fromDate: self)
        components.weekday = 7 // Sunday
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
}

class ViewController: UIViewController {
    @IBOutlet var signInButton: UIButton!
    
    func cc(client: OCTClient!, repository repo: OCTRepository!) {
        client.fetchCommitsFromRepository(repo, SHA: "master").collect().subscribeNext { (x: AnyObject!) -> Void in
            println(repo.name)
            let commits = x as NSArray
            println(commits.count)
            for commit in commits {
                let gitCommit = commit as OCTGitCommit
                println(gitCommit.commitDate)
            }
        }
    }
    
    func bb(client: OCTClient!, organization org: OCTOrganization!) {
        client.fetchOrganizationInfo(org).collect().subscribeNext { (x: AnyObject!) -> Void in
            println(x)
        }
        
        client.fetchTeamsForOrganization(org).collect().subscribeNext { (x: AnyObject!) -> Void in
            println(x)
        }
        
        client.fetchRepositoriesForOrganization(org).collect().subscribeNext { (x: AnyObject!) -> Void in
            let repos = x as NSArray
            for repo in repos {
                self.cc(client, repository: repo as OCTRepository)
            }
        }
    }
    
    func aa(client: OCTClient!) {
        client.fetchUserOrganizations().collect().subscribeNext({ (x: AnyObject!) -> Void in
            let array = x as NSArray
            for org in array {
                self.bb(client, organization: org as OCTOrganization)
            }
            }, error: { (error: NSError!) -> Void in
                println(error)
            }) { () -> Void in
                println("DONE")
        }
    }
    
    func signIn() {
        let accounts = SSKeychain.accountsForService("GC")
        if (accounts != nil && accounts.count > 0) {
            let rawLogin: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("rawLogin")
            if (rawLogin != nil) {
                let token = SSKeychain.passwordForService("GC", account: rawLogin as String)
                let user = OCTUser(rawLogin: rawLogin as String, server: OCTServer.dotComServer())
                let client = OCTClient.authenticatedClientWithUser(user, token: token)
                self.aa(client)
            }
        } else {
            OCTClient.signInToServerUsingWebBrowser(OCTServer.dotComServer(), scopes: OCTClientAuthorizationScopesRepository).subscribeNext({
                (x: AnyObject!) -> Void in
                if (x.isKindOfClass(OCTClient)) {
                    let client = x as OCTClient
                    var error: NSError?
                    if SSKeychain.setPassword(client.token, forService: "GC", account: client.user.login, error: &error) {
                        NSUserDefaults.standardUserDefaults().setObject(client.user.login, forKey: "rawLogin")
                        
                        
                        self.aa(client)
                        
                        
                        
                    } else if error != nil {
                        println(error);
                    }
                }
                }, error: { (error: NSError!) -> Void in
                    println(error)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signInButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (sender: AnyObject!) -> Void in
            self.signIn()
        }
        let a = NSDate().firstDayOfWeek()
        let b = NSDate().lastDayOfWeek()
        let c = NSDate().dateAtStartOfWeek()
        let d = NSDate().dateAtEndOfWeek()
        println(a)
        println(b)
        println(c)
        println(d)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

