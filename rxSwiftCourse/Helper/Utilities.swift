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
    
    static func PostToJson(_ selectedPost:Post) -> String{
        var er = ""
        do {
        let encodedData = try JSONEncoder().encode(selectedPost)
        if let jsonString = String(data: encodedData, encoding: .utf8){
            er = jsonString
            }
        }
        catch {
            print("Failed to decode JSON")
        }
        return er
    }
    
    static func jsonToPost(_ encodedPost: String) -> Post?{
        if let dataFromJsonString = encodedPost.data(using: .utf8) {
        do {
            let PostFromData = try JSONDecoder().decode(Post.self,from: dataFromJsonString)
            return PostFromData
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

    static func daysDifference(firstDate:Date,secondDate:Date) -> Int {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        let dateComponents = calendar.dateComponents([.day], from: date1, to: date2)
        return dateComponents.day!
    }
    static func postTime(_ t:String)->String{
        var result = ""
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'&'hh:mm:ss"
            return formatter
        } ()
        let s1 = Utilities.getCurrentDate()
        let d1 = dateFormatter.date(from: s1)
        let d2 = dateFormatter.date(from: t)
        if let date1 = d1, let date2 = d2{
            let days = Utilities.daysDifference(firstDate: date2,secondDate: date1)
            
            let seconds = Int(date1.timeIntervalSince(date2))
            
            let hours = Int(seconds / 3660)
            let minutes = Int(seconds / 60)
            
            if days > 1{
                result = "\(days) days ago"}
            else{
                if hours > 0{
                    result = "\(hours) hours ago"}
                else{
                    if minutes > 0{
                        result = "\(minutes) minutes ago"
                    }
                    else{
                        result = "\(seconds) seconds ago"}
                    }
                }
        }
        else{
            print("else")
        }
        
        return result
    }
}
extension Date {
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)

        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!

        return TimeInterval(dateSeconds)
    }

    // Interval between two times of the day in seconds
    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }
}
