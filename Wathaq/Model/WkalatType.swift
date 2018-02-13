//
//	WkalatType.swift
//
//	Create by Ahmed Zaky on 6/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class WkalatType : NSObject, NSCoding, Mappable{

	var categories : [CatObject]?
	var deliverToHomeFees : Int?


	class func newInstance(map: Map) -> Mappable?{
		return WkalatType()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		categories <- map["categories"]
		deliverToHomeFees <- map["deliverToHomeFees"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         categories = aDecoder.decodeObject(forKey: "categories") as? [CatObject]
         deliverToHomeFees = aDecoder.decodeObject(forKey: "deliverToHomeFees") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if categories != nil{
			aCoder.encode(categories, forKey: "categories")
		}
		if deliverToHomeFees != nil{
			aCoder.encode(deliverToHomeFees, forKey: "deliverToHomeFees")
		}

	}

}
