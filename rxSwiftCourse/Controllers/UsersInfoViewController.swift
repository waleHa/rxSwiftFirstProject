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
    @IBOutlet weak var aboutMeLabel: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterLable: UILabel!
    @IBOutlet weak var snapchatLabel: UILabel!
    
    var user:User = SignInUpViewController.passedUser
    var userCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("UsersInfoViewController: \(SignInUpViewController.passedUser)")
//        if user.changed{
            self.userCollectionRef = Firestore.firestore().collection("Users")
            
            userCollectionRef.whereField("email", isEqualTo: "a@a.com").getDocuments(completion: { (snapshot, e) in
                if let error = e{
                    debugPrint("Error fetching docs: \(error.localizedDescription)")
                }
                else{
                    guard let snap = snapshot else {return}
                    for document in (snap.documents){
                            let data = document.data()
                            print("Waleed: \(data)")
//                            self.firstNameTextfield.text = data[Constants.Firebase.firstName] as? String
//                            self.lastNameTextfield.text = data[Constants.Firebase.lastName] as? String
//                            self.phoneNoTextfield.text = data[Constants.Firebase.phoneNumber] as? String
//                            let fullAddress = data[Constants.Firebase.fullAddress] as? Dictionary<String, String>
//                            
//                            self.provinceNameTextfield.text = fullAddress?[Constants.Firebase.province]
//                            self.zipCodeTextfield.text = fullAddress?[Constants.Firebase.zipCode]
//                            self.countryTextfield.text = fullAddress?[Constants.Firebase.country]
//                            self.cityTextfield.text = fullAddress?[Constants.Firebase.city]
//                            self.address1Textfield.text = fullAddress?[Constants.Firebase.address1]
//                            self.address2Textfield.text = fullAddress?[Constants.Firebase.address2]
//                            self.emailTextfield.text = Auth.auth().currentUser?.email
                    }
                }
            })
            
//        }
        
    }
    


}
