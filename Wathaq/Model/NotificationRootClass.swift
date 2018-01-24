//
//	NotificationRootClass.swift
//
//	Create by Ahmed Zaky on 21/1/2018
//	Copyright © 2018 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NotificationRootClass : NSObject, NSCoding, Mappable{

	var notificationData : [NotificationData]?
	var code : Int?
	var message : String?
	var status : String?


	class func newInstance(map: Map) -> Mappable?{
		return NotificationRootClass()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		notificationData <- map["data"]
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
         notificationData = aDecoder.decodeObject(forKey: "data") as? [NotificationData]
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
		if notificationData != nil{
			aCoder.encode(notificationData, forKey: "data")
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
