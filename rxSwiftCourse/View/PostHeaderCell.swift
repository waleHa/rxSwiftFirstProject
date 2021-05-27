//
//  PostHeaderCell.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

protocol myTableTitleViewCellDelegate: AnyObject{
    func didTapFollowButton(with titleIndex:Int)
}

class PostHeaderCell: UITableViewCell {
    weak var delegate: myTableTitleViewCellDelegate?
    var titleIndex:Int = -1
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var post:Post!{
        didSet{
            UpdateUI();
        }
    }
    func UpdateUI(){
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2.0;
        profileImageView.layer.masksToBounds = true
        if let a = post.user?.personalImage{
            let x = URL(string:"https://img.icons8.com/pastel-glyph/2x/person-male.png")
            profileImageView.load(url: (URL(string: a) ?? x)!)}
        usernameButton.setTitle(post.user?.createdBy(), for: .normal)
        
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        delegate?.didTapFollowButton(with: titleIndex)
    }
    func configure(with index:Int){
        self.titleIndex = index
        followButton.setTitle("\(index)", for: .normal)
    }
    
}
