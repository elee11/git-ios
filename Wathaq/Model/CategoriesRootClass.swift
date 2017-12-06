//
//	CategoriesRootClass.swift
//
//	Create by Ahmed Zaky on 6/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CategoriesRootClass : NSObject, NSCoding, Mappable{

	var wkalatTypes : WkalatType?
	var code : Int?
	var message : String?
	var status : String?


	class func newInstance(map: Map) -> Mappable?{
		return CategoriesRootClass()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		wkalatTypes <- map["data"]
		code <- map["code"]
		message <- map["message"]
		status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         wkalatTypes = aDecoder.decodeObject(forKey: "data") as? WkalatType
         code = aDecoder.decodeObject(forKey: "code") as? Int
         message = aDecoder.decodeObject(forKey: "message") as? String
         status = aDecoder.decodeObject(forKey: "status") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if wkalatTypes != nil{
			aCoder.encode(wkalatTypes, forKey: "data")
		}
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
