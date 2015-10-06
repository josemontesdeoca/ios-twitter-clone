//
//  User.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/4/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    var biggerProfileImageUrl: String? {
        get {
            return profileImageUrl?.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
        }
    }
    
    var atScreenName: String? {
        get {
            return "@\(screenName!)"
        }
    }
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        // Clear the current user global
        User.currentUser = nil
        
        // Clear user access token on TwitterCLient
        TwitterClient.instance.requestSerializer.removeAccessToken()
        
        // Fire notification to any other view controller listening
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary
        
                    if let dict = dictionary {
                        _currentUser = User(dictionary: dict)
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            // Cheating ^-^, User should implement NSCoding to describe seriaize/deserialize
            // In the meantime, using dictionary which is NSCoding
            
            if _currentUser != nil {
                let data = try! NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
         }
    }
}
