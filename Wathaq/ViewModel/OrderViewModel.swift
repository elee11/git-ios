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
        NetworkHandler.requestTarget(target: .CreateOrder(categoryId: OrderDic.object(forKey: "categoryId") as! Int, clientName: OrderDic.object(forKey: "clientName") as! String, representativeName: OrderDic.object(forKey: "representativeName") as! String, clientNationalID: OrderDic.object(forKey: "clientNationalID") as! String, representativeNationalID: OrderDic.object(forKey: "representativeNationalID") as! String , delivery: OrderDic.object(forKey: "delivery") as! String, latitude: OrderDic.object(forKey: "latitude") as! Double, longitude: OrderDic.object(forKey: "longitude") as! Double, time: OrderDic.object(forKey: "time") as! String, address: OrderDic.object(forKey: "address") as! String), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<OrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)

            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    
    func CreateNekahOrder(OrderDic:NSDictionary, completion: @escaping (OrderRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .createNekahOrder(categoryId: OrderDic.object(forKey: "categoryId") as! Int, delivery: OrderDic.object(forKey: "delivery") as! String, latitude: OrderDic.object(forKey: "latitude") as! Double, longitude: OrderDic.object(forKey: "longitude") as! Double, marriageDate: OrderDic.object(forKey: "marriageDate") as! String, marriageTime: OrderDic.object(forKey: "marriageTime") as! String,address: OrderDic.object(forKey: "address") as! String), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<OrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    
    func CreateContractOrder(OrderDic:NSDictionary, completion: @escaping (OrderRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .createContractOrder(categoryId: OrderDic.object(forKey: "categoryId") as! Int, delivery: OrderDic.object(forKey: "delivery") as! String, latitude: OrderDic.object(forKey: "latitude") as! Double, longitude: OrderDic.object(forKey: "longitude") as! Double, letterDate: OrderDic.object(forKey: "letterDate") as! String, letterNumber: OrderDic.object(forKey: "letterNumber") as! String , time: OrderDic.object(forKey: "time") as! String, address: OrderDic.object(forKey: "address") as! String), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<OrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func RateOrder(orderId:Int,rate :Int, completion: @escaping (OrderRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .RateOrder(orderId: orderId, rate: rate), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<OrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func getNewOrders(orderPageNum:Int,completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getNewOrders(orderPageNum, 10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)
                let Ordermodel = model?.data
                completion(model,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }

    
    func getLawyerList(OrderId:Int,PageNum:Int, completion: @escaping (MoawtheqRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getLawyerList(OrderId,PageNum,10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let LawyerRootObj = Mapper<MoawtheqRootClass>().map(JSONString: result as! String)
                completion(LawyerRootObj,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func selectLawyer(OrderId:Int,lawyerid:Int, completion: @escaping (OrderRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .selectLawyer(OrderId, lawyerid), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<OrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }

    
    func getPendingOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getPendingOrders(orderPageNum,10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }

    
    func getClosedOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getClosedOrders(orderPageNum,10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }

}
