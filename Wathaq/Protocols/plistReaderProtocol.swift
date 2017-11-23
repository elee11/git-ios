//
//  plistReaderProtocol.swift
//  EngineeringSCE
//
//  Created by Basant on 5/30/17.
//  Copyright © 2017 sce. All rights reserved.
//

import UIKit

protocol PlistReaderProtocol {
    func readPlist(fileName: String) -> Any? 
}

extension PlistReaderProtocol {
    
    func readPlist(fileName: String) -> Any? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist") {
            // If your plist contain root as Array
            if let array = NSArray(contentsOfFile: path)  {
                return array
            }
            // If your plist contain root as Dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                return dic
            }
        }
        return nil
    }
    
  

}
