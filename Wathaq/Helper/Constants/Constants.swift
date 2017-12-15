//
//  File.swift
//  SwiftStructure
//
//  Created by mohamed-shaat on 2/6/17.
//  Copyright © 2017 shaat. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct ApiConstants {
        static let BaseUrl = "http://138.197.41.25/watheq/public/"
    }
    
    struct Language {
        static let ARABIC="ar"
        static let ENGLISH="en"
        static let ARABICINT = 1
        static let ENGLISHINT = 2
    }
    
    struct pushNotificationKeys {
        static let DEVICE_TOKEN = "DEVICE_TOKEN"
        static let FCM_TOKEN = "FCM_TOKEN"
    }
    
    struct keys {
        static let flurry = "HBVRP3Y6QCT2CZMFTTQ5"
        static let KeyUser = "UserKey"
        static let keyFirstTimeUser = "keyFirstTimeUser"
        static let GoogleMapsKey = "AIzaSyCb4KG8z7i2tj3G5Dfe5SFBcLKIsQSCYN4"
        
    }
    
    struct WebService {
        static let ApiKeyValue = "85BCbm7U7JsQdbB5Z95vmvN4LyQmqVxp"
        static let ApiKeyName = "X_Api_Key"
    }
    
 


    
    struct FONTS {
        static let FONT_PARALLAX_AR = "DinNextMedium"
        static let FONT_AR = "DinNextRegular"
    }
    
    enum TabBarTabs: Int {
        case Home = 0
        case Notifications
        case Profile
        case More
    }
    
}
