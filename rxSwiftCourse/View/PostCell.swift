//
//  PostCell.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var numberOfLikes: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var postCaptionLabel: UILabel!
    var post:Post!{
        didSet{
            UpdateUI();
        }
    }
    func UpdateUI(){
        if let url = URL(string:post.movie!.movieURL){
        postImageView.load(url: url)
        }
        postCaptionLabel.text = post.caption
        numberOfLikes.setTitle("♥︎ \(post.numberOfLikes) Likes", for: .normal)
        timeAgoLabel.text = post.time
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
