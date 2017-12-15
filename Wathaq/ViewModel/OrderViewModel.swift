//
//  OrderViewModel.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/13/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderViewModel: ToastAlertProtocol {
    static let shareManager = CategoriesViewModel()
    
    func CreateOrder(OrderDic:NSDictionary, completion: @escaping (OrderRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .CreateOrder(categoryId: OrderDic.object(forKey: "categoryId") as! String, clientName: OrderDic.object(forKey: "clientName") as! String, representativeName: OrderDic.object(forKey: "representativeName") as! String, clientNationalID: OrderDic.object(forKey: "clientNationalID") as! String, representativeNationalID: OrderDic.object(forKey: "representativeNationalID") as! String , delivery: OrderDic.object(forKey: "delivery") as! String, latitude: OrderDic.object(forKey: "latitude") as! Double, longitude: OrderDic.object(forKey: "longitude") as! Double), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<OrderRootClass>().map(JSONString: result as! String)!

            } else{
                completion(nil,errorMsg)
            }
        }
    }
}
