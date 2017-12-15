//
//	Orderdata.swift
//
//	Create by Ahmed Zaky on 13/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Orderdata : NSObject, NSCoding, Mappable{

	var acceptedAt : AnyObject?
	var category : Category?
	var client : Client?
	var clientLat : Float?
	var clientLong : Float?
	var clientName : String?
	var cost : Int?
	var createdAt : Int?
	var delivery : String?
	var id : Int?
	var isInAcceptLawyerPeriod : Int?
	var lawyer : AnyObject?
	var nationalID : Int?
	var representativeName : String?
	var status : String?


	class func newInstance(map: Map) -> Mappable?{
		return Orderdata()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		acceptedAt <- map["accepted_at"]
		category <- map["category"]
		client <- map["client"]
		clientLat <- map["clientLat"]
		clientLong <- map["clientLong"]
		clientName <- map["clientName"]
		cost <- map["cost"]
		createdAt <- map["created_at"]
		delivery <- map["delivery"]
		id <- map["id"]
		isInAcceptLawyerPeriod <- map["isInAcceptLawyerPeriod"]
		lawyer <- map["lawyer"]
		nationalID <- map["nationalID"]
		representativeName <- map["representativeName"]
		status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         acceptedAt = aDecoder.decodeObject(forKey: "accepted_at") as? AnyObject
         category = aDecoder.decodeObject(forKey: "category") as? Category
         client = aDecoder.decodeObject(forKey: "client") as? Client
         clientLat = aDecoder.decodeObject(forKey: "clientLat") as? Float
         clientLong = aDecoder.decodeObject(forKey: "clientLong") as? Float
         clientName = aDecoder.decodeObject(forKey: "clientName") as? String
         cost = aDecoder.decodeObject(forKey: "cost") as? Int
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         delivery = aDecoder.decodeObject(forKey: "delivery") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isInAcceptLawyerPeriod = aDecoder.decodeObject(forKey: "isInAcceptLawyerPeriod") as? Int
         lawyer = aDecoder.decodeObject(forKey: "lawyer") as? AnyObject
         nationalID = aDecoder.decodeObject(forKey: "nationalID") as? Int
         representativeName = aDecoder.decodeObject(forKey: "representativeName") as? String
         status = aDecoder.decodeObject(forKey: "status") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if acceptedAt != nil{
			aCoder.encode(acceptedAt, forKey: "accepted_at")
		}
		if category != nil{
			aCoder.encode(category, forKey: "category")
		}
		if client != nil{
			aCoder.encode(client, forKey: "client")
		}
		if clientLat != nil{
			aCoder.encode(clientLat, forKey: "clientLat")
		}
		if clientLong != nil{
			aCoder.encode(clientLong, forKey: "clientLong")
		}
		if clientName != nil{
			aCoder.encode(clientName, forKey: "clientName")
		}
		if cost != nil{
			aCoder.encode(cost, forKey: "cost")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if delivery != nil{
			aCoder.encode(delivery, forKey: "delivery")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isInAcceptLawyerPeriod != nil{
			aCoder.encode(isInAcceptLawyerPeriod, forKey: "isInAcceptLawyerPeriod")
		}
		if lawyer != nil{
			aCoder.encode(lawyer, forKey: "lawyer")
		}
		if nationalID != nil{
			aCoder.encode(nationalID, forKey: "nationalID")
		}
		if representativeName != nil{
			aCoder.encode(representativeName, forKey: "representativeName")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}