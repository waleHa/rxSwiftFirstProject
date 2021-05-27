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
    
    
    var firstName:String = ""
    var lastName:String = ""
    var aboutMe:String = ""
    var email:String = ""
    var phoneNumber:String = ""
    var twitter:String = ""
    var snapchat:String = ""
    var instagram:String = ""
    var newImage:UIImage? = nil
    let picker = UIImagePickerController()
    
//    var user:User = SignInUpViewController.passedUser
    var userCollectionRef: CollectionReference!
    var userDocumentRef: DocumentReference!
    override func viewDidAppear(_ animated: Bool) {
        print("MyInfoViewController")
//        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitiateTextsValues(firstName: SignInUpViewController.passedUser.firstName, lastName: SignInUpViewController.passedUser.lastName, aboutMe: SignInUpViewController.passedUser.aboutMe, email: SignInUpViewController.passedUser.email, phoneNumber: SignInUpViewController.passedUser.phoneNumber, instagram: SignInUpViewController.passedUser.instagram, twitter: SignInUpViewController.passedUser.twitter, snapchat: SignInUpViewController.passedUser.snapchat,image:SignInUpViewController.passedUser.personalImage)
        
        self.userCollectionRef = Firestore.firestore().collection("Users")
        self.userDocumentRef = Firestore.firestore().collection("Users").document(SignInUpViewController.passedUser.email)
        
        print(SignInUpViewController.passedUser.email)
        
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
        if
        self.aboutMeTextfield.text != aboutMe ||
        self.snapchatTextfield.text != snapchat ||
        self.twitterTextfield.text != twitter ||
        self.phoneNumberTextfield.text != phoneNumber ||
        self.instagramTextfield.text != instagram ||
        self.firstNameTextfield.text != firstName ||
        self.emailText.text != email ||
        self.lastNameTextfield.text != lastName{
            SignInUpViewController.passedUser.changed = true
        }
    }
    
    func imageURLSetter(url:String){
        SignInUpViewController.passedUser.personalImage = url
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        ChangeChecker()
        if SignInUpViewController.passedUser.changed == true{
            print("Changed")
                        userDocumentRef.updateData(["aboutMe":self.aboutMeTextfield.text!,
                        "snapchat":self.snapchatTextfield.text!,
                        "twitter":self.twitterTextfield.text!,
                        "phoneNumber":self.phoneNumberTextfield.text!,
                        "instagram":self.instagramTextfield.text!,
                                    "firstName":self.firstNameTextfield.text!,
                                    "lastName":self.lastNameTextfield.text!]){ e in
                                    if let error = e{
                                        debugPrint("Error fetching docs: \(error.localizedDescription)")
                                    }
                                    else{
                                        
                                        self.userUpdater(aboutme: self.aboutMeTextfield.text!, snap: self.snapchatTextfield.text!, twitter: self.twitterTextfield.text!, phoneNum: self.phoneNumberTextfield.text!, insta: self.instagramTextfield.text!, firstN: self.firstNameTextfield.text!, lastN: self.lastNameTextfield.text!, email: self.emailText.text!)
                                    }
                        }
            
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
                                                    "personalImage":SignInUpViewController.passedUser.personalImage]){ e in
                                                        if let error = e{
                                                            debugPrint("Error fetching docs: \(error.localizedDescription)")
                                                        }
                                                        else{

                                                            SignInUpViewController.passedUser.personalImage = SignInUpViewController.passedUser.personalImage
                                                        }
                                                    }
                                SignInUpViewController.passedUser.changed = false
                            }
                        }
                    }
            })

        }
    }
    

    func userUpdater(aboutme:String,snap:String,twitter:String,phoneNum:String,insta:String,firstN:String,lastN:String,email:String){
        SignInUpViewController.passedUser.aboutMe = aboutme
        SignInUpViewController.passedUser.snapchat = snap
        SignInUpViewController.passedUser.twitter = twitter
        SignInUpViewController.passedUser.phoneNumber = phoneNum
        SignInUpViewController.passedUser.instagram = insta
        SignInUpViewController.passedUser.firstName = firstN
        SignInUpViewController.passedUser.email = email
        SignInUpViewController.passedUser.lastName = lastN
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
