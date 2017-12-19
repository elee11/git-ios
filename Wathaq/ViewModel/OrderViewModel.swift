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
        NetworkHandler.requestTarget(target: .CreateOrder(categoryId: OrderDic.object(forKey: "categoryId") as! Int, clientName: OrderDic.object(forKey: "clientName") as! String, representativeName: OrderDic.object(forKey: "representativeName") as! String, clientNationalID: OrderDic.object(forKey: "clientNationalID") as! String, representativeNationalID: OrderDic.object(forKey: "representativeNationalID") as! String , delivery: OrderDic.object(forKey: "delivery") as! String, latitude: OrderDic.object(forKey: "latitude") as! Double, longitude: OrderDic.object(forKey: "longitude") as! Double), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<OrderRootClass>().map(JSONString: result as! String)!
                completion(Ordermodel,nil)

            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    
    func getNewOrders(orderPageNum:Int,completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getNewOrders, isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)!
                let Ordermodel = model.data
                completion(model,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }


    
    func getPendingOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getPendingOrders(orderPageNum), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)!
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }

    
    func getClosedOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getClosedOrders(orderPageNum), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)!
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }

}
