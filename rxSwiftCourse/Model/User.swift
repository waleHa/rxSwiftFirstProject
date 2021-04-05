//
//  User.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-04-01.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

struct User: Codable{
    var firstName: String
    var lastName: String
    var email:String
    var phoneNumber:String
    func createdBy() ->String{
        return "\(firstName) \(lastName)"
    }
}
