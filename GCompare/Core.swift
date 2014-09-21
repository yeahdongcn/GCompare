//
//  Core.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/14.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit

let SharedCore = Core()

public class Core: NSObject {
    
    public var client: OCTClient!
    public var user: OCTExtendedUser?
    public var organizations: NSArray?
    public var starredRepositories: NSArray?
    public var selectedOrganization: OCTOrganization?
    public var teams: NSArray? {
        didSet {
            println(self.teams)
        }
    }
    public var people: NSArray?
    
    func signIn(handler: ((AnyObject?) -> Void)?) {
        let accounts = SSKeychain.accountsForService(SERVICE_NAME)
        if (accounts != nil && accounts.count > 0) {
            let rawLogin: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(LOGIN_KEY)
            if (rawLogin != nil) {
                let token = SSKeychain.passwordForService(SERVICE_NAME, account: rawLogin as String)
                let user = OCTUser(rawLogin: rawLogin as String, server: OCTServer.dotComServer())
                client = OCTClient.authenticatedClientWithUser(user, token: token)
                if (handler != nil) {
                    handler!(client)
                }
            } else if (handler != nil) {
                handler!(nil)
            }
        } else {
            OCTClient.signInToServerUsingWebBrowser(OCTServer.dotComServer(), scopes: OCTClientAuthorizationScopesRepository).subscribeNext({
                (x: AnyObject!) -> Void in
                if (x.isKindOfClass(OCTClient)) {
                    self.client = x as OCTClient
                    var error: NSError?
                    if (SSKeychain.setPassword(self.client.token, forService: self.SERVICE_NAME, account: self.client.user.login, error: &error)) {
                        NSUserDefaults.standardUserDefaults().setObject(self.client.user.login, forKey: self.LOGIN_KEY)
                        if (handler != nil) {
                            handler!(self.client)
                        }
                    } else if (error != nil && handler != nil) {
                        handler!(error)
                    }
                }
                }, error: { (error: NSError!) -> Void in
                    if (handler != nil) {
                        handler!(error)
                    }
            })
        }
    }
    
    let SERVICE_NAME = "GCompare"
    let LOGIN_KEY = "RawLogin"
}
