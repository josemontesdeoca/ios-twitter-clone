//
//  Tweet.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/4/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int64?
    var idStr: String?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favorited: Bool?
    var retweeted: Bool?
    var retweetCount: Int?
    var favoriteCount: Int?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int64
        idStr = dictionary["id_str"] as? String
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    func updateFavorite(completion: (tweet: Tweet?, error: NSError?) -> ()) {
        if favorited ?? false {
            TwitterClient.instance.destroyFavorite(idStr!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.favorited = false
                    self.favoriteCount!--
                    completion(tweet: self, error: error)
                } else {
                    completion(tweet: nil, error: error)
                }
            })
        } else {
            TwitterClient.instance.createFavorite(idStr!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.favorited = true
                    self.favoriteCount!++
                    completion(tweet: self, error: error)
                } else {
                    completion(tweet: nil, error: error)
                }
            })
        }
    }
    
    func retweet(completion: (tweet: Tweet?, error: NSError?) -> ()) {
        // TODO: Handle undo a retweet
        if !(retweeted ?? false) {
            TwitterClient.instance.retweet(idStr!, completion: { (tweet, error) -> () in
                if tweet != nil {
                    self.retweeted = true
                    self.retweetCount!++
                    completion(tweet: self, error: error)
                } else {
                    completion(tweet: nil, error: error)
                }
            })
        }
    }
}
