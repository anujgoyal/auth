//
//  ViewController.swift
//  Twitter
//
//  Created by Anuj Goyal on 10/6/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
    
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET",
            callbackURL: NSURL(string: "agtwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuthToken!) -> Void in
                println("Got the request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize/?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL)

            },
            failure: { (error: NSError!) -> Void in
                println("Got the request token")
            })
        
    }

}

