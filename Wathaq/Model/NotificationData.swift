//
//	NotificationData.swift
//
//	Create by Ahmed Zaky on 21/1/2018
//	Copyright © 2018 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NotificationData : NSObject, NSCoding, Mappable{

	var content : String?
	var createdAt : Int?
	var orderId : Int?
	var title : String?
	var type : String?


	class func newInstance(map: Map) -> Mappable?{
		return NotificationData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		content <- map["content"]
		createdAt <- map["created_at"]
		orderId <- map["orderId"]
		title <- map["title"]
		type <- map["type"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         orderId = aDecoder.decodeObject(forKey: "orderId") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if content != nil{
			aCoder.encode(content, forKey: "content")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if orderId != nil{
			aCoder.encode(orderId, forKey: "orderId")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}

	}

}