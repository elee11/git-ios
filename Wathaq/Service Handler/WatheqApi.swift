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
    case ContactUs(title:String, content:String)

    case logout(identifier:String)
    //Order
    case getCategories
    case CreateOrder(categoryId:Int, delivery:String, latitude:Double, longitude:Double , time:String,marriageDate:String , address:String )
    case createNekahOrder(categoryId:Int,delivery:String,latitude:Double, longitude:Double,marriageDate:String,marriageTime:String,address:String)
    case createContractOrder(categoryId:Int,delivery:String,latitude:Double, longitude:Double,time:String,marriageDate:String , address:String )
    case RateOrder(orderId:Int,rate:Int)
    case getNewOrders(Int,Int)
    case getPendingOrders(Int,Int)
    case getClosedOrders(Int,Int)
    case getLawyerList(Int,Int,Int)
    case selectLawyer (Int,Int)
    case getNotification
    case RemoveOrder (Int)


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
        case .CreateOrder:
            return "api/auth/order"
        case .createNekahOrder:
            return "api/auth/order"
        case .createContractOrder:
            return "api/auth/order"
        case .getLawyerList:
            return "api/auth/order/laywersList"
        case .selectLawyer :
            return "api/auth/client/order/selectLaywer"
        case .getNewOrders:
            return "api/auth/client/order/listNewOrders"
        case .getPendingOrders:
            return "api/auth/client/order/listPendingOrders"
        case .getClosedOrders:
            return "api/auth/client/order/listClosedOrders"
        case .getNotification :
            return "api/auth/notification/list"
        case .RateOrder:
            return "api/auth/client/order/rate"
        case .ContactUs :
            return "api/auth/contactus/create"
        case .RemoveOrder :
            return "api/auth/client/order/remove"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .login,.completeProfile,.UpdateProfile,.registerDeviceToken,.logout,.CreateOrder,.createNekahOrder,.createContractOrder,.RateOrder,.ContactUs:
            return .post
        case .getCategories,.getNewOrders,.getPendingOrders,.getClosedOrders,.getLawyerList,.selectLawyer,.getNotification,.RemoveOrder:
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
        case .ContactUs(let title, let content):
            return .requestParameters(parameters: ["title":title , "content" :content], encoding: JSONEncoding.default)
        case .logout(let identifier):
            return .requestParameters(parameters: ["identifier":identifier], encoding: JSONEncoding.default)
        case .RateOrder(let orderId,let rate):
            return .requestParameters(parameters: ["orderId":orderId,"rate":rate], encoding: JSONEncoding.default)
        case .getCategories:
            return .requestPlain
        case .getLawyerList(let orderId,let page, let limit):
            return .requestParameters(parameters: ["orderId":orderId , "page":page , "limit" : limit], encoding: URLEncoding.default)
        case .selectLawyer(let orderId, let lawyerId):
            return .requestParameters(parameters: ["orderId":orderId , "lawyerId" : lawyerId], encoding: URLEncoding.default)
        case .getNewOrders(let page, let limit):
            return .requestParameters(parameters: ["page":page , "limit" : limit], encoding: URLEncoding.default)
        case .getPendingOrders(let page, let limit):
            return .requestParameters(parameters: ["page":page , "limit" : limit], encoding: URLEncoding.default)
        case .getClosedOrders(let page, let limit):
            return .requestParameters(parameters: ["page":page , "limit" : limit], encoding: URLEncoding.default)
        case .CreateOrder(let categoryId, let delivery, let latitude, let longitude , let time,let  marriageDate,let address ):
            return .requestParameters(parameters: ["categoryId":categoryId ,"delivery":delivery, "latitude":latitude, "longitude":longitude, "time":time,"marriageDate":marriageDate , "address":address], encoding: JSONEncoding.default)
        case .createNekahOrder(let categoryId,let delivery,let latitude,let longitude,let marriageDate,let  marriageTime ,let address):
            return .requestParameters(parameters: ["categoryId":categoryId, "delivery":delivery,"latitude":latitude,"longitude":longitude,"marriageDate":marriageDate,"marriageTime":marriageTime, "address":address], encoding: JSONEncoding.default)
            
        case .createContractOrder(let categoryId,let delivery,let latitude,let longitude, let time,let  marriageDate,let address):
            return .requestParameters(parameters: ["categoryId":categoryId, "delivery":delivery,"latitude":latitude,"longitude":longitude, "time":time,"marriageDate":marriageDate , "address":address], encoding: JSONEncoding.default)
        case .getNotification:
            return .requestPlain
        case .RemoveOrder(let orderId):
            return .requestParameters(parameters: ["orderId":orderId], encoding: URLEncoding.default)
            
        }
    }
    
    public var authorizationType: AuthorizationType {
        switch self {
        case .login:
            return .none
        case .completeProfile,.UpdateProfile,.registerDeviceToken,.logout,.getCategories,.CreateOrder,.createNekahOrder,.createContractOrder,.getNewOrders,.getClosedOrders,.getPendingOrders,.getLawyerList,.selectLawyer,.getNotification,.RateOrder,.ContactUs,.RemoveOrder:
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



