//
//  STRINGS.swift
//  MANCHESTER MASSAGE
//
//  Created by Users on 17/01/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation

extension String{
    
    var isValidName: Bool{
        let RegEx = "\\w{7,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool{
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){

                if(self.count>=4 && self.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        let charcter  = CharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcter)
        let filtered = inputString.joined()
        return  self == filtered

    }
    
    var toData: Data{
        return self.data(using: .utf8) ?? Data()
    }
    
    //MARK:-Extension of String which allow to Display HTML data in a label or textView
    private var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var durationString: String{
        let currentDuration = Int(Double(self) ?? 0.0)
        let (h, m, s) = (currentDuration / 3600, (currentDuration % 3600) / 60, (currentDuration % 3600) % 60)
        var finalString = ""
        if h > 0{
            finalString += String(format: "%02d", h) + ":"
        }
        finalString += String(format: "%02d", m) + ":"
        finalString += String(format: "%02d", s)
        
        return finalString
    }
}

struct Message {
    static let apiError = "Error in data fetching. Please try again!"
}


extension UserDefaults{
    
    func saveData(value: Any, key: UserDefaults.keys){
        UserDefaults.standard.set(value, forKey: key.value)
        UserDefaults.standard.synchronize()
    }
    
    func deleteData(forKey: UserDefaults.keys){
        UserDefaults.standard.removeObject(forKey: forKey.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func deleteAllData(){
        keys.allCases.forEach { (key) in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    func fetchData(forKey: UserDefaults.keys)-> String{
        return UserDefaults.standard.string(forKey: forKey.rawValue) ?? ""
    }
    
    func fetchData(forKey: UserDefaults.keys)-> Int{
        return UserDefaults.standard.integer(forKey: forKey.rawValue)
    }
    
    enum keys: String, CaseIterable{
        
        case userId, userFirstName, userLastName, userEmail,userPhone, userStatus, userSocialLogin, userSocialLoginId, userImage, userGroupID, cart, userSubscribed
        var value: String{
            return self.rawValue
        }
    }

    
}

var API_BASE_URL : String{
    return "https://tonnerumusic.com/api/v1/"
}

enum APIEndPoints{
    static let artistdetails = "artistdetails"
}


extension Notification.Name{
    static let UpdateFollowingList = Notification.Name("updateFollowingList")
}
