//
//  postHeader.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-04-08.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

class PostHeader: UITableViewHeaderFooterView {

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
        
        usernameButton.setTitle(post.user?.createdBy(), for: .normal)
        
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.layer.masksToBounds = true
    }
    
}
