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
    var db : DocumentReference!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines);
        passingEmail = email
        db = Firestore.firestore().collection("Users").document(email)

        if Button1.titleLabel?.text! == "Register"{
            let error = validateFields()
            if error != nil{
                //There are are something wrong with the fields, show it
                errorLabel.alpha = 1
                errorLabel.text = error!
                print("WAWA: \(error!)")
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
                             
                            self.db.setData( ["Email":email, "firstName":firstName, "lastName":lastName,"phoneNumber":phoneNumber, "favNames":[], "favTypes":[], "favYears":[], "favURLs":[]]) {(error) in
                                if let e = error{
                                    self.errorLabel.text = "\(e.localizedDescription)"
                                }
                                else{ //if (error == nil){
//                                    print("Wal:Register\(authResult!.user.uid)")
                                    self.errorLabel.text = "User Added Successfully"
                                    self.performSegue(withIdentifier: "ToMain", sender: self)
                                }
                            }
                        }
                }
            }
        }
        else if Button1.titleLabel?.text! == "Log In"{
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                   if let e = error{
                                    self.errorLabel.text = e.localizedDescription
                                    self.errorLabel.alpha = 1
                                   }
                                   else{
//                                    print("Wal: Login")
                                    self.performSegue(withIdentifier: "ToMain", sender: self)
                                    
                                   }
                           }
                
                
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("Wal: before passing")
//        let vc = segue.destination as! MainViewController
        MainViewController.passedEmail = passingEmail
//        print("Wal: after passing")
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
