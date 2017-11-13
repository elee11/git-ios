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
}
