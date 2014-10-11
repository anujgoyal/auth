//
//  TwitterClient.swift
//  Twitter
//
//  Created by Anuj Goyal on 10/6/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import Foundation

let twitterConsumerKey = "gXDHV8Gjz329ctBDTDskwRrXH"
let twitterConsumerSecret = "nS7FPpwsPNqye8467R6sQEh4XMdzS2fdF2zChktLDedcUl0Jjz"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

// singleton
class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        // could also break out count, limit instead of putting it into the dictionary

        // test tweet timeline request
        self.GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("home timeline: \(response)")
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                
                completion(tweets: tweets, error: nil)
                //for t in tweets { println("text: \(t.text), created: \(t.createdAt)") }
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting current user")
                completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        self.loginCompletion = completion
        
        // fetch request token & redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET",
            callbackURL: NSURL(string: "agtwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuthToken!) -> Void in
                println("Got the request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize/?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL)
                
            },
            failure: { (error: NSError!) -> Void in
                println("failed to get the request token")
                self.loginCompletion?(user: nil, error: error)
        })
    }

    func openURL(url: NSURL) {
        
        
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuthToken(queryString: url.query),
            
            success:  { (accessToken: BDBOAuthToken!) -> Void in
                println("Got the access token!")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                // test user request
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        //println("user: \(response)")
                        var user = User(dictionary: response as NSDictionary!)
                        User.currentUser = user
                        // http://vimeo.com/107319225, at 31:30
                        println("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                        
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                })
                
               
                
            },
            
            failure: { (error: NSError!) -> Void in
                println("failed to receive access token.")
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
}