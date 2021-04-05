//
//  Utilities.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-18.
//  Copyright © 2021 Wa7a. All rights reserved.
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
    
    static func movieToJson(_ selectedMovie:Movie) -> String{
        var er = ""
        do {
        let encodedData = try JSONEncoder().encode(selectedMovie)
        if let jsonString = String(data: encodedData, encoding: .utf8){
            er = jsonString
            }
        }
        catch {
            print("Failed to decode JSON")
        }
        return er
    }
    
    static func jsonToMovie(_ encodedMvie: String) -> Movie?{
        if let dataFromJsonString = encodedMvie.data(using: .utf8) {
        do {
            let movieFromData = try JSONDecoder().decode(Movie.self,from: dataFromJsonString)
            return movieFromData
        }
            catch {
                print("Failed to decode JSON")
            }
        }
        return nil
    }
    
    static func jsonToStringArray(_ encoded: String) -> [String]?{
        if let dataFromJsonString = encoded.data(using: .utf8) {
        do {
            let arrayFromData = try JSONDecoder().decode([String].self,from: dataFromJsonString)
            return arrayFromData
        }
            catch {
                print("Failed to decode JSON")
            }
        }
        return nil
    }
    
    static func stringToJson(_ encoded: [String]) -> String{
        var er = ""
        do {
        let encodedData = try JSONEncoder().encode(encoded)
        if let jsonString = String(data: encodedData, encoding: .utf8){
            er = jsonString
            }
        }
        catch {
            print("Failed to decode JSON")
        }
        return er
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZZZ"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    } ()
}

extension Utilities{

    

    func getCurrentDate() -> Date? {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ssZZZ"
        formatter.timeZone = TimeZone.init(abbreviation: "EDT")
        let dateInString  = formatter.string(from: date)
        let dateinDate = formatter.date(from: dateInString)
        return dateinDate
    }
    static func getCurrentDate() -> String {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'&'hh:mm:ss"
            formatter.timeZone = TimeZone.init(abbreviation: "EDT")
            let dateInString  = formatter.string(from: date)
            return dateInString
        }
    static func getCurrentDateOnly() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.init(abbreviation: "EDT")
        let dateInString  = formatter.string(from: date)
        return dateInString
    }
    static func getCurrentTimeOnly() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        formatter.timeZone = TimeZone.init(abbreviation: "EDT")
        let dateInString  = formatter.string(from: date)
        return dateInString
    }

    //
    //// Creating Date from String
//    let textDate1 = "2021-03-23T12:21:00-0800"
    //let textDate2 = "2016-03-06T20:12:05-0900"

    //// Dates used for the comparison
//    let date1 = dateFormatter.date(from: textDate1)

    func hoursDifference(firstDate:Date,secondDate:Date) -> TimeInterval {
           let calendar = Calendar.current
           let date1 = calendar.startOfDay(for: firstDate)
           let date2 = calendar.startOfDay(for: secondDate)
           // omitting fractions of seconds for simplicity
           let dateComponents = calendar.dateComponents([.hour], from: date1,to: date2)

           let dateSeconds = dateComponents.hour!

           return TimeInterval(dateSeconds)
       }
    func minutesDifference(firstDate:Date,secondDate:Date) -> TimeInterval {
           let calendar = Calendar.current
           let date1 = calendar.startOfDay(for: firstDate)
           let date2 = calendar.startOfDay(for: secondDate)
           // omitting fractions of seconds for simplicity
           let dateComponents = calendar.dateComponents([.minute], from: date1,to: date2)

           let dateSeconds = dateComponents.hour!

           return TimeInterval(dateSeconds)
       }
    func daysDifference(firstDate:Date,secondDate:Date) -> Int {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let dateComponents = calendar.dateComponents([.day], from: date1, to: date2)
                
        return dateComponents.day!
    }

//    if let date1 = date1, let date2 = getCurrentDate() {
//         let diff = hoursDifference(firstDate: date1, secondDate: date2)
//        let diff2 = minutesDifference(firstDate: date1, secondDate: date2)
//        print(daysDifference(firstDate: date1,secondDate: date2))
//         print(diff)
//        print(diff2)
//    }
}
