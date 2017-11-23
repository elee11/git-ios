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
    func showToastMessage(text: String, isWarning: Bool)
    func hideToastMessage () 
}

extension ToastAlertProtocol {
    
    func showToastMessage(text: String, isWarning: Bool) {
        DispatchQueue.main.async {
        let messageView: MessageView = MessageView.viewFromNib(layout: .messageView)
        var status2Config = SwiftMessages.defaultConfig
        
        messageView.iconLabel?.isHidden = true
        messageView.iconImageView?.isHidden = true
        messageView.titleLabel?.isHidden = true
        messageView.button?.isHidden = true
        messageView.bodyLabel?.textAlignment = .center
        
        if isWarning {
            status2Config.duration = .seconds(seconds: 5)
            messageView.backgroundView.backgroundColor = UIColor.deepCarminePink
        }else {
            messageView.backgroundView.backgroundColor = UIColor.verdigris
        }
        
        messageView.bodyLabel?.textColor = UIColor.white
        messageView.configureContent(body: text)
        status2Config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        status2Config.preferredStatusBarStyle = .lightContent
        status2Config.dimMode = .gray(interactive: true)
        
        // Specify one or more event listeners to respond to show and hide events.
        
        SwiftMessages.show(config: status2Config, view: messageView)
        }
    }
    
    func hideToastMessage () {
        DispatchQueue.main.async {
        SwiftMessages.hideAll()
        }
    }
}
