//
//  NetworkHandler.swift
//  EngineeringSCE
//
//  Created by Basant on 7/5/17.
//  Copyright © 2017 sce. All rights reserved.
//

import UIKit
import Foundation

class NetworkHandler: NSObject, ToastAlertProtocol {
    
    class func requestTarget(target: WatheqApi, isDictionary: Bool? = true, completion: @escaping (Any?,String?) -> ()) {
        
        WatheqProvider.request(target){ result in
            
            if  let statusCode = result.value?.statusCode {
                switch statusCode {
                case 200...299:
                    print (">>>>>>success \(statusCode)")
                    
                    do {
                        if isDictionary! == false { // array
                            let response = try result.dematerialize()
                            let value = try response.mapJSON()
                            
                            print(value)
                            completion(value , nil)
                        } else{
                            let response = try result.dematerialize()
                            let value = try response.mapString()
                            
                            print(value)
                            completion(value , nil)
                        }
                    } catch {
                        let printableError = error as? CustomStringConvertible
                        let errorMessage = printableError?.description ?? "Unable to fetch date from server"
                        completion(nil,errorMessage)
                    }
                    
                case 400...401:
                    do{
                        print (">>>>>>>Invalid_Auth \(statusCode)")
                        let response = try result.dematerialize()
                        let value = try response.mapJSON()
                        
                        if let messageDict = value as? [String: String] {
                            print(messageDict["Message"])
                            
                            completion(nil,messageDict["Message"])
                        }
                    } catch {
                        let printableError = error as? CustomStringConvertible
                        let errorMessage = printableError?.description ?? "Unable to fetch date from server"
                        completion(nil,errorMessage)
                    }
                case 500:
                    let errorMsg = NSLocalizedString("SERVER_ERROR", comment: "")
                    completion(nil,errorMsg)
                    
                default:
                    print(">>>>>>>error \(statusCode)")
                    let errorMsg = NSLocalizedString("SERVER_ERROR", comment: "") + " \(statusCode)" + "\(statusCode.description ?? "")"
                    completion(nil,errorMsg)
                }
            }else{
                completion(nil,NSLocalizedString("No_Internet", comment: ""))
            }
            
        }
    }
    
}
