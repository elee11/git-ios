//
//	Category.swift
//
//	Create by Ahmed Zaky on 6/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Category : NSObject, NSCoding, Mappable{

	var cost : Int?
	var discription : String?
	var hasSubs : Int?
	var id : Int?
	var name : String?
	var subs : AnyObject?


	class func newInstance(map: Map) -> Mappable?{
		return Category()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		cost <- map["cost"]
		discription <- map["discription"]
		hasSubs <- map["hasSubs"]
		id <- map["id"]
		name <- map["name"]
		subs <- map["subs"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cost = aDecoder.decodeObject(forKey: "cost") as? Int
         discription = aDecoder.decodeObject(forKey: "discription") as? String
         hasSubs = aDecoder.decodeObject(forKey: "hasSubs") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         subs = aDecoder.decodeObject(forKey: "subs") as? AnyObject

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cost != nil{
			aCoder.encode(cost, forKey: "cost")
		}
		if discription != nil{
			aCoder.encode(discription, forKey: "discription")
		}
		if hasSubs != nil{
			aCoder.encode(hasSubs, forKey: "hasSubs")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if subs != nil{
			aCoder.encode(subs, forKey: "subs")
		}

	}

}