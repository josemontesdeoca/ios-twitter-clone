//
//  TweetDetailViewController.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/5/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
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
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL(NSURL(string: tweet.user!.biggerProfileImageUrl!))
        nameLabel.text = tweet.user?.name
        usernameLabel.text = tweet.user?.atScreenName
        tweetLabel.text = tweet.text
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        retweetsCountLabel.text = "\(tweet.retweetCount!)"
        favoritesCountLabel.text = "\(tweet.favoriteCount!)"
        
        createdAtLabel.text = NSDateFormatter.localizedStringFromDate(tweet.createdAt!, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapReply(sender: AnyObject) {
        // TODO
    }
    
    @IBAction func didTapRetweet(sender: AnyObject) {
        // TODO
    }
    
    @IBAction func didTapFavorite(sender: AnyObject) {
        // TODO
    }
}
