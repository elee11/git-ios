//
//	Client.swift
//
//	Create by Ahmed Zaky on 13/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Client : NSObject, NSCoding, Mappable{

	var id : Int?
	var lat : AnyObject?
	var longField : AnyObject?
	var name : String?
	var phone : Int?


	class func newInstance(map: Map) -> Mappable?{
		return Client()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["id"]
		lat <- map["lat"]
		longField <- map["long"]
		name <- map["name"]
		phone <- map["phone"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? Int
         lat = aDecoder.decodeObject(forKey: "lat") as? AnyObject
         longField = aDecoder.decodeObject(forKey: "long") as? AnyObject
         name = aDecoder.decodeObject(forKey: "name") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if longField != nil{
			aCoder.encode(longField, forKey: "long")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}

	}

}