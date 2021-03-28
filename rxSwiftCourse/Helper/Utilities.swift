//
//  Utilities.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-18.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import Foundation

//
//  Utilites.swift
//  EService
//
//  Created by admin on 2021-01-28.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    static func styleTextField(_ textfield: UITextField){
               let bottomLine = CALayer()
               
               bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
               
               bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
               
               //remove border on textField
               textfield.borderStyle = .none
               
               //Add line to the text field
               
               textfield.layer.addSublayer(bottomLine)
        }
    static func styleFilledButton(_ button: UIButton,withCornerSize x:Float, color: UIColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)) {
        
        // Filled rounded corner style
        button.backgroundColor = color
        button.layer.cornerRadius = CGFloat(x)
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton, withCornerSize x:Float) {
        button.layer.borderWidth = 2;
        button.layer.borderColor = UIColor.white.cgColor;
        button.layer.cornerRadius = CGFloat(x);
        button.tintColor = UIColor.white;
        
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let pattern =  "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@" , pattern);
        return passwordTest.evaluate(with: password);
    }

    static func formattingString(string:String)->String{
        let s = string.trimmingCharacters(in: .whitespacesAndNewlines)
    return s.replacingOccurrences(of: " ", with: "") // result: "no space!"
    }
}

