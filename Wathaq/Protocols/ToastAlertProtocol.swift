//
//  ToastAlertProtocol.swift
//  EngineeringSCE
//
//  Created by Basant on 6/5/17.
//  Copyright © 2017 sce. All rights reserved.
//

import UIKit
import SwiftMessages

protocol ToastAlertProtocol {
    func showToastMessage(title:String,isBottom:Bool,isWindowNeeded:Bool,BackgroundColor:UIColor,foregroundColor:UIColor)
    func hideToastMessage ()
}

extension ToastAlertProtocol {
    
    func showToastMessage(title:String,isBottom:Bool,isWindowNeeded:Bool,BackgroundColor:UIColor,foregroundColor:UIColor)
    {
        let messageView: MessageView = MessageView.viewFromNib(layout: .messageView)
        //Configurations
        var config = SwiftMessages.Config()
        if isBottom == true
        {
            config.presentationStyle = .bottom //Presentationstyle=
        }
        else
        {
            config.presentationStyle = .top //Presentationstyle

        }
        config.duration = .seconds(seconds: 5) //Set duration
        
        if isWindowNeeded {
            config.presentationContext = .window(windowLevel: UIWindowLevelNormal) //add notification on window level
        }
        messageView.configureTheme(backgroundColor: BackgroundColor, foregroundColor: foregroundColor, iconImage: nil, iconText: nil)
        messageView.iconImageView?.isHidden = true  // Hide icon
        messageView.button?.isHidden = true  // Hide button
        messageView.configureDropShadow()  // Add shadow
        messageView.bodyLabel?.textAlignment = .center
        messageView.titleLabel?.textAlignment = .center
        messageView.bodyLabel?.isHidden = true
        messageView.titleLabel?.font = UIFont(name: "DinNextRegular", size: 14)
        // Set message title, body. Here, we're overriding the default warning
        messageView.configureContent(title: title, body: "")
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func hideToastMessage () {
        DispatchQueue.main.async {
        SwiftMessages.hideAll()
        }
    }
}
