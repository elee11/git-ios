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
    
    func loginUser(Phone:[String: String], completion: @escaping (User?, String?) -> ()){
        print(Phone)

        NetworkHandler.requestTarget(target: .login(Phone), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<UserRootClass>().map(JSONString: result as! String)!
                let userModel = model.user
                completion(userModel,nil)
                if userModel?.isCompleteProfile == true
                {
                do {
                self.deleteUser()
                let realm = try! Realm()
                try realm.write {
                    realm.add(userModel!, update: true)
                }
                } catch {
                    completion(nil, "fail parsing objects")
                }
                }
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func deleteUser () {
        if isUserLogined() {
            let realm = try! Realm()
            let userResults = realm.objects(User.self)
            
            try! realm.write {
                realm.delete(userResults)
            }
        }
    }
    
    func getToken () -> String? {
        if let token   = self.getUser()?.token {
            return ("bearer " + token)
        }else{
            return nil
        }
    }
    
    func getUser () -> User? {
        let realm = try! Realm()
        let userResults: Results<User> = realm.objects(User.self)
        if let user: User = userResults.first {
            return user
        }
        return nil
    }
    
    
    
}
