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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user: User = User.currentUser!

        // Do any additional setup after loading the view.
        userImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
        nameLabel.text = user.name!
        usernameLabel.text = user.screenName!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
        let status = tweetTextView.text
        
        if status != nil {
            TwitterClient.instance.tweetWithParams(status, completion: { (tweet, error) -> () in
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
