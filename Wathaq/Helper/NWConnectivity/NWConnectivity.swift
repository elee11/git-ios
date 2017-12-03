//
//  NWConnectivity.swift
//  EngineeringSCE
//
//  Created by Basant on 6/5/17.
//  Copyright © 2017 sce. All rights reserved.
//

import UIKit
import Alamofire

class NWConnectivity: NSObject, ToastAlertProtocol{
    
    static let sharedInstance = NWConnectivity()
    
    private override init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            
            NotificationCenter.default.post(name: .NWConnectivityDidChange , object: nil)
            
            switch status {
            case .notReachable:
                print("The network is not reachable")
                //self.showToastMessage(text: NSLocalizedString("No_Internet", comment: ""), isWarning: true)
                self.showToastMessage(title: NSLocalizedString("No_Internet", comment: ""), isBottom: true, isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            //show loader beside charge percentage
            case .unknown :
                print("It is unknown whether the network is reachable")
                NotificationCenter.default.post(name: .NWConnectivityDidChange , object: nil)
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                self.hideToastMessage()
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                self.hideToastMessage()
            }
        }
        reachabilityManager?.startListening()
    }
    
    func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
}
