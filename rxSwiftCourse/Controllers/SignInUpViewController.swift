//
//  SignInUpViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-18.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase

class SignInUpViewController: UIViewController {
    static var passedUser = User(firstName: "", lastName: "", email: "", phoneNumber: "", aboutMe: "", twitter: "", instagram: "", snapchat: "", personalImage: "")
    static var myPostChanged = false
    static var newsfeedChanged = false
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    var passingEmail = ""
    var passingFirstName = ""
    var passingLastName = ""
    var passingPhoneNumber = ""
    var passingAboutMe = ""
    var passingTwitter = ""
    var passingInstagram = ""
    var passingSnapchat = ""
    var passingPersonalImage = ""
    var userCollectionRef: DocumentReference!
    var db : DocumentReference!
    override func viewDidAppear(_ animated: Bool) {
        print("SignInUpViewController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true

//                    .tabBar(self, didSelect: false)
        mainView.alpha = 0
        errorLabel.alpha = 0
    }
    
    func Changer(to alphaValue:Int, caller:String, next:String){
        phoneNumberTextField.alpha = CGFloat(alphaValue)
        firstNameTextField.alpha = CGFloat(alphaValue)
        lastNameTextField.alpha = CGFloat(alphaValue)
        Button1.setTitle(caller, for: .normal)
        Button1.titleLabel?.textAlignment = NSTextAlignment.center
        Button2.setTitle(next, for: .normal)
        Button2.titleLabel?.textAlignment = NSTextAlignment.center
    }
    func logInUI(){
        mainView.alpha = 1
        registerButton.alpha = 0
        logInButton.alpha = 0
        Changer(to: 0, caller: "Log In", next: "Go to Register")
    }
    func registerUI(){
        mainView.alpha = 1
        registerButton.alpha = 0
        logInButton.alpha = 0
        Changer(to: 1, caller: "Register", next: "Go to Log In")
    }
    @IBAction func registerButtonPressed(_ sender: UIButton){
        registerUI()
        
    }
    
    func validateFields() -> String?{
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
        if (firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ){
            return "Please, fill in all fields.";
        }
            //            else if (Utilities.isPasswordValid(cleanedPassword) == false){
            //                return "Please, make sure your password is at least 8 characters, contains a speacial character and a number."
            //            }
        else{
            return nil
        }
    }
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        logInUI()
    }
    
    @IBAction func Button1Pressed(_ sender: UIButton) {
        
        if emailTextField.text == "" || passwordTextField.text == ""{
            print("eeorr")
            errorLabel.alpha = 1
            errorLabel.text = "Please fill all the fields."
        }
        else{
            
            guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
            guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
            
            self.passingEmail = email
            
            db = Firestore.firestore().collection("Users").document(email)
            
            if Button1.titleLabel?.text! == "Register"{
                
                let error = validateFields()
                
                if error != nil{
                    //There are are something wrong with the fields, show it
                    errorLabel.alpha = 1
                    errorLabel.text = error!
                }
                else{
                    //Create cleaned versions of data
                    let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
                    let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
                    let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
                    //Create the User
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let e = error{
                            self.errorLabel.text = "\(e.localizedDescription)"
                            
                        }
                        else{ //if (error == nil){
                            
                            self.passingFirstName = firstName
                            self.passingLastName = lastName
                            self.passingPhoneNumber = phoneNumber
                            self.userSetter(fn: self.passingFirstName, ln: self.passingLastName, ph: self.passingPhoneNumber, am: "", t: "", i: "", s: "", pi: "")
                            self.db.setData( ["email":email, "firstName":firstName, "lastName":lastName,"phoneNumber":phoneNumber,"aboutMe":self.passingAboutMe,"twitter":self.passingTwitter,"instagram":self.passingInstagram,"snapchat":self.passingSnapchat,"personalImage":self.passingPersonalImage]) {(error) in
                                if let e = error{
                                    self.errorLabel.text = "\(e.localizedDescription)"
                                }
                                else{ //if (error == nil){
                                    //                                    self.errorLabel.text = "User Added Successfully"
                                    //                                    self.performSegue(withIdentifier: "ToMain", sender: self)
                                }
                            }
                            var postsDocumentRef = Firestore.firestore().collection("Users").document(self.passingEmail).collection("post").document("post")
                            postsDocumentRef.setData([ "posts":[] ])
                            
                        }
                    }
                }
                self.performSegue(withIdentifier: "ToMain", sender: self)
            }
            if Button1.titleLabel?.text! == "Log In"{
                print("Wa7a:\(email) \(password)")
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.errorLabel.text = e.localizedDescription
                    self.errorLabel.alpha = 1
                    print("Wa7a1:\(email) ")

                }
                else{
                    print("Wa7a2:\(email)")
                    self.userDataGetter(email)
                    }
                }
            }
        }
        
    }
        
            func userDataGetter(_ email:String){
                
                self.userCollectionRef = Firestore.firestore().collection("Users").document(email)
                self.userCollectionRef.getDocument(completion: { (snapshot, e) in
                    if let error = e{
                        print("Error fetching docs: \(error.localizedDescription)")
                    }
                    else{
                        guard let snap = snapshot else {return}
                        //retrieve data
                        let fn = snap.get("firstName") as! String
                        let ln = snap.get("lastName") as! String
                        let ph = snap.get("phoneNumber") as! String
                        print("passingPhoneNumber: \(ph)")
                        let am = snap.get("aboutMe") as! String
                        let t = snap.get("twitter") as! String
                        let s = snap.get("snapchat") as! String
                        let i = snap.get("instagram") as! String
                        let pi = snap.get("personalImage") as! String
                        self.userSetter( fn: fn, ln: ln, ph: ph, am: am, t: t, i: i, s: s, pi: pi)
                    }
                })
            }

        
    func userSetter(fn:String,ln:String,ph:String,am:String,t:String,i:String,s:String,pi:String){
        passingFirstName = fn
        passingLastName = ln
        passingPhoneNumber = ph
        
        passingAboutMe = am
        passingTwitter = t
        passingInstagram = i
        passingSnapchat = s
        passingPersonalImage = pi
        self.performSegue(withIdentifier: "ToMain", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let vc = segue.destination as! MainViewController
        print("passingPhoneNumber: \(passingPhoneNumber)")
        SignInUpViewController.passedUser.email = passingEmail
        SignInUpViewController.passedUser.firstName = passingFirstName
        SignInUpViewController.passedUser.lastName = passingLastName
        SignInUpViewController.passedUser.phoneNumber = passingPhoneNumber
        SignInUpViewController.passedUser.aboutMe = passingAboutMe
        SignInUpViewController.passedUser.twitter = passingTwitter
        SignInUpViewController.passedUser.snapchat = passingSnapchat
        SignInUpViewController.passedUser.instagram = passingInstagram
        SignInUpViewController.passedUser.personalImage = passingPersonalImage
    }
    
    @IBAction func Button2Pressed(_ sender: Any) {
        if Button2.titleLabel?.text! == "Go to Log In"{
            logInUI()
        }
        else{
            registerUI()
        }
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
