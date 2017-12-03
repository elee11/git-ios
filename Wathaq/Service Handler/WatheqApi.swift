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

let ApiKeyToken = "85BCbm7U7JsQdbB5Z95vmvN4LyQmqVxp"

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
    return defaultEndpoint.adding(newHTTPHeaderFields: ["x-language":lang])
}



struct AuthPlugin: PluginType, ToastAlertProtocol {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.addValue("85BCbm7U7JsQdbB5Z95vmvN4LyQmqVxp", forHTTPHeaderField: "X_Api_Key")
        return request
    }
}


let WatheqProvider = MoyaProvider<WatheqApi>(
    
    endpointClosure: endpointClosure,
    manager: DefaultAlamofireManager.sharedManager,
    plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),AuthPlugin()]
)

// MARK: - Provider support

private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum RequestData {
    case jsonEncodable(Encodable)
    case parameterEncoding([String: Any], ParameterEncoding?) // a default parameter encoding could be provided in the TargetType, too (with an empty default implementation)
}

public enum WatheqApi {
    case login(String)
}

extension WatheqApi: TargetType {
    public var baseURL: URL { return URL(string: "http://138.197.41.25/watheq/public/api")! }
    public var parameterEncoding: Moya.ParameterEncoding { return JSONEncoding.prettyPrinted }

    public var path: String {
        switch self {
        case .login:
            return "/client/login"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
     var parameters: RequestData? {
        switch self {
        case .login(let phone):
            return .parameterEncoding(["phone": phone], JSONEncoding.default)

        }
    }
    
   
   
    public var task: Task {
        return Task.requestPlain
    }
    public var headers: [String : String]? {
        return nil
    }
    public var sampleData: Data {
        switch self {
        case .login:
            return "Sample data".data(using: String.Encoding.utf8)!
        }
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}



