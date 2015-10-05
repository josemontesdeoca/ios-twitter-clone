//
//  TweetsViewController.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/4/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTweetViewControllerDelegate {
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.insertSubview(refreshControl, atIndex: 0)
        
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        tweetTableView.estimatedRowHeight = 100

        // Do any additional setup after loading the view.
        TwitterClient.instance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetTableView.reloadData()
        }
    }
    
    func onRefresh() {
        // Do any additional setup after loading the view.
        TwitterClient.instance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tweetTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = tweetTableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        tweetCell.tweet = tweets![indexPath.row]
        
        return tweetCell
    }
    
    func newTweetViewController(newTweetViewControlleer: NewTweetViewController, didTweet tweet: Tweet) {
        print("Handling delegate method from newTweetViewController: \(tweet)")
        tweets?.insert(tweet, atIndex: 0)
        tweetTableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        // NewTweetViewController is the top view controller of the naviagtion controller
        let newTweetViewController = navigationController.topViewController as! NewTweetViewController
        
        newTweetViewController.delegate = self
    }

}
