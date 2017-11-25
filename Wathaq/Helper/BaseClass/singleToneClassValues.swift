//
//  singleToneClassValues.swift
//  TrainiGate_iOS
//
//  Created by Zak on 5/29/17.
//  Copyright © 2017 ibtikar. All rights reserved.
//

import UIKit

class singleToneClassValues: NSObject {
    static let sharedManager = singleToneClassValues()
    
    class var sharedInstance: singleToneClassValues
    {
        struct Static
        {
            static let instance: singleToneClassValues = singleToneClassValues()
        }
        return Static.instance
    }
    
  
    
   class func loadStoryBoardWithStoryboardName(_StoryboardName : NSString) -> UIStoryboard {
        let AppStoryBoard  = UIStoryboard (name: _StoryboardName as String, bundle: nil)
        return AppStoryBoard
    }
    

    var IsUserSignedUp :Bool?



}
