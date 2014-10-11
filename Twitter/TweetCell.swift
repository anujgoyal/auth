//
//  TweetCell.swift
//  Twitter
//
//  Created by Anuj Goyal on 10/11/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(tweet: Tweet) {
        //userImage.
        userLabel.text = tweet.user?.name
        tweetTextLabel.text = tweet.text
        
        // remember, had to modify Twitter-Bridging-Header.h
        userImage?.setImageWithURL(tweet.imgURL)
    }

}