//
//  UIColorExtension.swift
//  EngineeringSCE
//
//  Created by Basant on 5/26/17.
//  Copyright © 2017 sce. All rights reserved.
//
import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    class var redAlert: UIColor {
        return UIColor(red: 208.0 / 255.0, green: 75.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
    }
    
    class var greenAlert: UIColor {
        return UIColor(red: 96.0 / 255.0, green: 208.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
    }
    
    class var YellowSEGMENT: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 214.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    
    class var deepBlue: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 147.0 / 255.0, blue: 82.0 / 255.0, alpha: 1.0)
    }
    
    class var LightGreen: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 198.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    }
    
    class var lightimpactGray: UIColor {
        return UIColor(red: 149.0 / 255.0, green: 149.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    }
    
    class var battleshipGrey: UIColor {
        return UIColor(red: 134.0 / 255.0, green: 134.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
    }
    
    class var outerSpace: UIColor {
        return UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }
    
    class var white: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var deepCarminePink: UIColor {
        return UIColor(red: 235.0 / 255.0, green: 54.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
    }
    
    class var silver: UIColor {
        return UIColor(red: 198.0 / 255.0, green: 198.0 / 255.0, blue: 198.0 / 255.0, alpha: 1.0)
    }
    
    class var silver1: UIColor {
        return UIColor(red: 189.0 / 255.0, green: 189.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    }
    
    class var silver2: UIColor {
        return UIColor(red: 194.0 / 255.0, green: 194.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)
    }
    
    class var taupeGray: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 140.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0)
    }
    
    class var whiteSmoke: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    }
    
    class var snow: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    class var gainsboro: UIColor {
        return UIColor(red: 217.0 / 255.0, green: 217.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    }
    
    class var verdigris: UIColor {
        return UIColor(red: 61.0 / 255.0, green: 179.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    }
    
    class var carminePink: UIColor {
        return UIColor(red: 226.0 / 255.0, green: 87.0 / 255.0, blue: 76.0 / 255.0, alpha: 1.0)
    }
    
    class var lavenderGray: UIColor {
        return UIColor(red: 199.0 / 255.0, green: 199.0 / 255.0, blue: 199.0 / 255.0, alpha: 1.0)
    }
    
    class var lightGray: UIColor {
        return UIColor(red: 208.0 / 255.0, green: 208.0 / 255.0, blue: 208.0 / 255.0, alpha: 1.0)
    }
    
    class var lightGray1: UIColor {
        return UIColor(red: 207.0 / 255.0, green: 207.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
    }
    
    class var lightGray2: UIColor {
        return UIColor(red: 214.0 / 255.0, green: 214.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }
    
    class var manatee: UIColor {
        return UIColor(red: 155.0 / 255.0, green: 155.0 / 255.0, blue: 155.0 / 255.0, alpha: 1.0)
    }
    
    class var manatee1: UIColor {
        return UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 0.5)
    }
    
    class var manatee2: UIColor {
        return UIColor(red: 158.0 / 255.0, green: 158.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    }
    
    class var ashGrey: UIColor {
        return UIColor(red: 183.0 / 255.0, green: 183.0 / 255.0, blue: 183.0 / 255.0, alpha: 1.0)
    }
    
    class var charcoal: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 78.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
    }
    
    class var black: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    }
    
    class var timberwolf: UIColor {
        return UIColor(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
    }
    
    class var platinum: UIColor {
        return UIColor(red: 228.0 / 255.0, green: 228.0 / 255.0, blue: 228.0 / 255.0, alpha: 1.0)
    }
    
    class var platinum1: UIColor {
        return UIColor(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
    }
    
    class var carrotOrange: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 160.0 / 255.0, blue: 28.0 / 255.0, alpha: 1.0)
    }
    
    class var lightpink: UIColor {
        return UIColor(red: 233.0 / 255.0, green: 61.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }

}
