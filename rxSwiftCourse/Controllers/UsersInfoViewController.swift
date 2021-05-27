//
//  UsersInfoViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-04-21.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase
class UsersInfoViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterLable: UILabel!
    @IBOutlet weak var snapchatLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instagramLabel: UILabel!
    var user=User(firstName: "", lastName: "", email: "", phoneNumber: "", aboutMe: "", twitter: "", instagram: "", snapchat: "", personalImage: "")
    override func viewDidAppear(_ animated: Bool) {
        print("UsersInfoViewController")
//        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        aboutMeLabel.text = user.aboutMe
        emailLabel.text = user.email
        twitterLable.text = user.twitter
        snapchatLabel.text = user.snapchat
        instagramLabel.text = user.instagram
        print("\(user.firstName) \(user.lastName) \(user.email)")
        let xURL = URL(string:"https://img.icons8.com/pastel-glyph/2x/person-male.png")
        userImage.load(url: (URL(string: user.personalImage) ?? xURL)!)
        print(user.personalImage)
    }
    


}
