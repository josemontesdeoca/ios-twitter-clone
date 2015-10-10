//
//  TwitterClient.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/1/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

let twitterConsumerKey = "pIdAC659TWVBZ1GRNBZQXQ4c7"
let twitterConsumerSecret = "NwthSmHoXHyj6Ei5kA9Zl25n3mPfyI94WrbpNrEz8rFZ0AI7LR"

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

private let twitterRequestTokenUrl = "oauth/request_token"
private let twitterAccessTokenUrl = "oauth/access_token"
private let twitterAuthenticateUrl = "https://api.twitter.com/oauth/authenticate?oauth_token="
private let twitterVerifyCredentialsUrl = "1.1/account/verify_credentials.json"
private let twitterHomeTimelineUrl = "1.1/statuses/home_timeline.json"
private let twitterTweetUrl = "1.1/statuses/update.json"
private let twitterCreateFavoriteUrl = "1.1/favorites/create.json"
private let twitterDestroyFavoriteUrl = "1.1/favorites/destroy.json"
private let twitterRetweetUrl = "1.1/statuses/retweet/"

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey,
        consumerSecret: twitterConsumerSecret)
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Clearn the Access token to make sure there's nothing on the library side
        TwitterClient.instance.requestSerializer.removeAccessToken()
        
        // Twitter OAuth Login
        
        // Step 1: Get a Request Token
        fetchRequestTokenWithPath(twitterRequestTokenUrl, method: "POST", callbackURL: NSURL(string: "twitterclone://oauth"), scope: nil, success: { (request: BDBOAuth1Credential!) -> Void in
            print("Got the request token!")
            
            // Step 2: Send the user to Twitters Login Page
            let authURL = NSURL(string: "\(twitterAuthenticateUrl)\(request.token)")
            
            // Grab the singleton Application and open URL
            UIApplication.sharedApplication().openURL(authURL!)
            
        }) { (error: NSError!) -> Void in
            print("Failed to get the request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        // Step 3: If users logs in, get the Access Token
        fetchAccessTokenWithPath(twitterAccessTokenUrl, method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            
            TwitterClient.instance.requestSerializer.saveAccessToken(accessToken)
            
            // User is now logged in to our App via Twitter, fetch Twitter User Object
            self.GET(twitterVerifyCredentialsUrl, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                
                User.currentUser = user
                
                // Login flow completed
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error getting current user!")
                self.loginCompletion?(user: nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            print("Failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        let parameters: [String : AnyObject] = ["count": 20]
        
        // TODO merge params into parameters
        
        GET(twitterHomeTimelineUrl, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error getting home timeline!")
            completion(tweets: nil, error: error)
        })
    }
    
    func tweetWithParams(status: String, replyTweetId: String?, completion:(tweet: Tweet?, error: NSError?) -> ()) {
        var params = ["status": status]
        
        if replyTweetId != nil {
            params["in_reply_to_status_id"] = replyTweetId!
        }
        
        POST(twitterTweetUrl, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error tweeting!")
            completion(tweet: nil, error: error)
        }
    }
    
    func createFavorite(tweetId: String, completion:(tweet: Tweet?, error: NSError?) -> ()) {
        let params: [String : AnyObject] = ["id": tweetId]
        
        POST(twitterCreateFavoriteUrl, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error favoriting a tweet!")
            completion(tweet: nil, error: error)
        }
    }
    
    func destroyFavorite(tweetId: String, completion:(tweet: Tweet?, error: NSError?) -> ()) {
        let params: [String : AnyObject] = ["id": tweetId]
        
        POST(twitterDestroyFavoriteUrl, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error removing favoriting on a tweet!")
            completion(tweet: nil, error: error)
        }
    }
    
    func retweet(tweetId: String, completion:(tweet: Tweet?, error: NSError?) -> ()) {
        let url = twitterRetweetUrl + "\(tweetId).json"
        
        POST(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Error retweeting a tweet!")
            completion(tweet: nil, error: error)
        }
    }
}
