//
//  Post.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

struct Post: Codable{    
    var time: String?
    var caption: String?
    var likedBy: [String]?
    var comments: [String]?
    var user: User?
    var movie:Movie?
    var id:String?
    func numberOfComments()->Int{
        if let c = comments{
            return c.count
        }
        return 0
    }
    func numberOfLikes()->Int{
        if let l = likedBy{
            return l.count
        }
        return 0
    }
}


