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
    var numberOfSec: Int?=0
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
            return l.count - 1
        }
        return 0
    }
    func didUserLikeMe(_ email:String)->Bool{
        if numberOfLikes() > 0{
            for l in likedBy!{
                if l.hasPrefix(email){
                    return true
                }
            }
        }
        return false
    }
    mutating func removeMe(_ email:String){
        var i = 0
        for l in likedBy!{
            if l.hasPrefix(email){
                likedBy?.remove(at: i)
            }
            i += 1
       }
    }
}


