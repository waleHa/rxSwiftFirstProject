//
//  PostCell.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

protocol myTableViewCellDelegate: AnyObject{
    func didTapButton(with titleIndex:Int)
}


class PostCell: UITableViewCell {
    weak var delegate: myTableViewCellDelegate?
    var titleIndex:Int = -1
    @IBOutlet weak var postImageView: UIImageView!

    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var numberOfLikes: UIButton!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    var clickedPost:Int?
    var post:Post!{
        didSet{
            UpdateUI();
        }
    }
    @IBOutlet weak var like: UIButton!//{
    
    func UpdateUI(){
        if let url = URL(string:post.movie!.movieURL){
        postImageView.load(url: url)
        }
        postCaptionLabel.text = post.caption
        numberOfLikes.setTitle("♥︎ \(post.numberOfLikes()) Likes", for: .normal)
        if let time = post.time{
            timeAgoLabel.text = Utilities.postTime(time)
        }
        else{
        }
        if (post.didUserLikeMe(SignInUpViewController.passedUser.email)){
            like.setImage(#imageLiteral(resourceName: "liked"), for: .normal)
        }
        else{
            like.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        delegate?.didTapButton(with:titleIndex)
    }
    func configure(with index:Int){
        self.titleIndex = index
        like.setTitle("\(index)", for: .normal)
    }
}
