//
//  NewTweetViewController.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/5/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    optional func newTweetViewController(newTweetViewControlleer: NewTweetViewController, didTweet tweet: Tweet)
}

class NewTweetViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    weak var delegate: NewTweetViewControllerDelegate?
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user: User = User.currentUser!

        userImageView.setImageWithURL(NSURL(string: user.biggerProfileImageUrl!))
        nameLabel.text = user.name!
        usernameLabel.text = user.screenName!
        
        if tweet != nil {
            tweetTextView.text = "@\(tweet!.user!.screenName!) "
        }
        
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
        let status = tweetTextView.text
        
        if status != nil {
            TwitterClient.instance.tweetWithParams(status, replyTweetId: tweet?.idStr, completion: { (tweet, error) -> () in
                if tweet != nil {
                    // Success
                    self.delegate?.newTweetViewController?(self, didTweet: tweet!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    // TODO: Show an error message
                    print("Error sending status: \(error)")
                }
            })
        } else {
            print("Empty message")
        }
    }
}
