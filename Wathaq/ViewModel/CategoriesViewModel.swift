//
//  CategoriesViewModel.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/6/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import ObjectMapper
import Moya



class CategoriesViewModel: ToastAlertProtocol {
    static let shareManager = CategoriesViewModel()
    
    func GetCategories(completion: @escaping (CategoriesRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getCategories, isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {

                let model = Mapper<CategoriesRootClass>().map(JSONString: result as! String)
                if model?.code == 401
                {
                    completion(nil,"errorMsg")

                }
                else
                {
                    let wkalatModel = model?.wkalatTypes
                    completion(model,nil)
                }
              
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
