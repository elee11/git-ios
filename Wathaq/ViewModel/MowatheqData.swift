//
//	MowatheqData.swift
//
//	Create by Ahmed Zaky on 7/1/2018
//	Copyright © 2018 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class MowatheqData : NSObject, NSCoding, Mappable{

	var iDCardFile : String?
	var active : Int?
	var createdAt : Int?
	var email : String?
	var id : Int?
	var image : String?
	var isCompleteFiles : Int?
	var isCompleteProfile : Int?
	var language : String?
	var latitude : Float?
	var lawyerType : String?
	var licenseFile : String?
	var longitude : Float?
	var name : String?
	var phone : Int?
	var token : String?


	class func newInstance(map: Map) -> Mappable?{
		return MowatheqData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		iDCardFile <- map["IDCardFile"]
		active <- map["active"]
		createdAt <- map["created_at"]
		email <- map["email"]
		id <- map["id"]
		image <- map["image"]
		isCompleteFiles <- map["isCompleteFiles"]
		isCompleteProfile <- map["isCompleteProfile"]
		language <- map["language"]
		latitude <- map["latitude"]
		lawyerType <- map["lawyerType"]
		licenseFile <- map["licenseFile"]
		longitude <- map["longitude"]
		name <- map["name"]
		phone <- map["phone"]
		token <- map["token"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         iDCardFile = aDecoder.decodeObject(forKey: "IDCardFile") as? String
         active = aDecoder.decodeObject(forKey: "active") as? Int
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         email = aDecoder.decodeObject(forKey: "email") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         isCompleteFiles = aDecoder.decodeObject(forKey: "isCompleteFiles") as? Int
         isCompleteProfile = aDecoder.decodeObject(forKey: "isCompleteProfile") as? Int
         language = aDecoder.decodeObject(forKey: "language") as? String
         latitude = aDecoder.decodeObject(forKey: "latitude") as? Float
         lawyerType = aDecoder.decodeObject(forKey: "lawyerType") as? String
         licenseFile = aDecoder.decodeObject(forKey: "licenseFile") as? String
         longitude = aDecoder.decodeObject(forKey: "longitude") as? Float
         name = aDecoder.decodeObject(forKey: "name") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? Int
         token = aDecoder.decodeObject(forKey: "token") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if iDCardFile != nil{
			aCoder.encode(iDCardFile, forKey: "IDCardFile")
		}
		if active != nil{
			aCoder.encode(active, forKey: "active")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if isCompleteFiles != nil{
			aCoder.encode(isCompleteFiles, forKey: "isCompleteFiles")
		}
		if isCompleteProfile != nil{
			aCoder.encode(isCompleteProfile, forKey: "isCompleteProfile")
		}
		if language != nil{
			aCoder.encode(language, forKey: "language")
		}
		if latitude != nil{
			aCoder.encode(latitude, forKey: "latitude")
		}
		if lawyerType != nil{
			aCoder.encode(lawyerType, forKey: "lawyerType")
		}
		if licenseFile != nil{
			aCoder.encode(licenseFile, forKey: "licenseFile")
		}
		if longitude != nil{
			aCoder.encode(longitude, forKey: "longitude")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}

	}

}