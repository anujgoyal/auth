//
//  Tweet.swift
//  Twitter
//
//  Created by Anuj Goyal on 10/7/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?

    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String

        // save date
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d hh:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]  {
        var tweets = [Tweet]()
        for d in array {
            tweets.append(Tweet(dictionary: d))
        }
        return tweets
    }
    
}
