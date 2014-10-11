//
//  User.swift
//  Twitter
//
//  Created by Anuj Goyal on 10/7/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDigLoginNotification = "userDidLoginNotification"
let userDigLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary

        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profilee"] as? String
        tagline = dictionary["profilee"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        // use NSNotification to notify every view controller that this logout occured
        NSNotificationCenter.defaultCenter().postNotificationName(userDigLogoutNotification, object: nil)
    }
    
    
    // remember that user was logged in
    class var currentUser: User? {
        get {
            // either just booted up or starting login process for first time
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!,
                        options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            // describe how to you want to serialize/deserialize object
            // cheating by using json
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(
                    user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                // if nil, clear it out from NSUserDefaults
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }

            NSUserDefaults.standardUserDefaults().synchronize() // flush to disk
        }
    }
}
