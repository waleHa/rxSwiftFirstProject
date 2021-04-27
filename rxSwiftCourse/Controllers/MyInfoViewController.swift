//
//  MyInfoViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-04-21.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MyInfoViewController: UIViewController{
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var aboutMeTextfield: UITextField!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var twitterTextfield: UITextField!
    @IBOutlet weak var snapchatTextfield: UITextField!
    @IBOutlet weak var instagramTextfield: UITextField!
    @IBOutlet weak var personalImage: UIImageView!
    
    
    var firstName:String = ""{didSet{ChangeChecker()}}
    var lastName:String = ""{didSet{ChangeChecker()}}
    var aboutMe:String = ""{didSet{ChangeChecker()}}
    var email:String = ""{didSet{ChangeChecker()}}
    var phoneNumber:String = ""{didSet{ChangeChecker()}}
    var twitter:String = ""{didSet{ChangeChecker()}}
    var snapchat:String = ""{didSet{ChangeChecker()}}
    var instagram:String = ""{didSet{ChangeChecker()}}
    var newImage:UIImage? = nil {didSet{ChangeChecker()}}
    let picker = UIImagePickerController()
    
//    var user:User = SignInUpViewController.passedUser
    var userCollectionRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitiateTextsValues(firstName: SignInUpViewController.passedUser.firstName, lastName: SignInUpViewController.passedUser.lastName, aboutMe: SignInUpViewController.passedUser.aboutMe, email: SignInUpViewController.passedUser.email, phoneNumber: SignInUpViewController.passedUser.phoneNumber, instagram: SignInUpViewController.passedUser.instagram, twitter: SignInUpViewController.passedUser.twitter, snapchat: SignInUpViewController.passedUser.snapchat,image:SignInUpViewController.passedUser.personalImage)
        
        self.userCollectionRef = Firestore.firestore().collection("Users")
        
        
        personalImage.isUserInteractionEnabled = true;

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.presentPicker(_:)))
        tapGesture.delegate = self
        personalImage.addGestureRecognizer(tapGesture)

    }

    
    func InitiateTextsValues(firstName:String,lastName:String,aboutMe:String,email:String,phoneNumber:String,instagram:String,twitter:String,snapchat:String,image:String){
        
        self.aboutMeTextfield.text = aboutMe
        self.snapchatTextfield.text = snapchat
        self.twitterTextfield.text = twitter
        self.phoneNumberTextfield.text = phoneNumber
        self.instagramTextfield.text = instagram
        self.firstNameTextfield.text = firstName
        self.emailText.text = email
        self.lastNameTextfield.text = lastName
        if image != ""{
            personalImage.load(url: URL(string:image)!)
        }
        
    }
    func ChangeChecker(){
        SignInUpViewController.passedUser.changed = true
    }
    func imageURLSetter(url:String){
        SignInUpViewController.passedUser.personalImage = url
    }
    override func viewWillDisappear(_ animated: Bool) {
        if SignInUpViewController.passedUser.changed == true{
            
            guard let imageSelected = self.newImage else {return}
            
            guard let imageDate = imageSelected.jpegData(compressionQuality: 0.4) else{return}
            
            let storageRef = Storage.storage().reference(forURL: "gs://rxswiftmovies.appspot.com/")
            let storageProfileRef = storageRef.child("profile").child(SignInUpViewController.passedUser.email)
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageProfileRef.putData(imageDate, metadata: metaData, completion:
                { (StorageMetaData, error) in
                    if error != nil{
                        debugPrint("Error fetching docs: \(error?.localizedDescription ?? "")")
                        return
                    }
                    storageProfileRef.downloadURL { (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            self.imageURLSetter(url: metaImageUrl)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                                    self.userCollectionRef.document(SignInUpViewController.passedUser.email).updateData([
                                        "aboutMe":self.aboutMeTextfield.text!,
                                        "snapchat":self.snapchatTextfield.text!,
                                        "twitter":self.twitterTextfield.text!,
                                        "phoneNumber":self.phoneNumberTextfield.text!,
                                        "instagram":self.instagramTextfield.text!,
                                                    "firstName":self.firstNameTextfield.text!,
                                                    "lastName":self.lastNameTextfield.text!,
                                                    "personalImage":SignInUpViewController.passedUser.personalImage

                                ]){ e in
                                                        if let error = e{
                                                            debugPrint("Error fetching docs: \(error.localizedDescription)")
                                                        }
                                                        else{
                                                            SignInUpViewController.passedUser.aboutMe = self.aboutMeTextfield.text!
                                                            SignInUpViewController.passedUser.snapchat = self.snapchatTextfield.text!
                                                            SignInUpViewController.passedUser.twitter = self.twitterTextfield.text!
                                                            SignInUpViewController.passedUser.phoneNumber = self.phoneNumberTextfield.text!
                                                            SignInUpViewController.passedUser.instagram = self.instagramTextfield.text!
                                                            SignInUpViewController.passedUser.firstName = self.firstNameTextfield.text!
                                                            SignInUpViewController.passedUser.email = self.emailText.text!
                                                            SignInUpViewController.passedUser.lastName = self.lastNameTextfield.text!
                                                        }
                                                    }
                                SignInUpViewController.passedUser.changed = false
                            }
                        }
                    }
            })

        }
    }
}


extension MyInfoViewController:UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func presentPicker(_ sender: UITapGestureRecognizer? = nil){
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        personalImage.layer.cornerRadius = 40
        personalImage.clipsToBounds = true
        self.present(picker,animated: true,completion: nil)
    }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                newImage = imageSelected
                personalImage.image = imageSelected
            }
            if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                newImage = imageOriginal
                personalImage.image = imageOriginal
            }
            picker.dismiss(animated: true, completion: nil)
        }
}


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
