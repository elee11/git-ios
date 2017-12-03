//
//  RefreshAppProtocol.swift
//  EngineeringSCE
//
//  Created by Basant on 8/1/17.
//  Copyright © 2017 sce. All rights reserved.
//

import UIKit

protocol RefreshAppProtocol {
    func refreshAppWithAnimation ()
    func refreshViewControllerWithAnimation()
}

extension RefreshAppProtocol {
    func refreshAppWithAnimation () {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        let sb = UIStoryboard(name: "Main", bundle: nil)
        self.customizeTabBar()

        window?.rootViewController = sb.instantiateViewController(withIdentifier: "rootVC")
        //animation
        UIView.transition(with: window!, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    func refreshViewControllerWithAnimation() {
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
            // update the status bar if you change the appearance of it.
            window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func customizeTabBar ()
    {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        let TabBarView = window?.rootViewController as! UITabBarController
        
        DispatchQueue.global().async {
        var tabBar1 :UITabBarItem  = TabBarView.tabBar.items![0]
        tabBar1.title = NSLocalizedString("watheq", comment: "")
        var tabBar2:UITabBarItem = TabBarView.tabBar.items![1]
        tabBar2.title = NSLocalizedString("myOrders", comment: "")
        
        var tabBar3:UITabBarItem = TabBarView.tabBar.items![2] as UITabBarItem
        tabBar3.title = NSLocalizedString("notifications", comment: "")
        
        var tabBar4:UITabBarItem = TabBarView.tabBar.items![3] as UITabBarItem
        tabBar4.title = NSLocalizedString("profile", comment: "")
        }

        
        let colorNormal : UIColor = UIColor.lightimpactGray
        let colorSelected : UIColor = UIColor.deepBlue
        let titleFontAll : UIFont = UIFont(name: "DinNextRegular", size: 11.0)!
        
        let attributesNormal = [
            NSAttributedStringKey.foregroundColor : colorNormal,
            NSAttributedStringKey.font : titleFontAll
        ]
        
        let attributesSelected = [
            NSAttributedStringKey.foregroundColor : colorSelected,
            NSAttributedStringKey.font : titleFontAll
        ]
        
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        
    }
}
