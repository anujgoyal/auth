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
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
}