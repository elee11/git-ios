//
//  WatheqApi.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/1/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import Foundation
import Moya

// MARK: - Provider setup


private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let endpointClosure = { (target: WatheqApi) -> Endpoint<WatheqApi> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    var lang = Language.getCurrentLanguage()
    if lang == "en-US" {
        lang = "en"
    }
    return defaultEndpoint.adding(newHTTPHeaderFields: ["X-Api-Language":lang])
}

let token = UserViewModel.shareManager.getToken()
let authPlugin = AccessTokenPlugin(tokenClosure: token!)


let WatheqProvider = MoyaProvider<WatheqApi>(
    
    endpointClosure: endpointClosure,
    manager: DefaultAlamofireManager.sharedManager,
    plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),authPlugin]
)

// MARK: - Provider support

private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}



public enum WatheqApi {
    //User Login 
    case login(phone:String)
    case completeProfile(name:String, email:String, image:String)
    case UpdateProfile(name:String, email:String, image:String, phone:String)
    case registerDeviceToken(identifier:String, firebaseToken:String)
    case logout(identifier:String)
    case getCategories



}

extension WatheqApi: TargetType,AccessTokenAuthorizable {
    public var headers : [String : String]? {
        return ["Content-type": "application/json" , Constants.WebService.ApiKeyName: Constants.WebService.ApiKeyValue]
    }
    
    public var baseURL: URL { return URL(string: Constants.ApiConstants.BaseUrl)! }
    public var path: String {
        switch self {
        case .login:
            return "api/client/login"
        case .completeProfile:
            return "api/auth/client/completeProfile"
        case .UpdateProfile:
            return "api/auth/client/updateProfile"
        case .registerDeviceToken:
            return "api/auth/client/registerDeviceToken"
        case .logout:
            return "api/auth/client/logout"
        case .getCategories:
            return "api/auth/category/list"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .login,.completeProfile,.UpdateProfile,.registerDeviceToken,.logout:
            return .post
        case .getCategories:
            return .get
        }
    }
    
    public var task : Task {
        switch self {
        case .login(let phone):
            return .requestParameters(parameters: ["phone":phone], encoding: JSONEncoding.default)
        case .completeProfile(let name,let email,let image):
            return .requestParameters(parameters: ["name":name , "email":email , "image":image], encoding: JSONEncoding.default)
        case .UpdateProfile(let name,let email,let image,let phone):
            return .requestParameters(parameters: ["name":name , "email":email , "image":image, "phone":phone], encoding: JSONEncoding.default)
        case .registerDeviceToken(let identifier, let firebaseToken):
            return .requestParameters(parameters: ["identifier":identifier , "firebaseToken" :firebaseToken], encoding: JSONEncoding.default)
        case .logout(let identifier):
            return .requestParameters(parameters: ["identifier":identifier], encoding: JSONEncoding.default)
        case .getCategories:
            return .requestPlain
        }
    }
    
    public var authorizationType: AuthorizationType {
        switch self {
        case .login:
            return .none
        case .completeProfile,.UpdateProfile,.registerDeviceToken,.logout,.getCategories :
            return .bearer
        }
    }
    
    public var validate: Bool {
        
        return false
    }
    public var sampleData: Data { return Data() }  // We just need to return something here to fully implement the protocol
}
public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}



