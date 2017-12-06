//
//  CategoriesViewModel.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/6/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import ObjectMapper


class CategoriesViewModel: ToastAlertProtocol {
    static let shareManager = CategoriesViewModel()
    
    func GetCategories(completion: @escaping (WkalatType?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getCategories, isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<CategoriesRootClass>().map(JSONString: result as! String)!
                let wkalatModel = model.wkalatTypes
                completion(wkalatModel,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }

}
