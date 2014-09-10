//
//  ViewController.swift
//  GCompare
//
//  Created by R0CKSTAR on 14/9/10.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var signIn:UIButton!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.signIn.addTarget(self, action: "buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonClick(sender: AnyObject?) {
        OCTClient.signInToServerUsingWebBrowser(OCTServer.dotComServer(), scopes: OCTClientAuthorizationScopesRepository).subscribeNext({ (client) -> Void in
            println(client)
        }, error: { (error) -> Void in
            println(error)
        })
    }
}

