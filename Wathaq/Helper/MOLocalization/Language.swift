//
//  LanguageHelper.swift
//  LocalizationElzohry
//
//  Created by Basant on 6/29/17.
//  Copyright © 2017 kids. All rights reserved.
//
import Foundation

class Language {
    
    class func getDeviceLanguage() -> String{
        let prefferedLanguage = Locale.preferredLanguages.first!
        let langDict = Locale.components(fromIdentifier: prefferedLanguage)
        let deviceLanguage = langDict["kCFLocaleLanguageCodeKey"]
 
        return deviceLanguage!
    }
    
    class func getCurrentLanguage() -> String {
        let df = UserDefaults.standard
        if  let language = df.value(forKey: "AppleLanguages") as? String {
            
            return language
            
        }else if let languages = df.value(forKey: "AppleLanguages") as? NSArray {
            var firstLanguage = languages.firstObject as! String
           let langDict = Locale.components(fromIdentifier: firstLanguage)
            firstLanguage = langDict["kCFLocaleLanguageCodeKey"]!
            return firstLanguage
            
        } else {
            return getDeviceLanguage()
        }
        // let firstLanguage = languages.firstObject as! String
    }
    
    class func setAppLanguage(lang: String) {
        let df = UserDefaults.standard
        //["ar","en-US"]
        if lang == "en" {
            df.set(["en", "ar"], forKey: "AppleLanguages")
        } else if lang == "ar" {
            df.set(["ar", "en"], forKey: "AppleLanguages")
        }
        df.synchronize()
    }
}
