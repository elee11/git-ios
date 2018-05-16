//
//  LoginViewModel.swift
//  EngineeringSCE
//
//  Created by Basant on 6/11/17.
//  Copyright © 2017 sce. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import RealmSwift


class UserViewModel: ToastAlertProtocol {
    
    static let shareManager = UserViewModel()
    
    func isUserLogined () -> Bool{
        
        if self.getToken() != nil {
            return true
        }else{
            return false
        }
    }
    
    func loginUser(Phone:String, completion: @escaping (User?, String?) -> ()){
        print(Phone)

        NetworkHandler.requestTarget(target: .login(phone: Phone), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<UserRootClass>().map(JSONString: result as! String)!
                let userModel = model.user
                UserDefaults.standard.rm_setCustomObject(userModel, forKey: Constants.keys.KeyUser)
                completion(userModel,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func RegisterDeviceToken(identifier:String,firebaseToken:String, completion: @escaping (String, String?) -> ()){
        
        NetworkHandler.requestTarget(target: .registerDeviceToken(identifier: identifier,firebaseToken:firebaseToken), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                completion("",nil)
            } else{
                completion("",errorMsg)
            }
        }
    }
    
    func logoutUser(identifier:String, completion: @escaping (String?, String?) -> ()){
        
        NetworkHandler.requestTarget(target: .logout(identifier: identifier), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
               // let model = Mapper<UserRootClass>().map(JSONString: result as! String)!
                //let userModel = model.user
                completion("Success",nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func completeUserProfile(userName:String,UseEmail:String,UseImage:String, completion: @escaping (User?, String?) -> ()){
        
        NetworkHandler.requestTarget(target: .completeProfile(name: userName, email: UseEmail, image: UseImage), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<UserRootClass>().map(JSONString: result as! String)!
                let userModel = model.user
                if userModel?.isCompleteProfile == true
                {
                    UserDefaults.standard.rm_setCustomObject(userModel, forKey: Constants.keys.KeyUser)
                }
                completion(userModel,nil)

            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func updateUserProfile(userName:String,UseEmail:String,UseImage:String,userPhone:String, completion: @escaping (User?, String?) -> ()){
        
        NetworkHandler.requestTarget(target: .UpdateProfile(name: userName, email: UseEmail, image: UseImage, phone: userPhone), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<UserRootClass>().map(JSONString: result as! String)!
                let userModel = model.user
                completion(userModel,nil)
                if userModel?.isCompleteProfile == true
                {
                    UserDefaults.standard.rm_setCustomObject(userModel, forKey: Constants.keys.KeyUser)
                }
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func deleteUser () {
        if isUserLogined() {
            UserDefaults.standard.removeObject(forKey: Constants.keys.KeyUser)
        }
    }
    
    func getToken () -> String? {
        if let token   = self.getUser()?.token {
             var TokenNoBearer = token
            if let range = TokenNoBearer.range(of: "Bearer ") {
                TokenNoBearer.removeSubrange(range)
                 return (TokenNoBearer)
            }
            else
            {
                return token
            }
        }else{
            return nil
        }
    }
    
    func getUser () -> User? {

        if let user: User = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User {
            return user
        }
        return nil
    }
    
    
    
}
