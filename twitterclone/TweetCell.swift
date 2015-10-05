//
//  TweetCell.swift
//  twitterclone
//
//  Created by Jose Montes de Oca on 10/4/15.
//  Copyright © 2015 JoseOnline!. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            let user: User = tweet.user!
            userImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            nameLabel.text = user.name
            usernameLabel.text = "@\(user.screenName!)"
            tweetLabel.text = tweet.text
            retweetLabel.text = tweet.retweetCount! > 0 ? "\(tweet.retweetCount!)" : ""
            favoriteLabel.text = tweet.favoriteCount! > 0 ? "\(tweet.favoriteCount!)" : ""
            createdAtLabel.text = formatTimeElapsed(tweet.createdAt!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func formatTimeElapsed(sinceDate: NSDate) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return formatter.stringFromTimeInterval(interval)!
    }
}
