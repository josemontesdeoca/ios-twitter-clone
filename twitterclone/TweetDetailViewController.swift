//
//  TweetDetailViewController.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/5/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, NewTweetViewControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL(NSURL(string: tweet.user!.biggerProfileImageUrl!))
        nameLabel.text = tweet.user?.name
        usernameLabel.text = tweet.user?.atScreenName
        tweetLabel.text = tweet.text
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        favoriteButton.setImage(UIImage(named: tweet.favorited! ? "favoriteOn" : "favorite"), forState: .Normal)
        retweetButton.setImage(UIImage(named: tweet.retweeted! ? "retweetOn" : "retweet"), forState: .Normal)
        
        retweetsCountLabel.text = "\(tweet.retweetCount!)"
        favoritesCountLabel.text = "\(tweet.favoriteCount!)"
        
        createdAtLabel.text = NSDateFormatter.localizedStringFromDate(tweet.createdAt!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapReply(sender: AnyObject) {
        let navigationController = storyboard?.instantiateViewControllerWithIdentifier("NCNewTweetViewController") as! UINavigationController
        
        // NewTweetViewController is the top view controller of the naviagtion controller
        let newTweetViewController = navigationController.topViewController as! NewTweetViewController
        
        newTweetViewController.delegate = self
        newTweetViewController.tweet = tweet
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func didTapRetweet(sender: AnyObject) {
        print("Retweet tap")
        tweet.retweet { (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet!
                self.retweetsCountLabel.text = "\(self.tweet.favoriteCount!)"
                self.retweetButton.setImage(UIImage(named: self.tweet.retweeted! ? "retweetOn" : "retweet"), forState: .Normal)
            } else {
                // handle error
            }
        }
    }
    
    @IBAction func didTapFavorite(sender: AnyObject) {
        print("favorite tap")
        tweet.updateFavorite { (tweet, error) -> () in
            if tweet != nil {
                self.tweet = tweet!
                self.favoritesCountLabel.text = "\(self.tweet.favoriteCount!)"
                self.favoriteButton.setImage(UIImage(named: self.tweet.favorited! ? "favoriteOn" : "favorite"), forState: .Normal)
            } else {
                // handle error
            }
        }
    }

}
