//
//	NewOrderRequestRootClass.swift
//
//	Create by Ahmed Zaky on 17/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NewOrderRequestRootClass : NSObject, NSCoding, Mappable{

	var code : Int?
	var data : [Orderdata]?
	var message : String?
	var status : String?


	class func newInstance(map: Map) -> Mappable?{
		return NewOrderRequestRootClass()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		code <- map["code"]
		data <- map["data"]
		message <- map["message"]
		status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         code = aDecoder.decodeObject(forKey: "code") as? Int
         data = aDecoder.decodeObject(forKey: "data") as? [Orderdata]
         message = aDecoder.decodeObject(forKey: "message") as? String
         status = aDecoder.decodeObject(forKey: "status") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
