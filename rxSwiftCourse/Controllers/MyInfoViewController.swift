//
//  MyInfoViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-04-21.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase
class MyInfoViewController: UIViewController {
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var aboutMeTextfield: UITextField!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var twitterTextfield: UITextField!
    @IBOutlet weak var snapchatTextfield: UITextField!
    @IBOutlet weak var instagramTextfield: UITextField!
    
    var firstName:String = ""{didSet{ChangeChecker()}}
    var lastName:String = ""{didSet{ChangeChecker()}}
    var aboutMe:String = ""{didSet{ChangeChecker()}}
    var email:String = ""{didSet{ChangeChecker()}}
    var phoneNumber:String = ""{didSet{ChangeChecker()}}
    var twitter:String = ""{didSet{ChangeChecker()}}
    var snapchat:String = ""{didSet{ChangeChecker()}}
    var instagram:String = ""{didSet{ChangeChecker()}}
    
//    var user:User = SignInUpViewController.passedUser
    var userCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HEHE: \(SignInUpViewController.passedUser.email)")
        print("MyInfoViewController")
        self.aboutMeTextfield.text = SignInUpViewController.passedUser.aboutMe
        self.snapchatTextfield.text = SignInUpViewController.passedUser.snapchat
        self.twitterTextfield.text = SignInUpViewController.passedUser.twitter
        self.phoneNumberTextfield.text = SignInUpViewController.passedUser.phoneNumber
        self.instagramTextfield.text = SignInUpViewController.passedUser.instagram
        self.firstNameTextfield.text = SignInUpViewController.passedUser.firstName
        self.emailText.text = SignInUpViewController.passedUser.email
        self.lastNameTextfield.text = SignInUpViewController.passedUser.lastName
        self.InitiateTextsValues(firstName: self.firstNameTextfield.text!, lastName: self.lastNameTextfield.text!, aboutMe: self.aboutMeTextfield.text!, email: self.emailText.text!, phoneNumber: self.phoneNumberTextfield.text!, instagram: self.instagramTextfield.text!, twitter: self.twitterTextfield.text!, snapchat: self.snapchatTextfield.text!)
                    self.userCollectionRef = Firestore.firestore().collection("Users")
//                    userCollectionRef.whereField("email", isEqualTo: SignInUpViewController.passedUser.email).getDocuments(completion: { (snapshot, e) in
//                        if let error = e{
//                            debugPrint("Error fetching docs: \(error.localizedDescription)")
//                        }
//                        else{
//                            guard let snap = snapshot else {return}
//                            for document in (snap.documents){
//                                    let data = document.data()
//
//                                }
//                                              }
//                                          })
    }
    func InitiateTextsValues(firstName:String,lastName:String,aboutMe:String,email:String,phoneNumber:String,instagram:String,twitter:String,snapchat:String){
        self.firstName = firstName
        self.lastName = lastName
        self.aboutMe = aboutMe
        self.aboutMe = aboutMe
        self.email = email
        self.phoneNumber = phoneNumber
        self.instagram = instagram
        self.twitter = twitter
        self.snapchat = snapchat
    }
    func ChangeChecker(){
        SignInUpViewController.passedUser.changed = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        if SignInUpViewController.passedUser.changed == true{
            userCollectionRef.document(SignInUpViewController.passedUser.email).updateData([
                                "aboutMe":aboutMeTextfield.text!,
                                "snapchat":snapchatTextfield.text!,
                                "twitter":twitterTextfield.text!,
                                "phoneNumber":phoneNumberTextfield.text!,
                                "instagram":instagramTextfield.text!,
                                "firstName":firstNameTextfield.text!,
                                "lastName":lastNameTextfield.text!
            ]){ e in
                                    if let error = e{
                                        debugPrint("Error fetching docs: \(error.localizedDescription)")
                                    }
                                    else{
//                                        Auth.auth().currentUser?.updateEmail(to: self.emailText.text!, completion: { (e) in
//                                            if let error = e{
//                                                debugPrint("Error fetching docs: \(error.localizedDescription)")
//                                            }
//                                            print( "Updated Successfully")
//                                        })
                                    }
                                    
                                }
            
            
            SignInUpViewController.passedUser.changed = false
        }
    }
}
