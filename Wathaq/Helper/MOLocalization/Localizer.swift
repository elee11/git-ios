//
//  Localizer.swift
//  LocalizationElzohry
//
//  Created by Basant on 6/29/17.
//  Copyright © 2017 kids. All rights reserved.
//

import UIKit

class Localizer {
    
    class func DoTheExchange() {
        
        ExchangeMethodsForClass(className: Bundle.self , originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.customLocalizedString(forKey:value:table:)))
        
        //exchange two variables
        ExchangeMethodsForClass(className: UIApplication.self , originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.custom_userInterfaceLayoutDirection))

    }

}

extension Bundle {
    //get it from documentation inside Bundle class
    @objc func customLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        
     let currentLanguage = Language.getCurrentLanguage()
        
        var bundle = Bundle()
        
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
            bundle = Bundle(path: path)!
        } else{
            let path = Bundle.main.path(forResource: "Base", ofType: "lproj")
            bundle = Bundle(path: path!)!
        }
        
        return bundle.customLocalizedString(forKey: key, value:value, table:tableName)
    }
    
}


extension UIApplication {
    // UIUserInterfaceLayoutDirection is readonly
    @objc var custom_userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        get{
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if Language.getCurrentLanguage() == Constants.Language.ARABIC {
                 direction = UIUserInterfaceLayoutDirection.rightToLeft
            }
            return direction
        }
    }
}


func ExchangeMethodsForClass( className: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    
    let originalMethod: Method = class_getInstanceMethod(className, originalSelector)!
    let overrideMethod: Method = class_getInstanceMethod(className, overrideSelector)!
    
    if  class_addMethod(className, originalSelector , method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod)) {
        
        class_replaceMethod(className, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else{
        method_exchangeImplementations(originalMethod, overrideMethod)
    }
    
}
