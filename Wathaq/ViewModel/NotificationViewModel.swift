//
//  NotificationViewModel.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 1/21/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationViewModel: NSObject {
    static let shareManager = NotificationViewModel()
    
    func GetNotification(completion: @escaping (NotificationRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getNotification, isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Notifcationmodel = Mapper<NotificationRootClass>().map(JSONString: result as! String)
                completion(Notifcationmodel,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }
}
