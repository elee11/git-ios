//
//	User.swift
//
//	Create by Ahmed Zaky on 1/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper
import RealmSwift



class User : Object, NSCoding, Mappable{

	var createdAt : Int?
	var email : String?
    @objc dynamic var id = 0
	var image : String?
	var isCompleteProfile : Bool?
	var language : String?
	var name : String?
	var phone : Int?
	var token : String?


    class func newInstance(map: Map) -> Mappable?{
        return User()
    }
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }

	func mapping(map: Map)
	{
		createdAt <- map["created_at"]
		email <- map["email"]
		id <- map["id"]
		image <- map["image"]
		isCompleteProfile <- map["isCompleteProfile"]
		language <- map["language"]
		name <- map["name"]
		phone <- map["phone"]
		token <- map["token"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    convenience required init(coder aDecoder: NSCoder)
	{
        self.init()
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         email = aDecoder.decodeObject(forKey: "email") as? String
        id = (aDecoder.decodeObject(forKey: "id") as? Int)!
         image = aDecoder.decodeObject(forKey: "image") as? String
         isCompleteProfile = aDecoder.decodeObject(forKey: "isCompleteProfile") as? Bool
         language = aDecoder.decodeObject(forKey: "language") as? String
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
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
        aCoder.encode(id, forKey: "id")

		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if isCompleteProfile != nil{
			aCoder.encode(isCompleteProfile, forKey: "isCompleteProfile")
		}
		if language != nil{
			aCoder.encode(language, forKey: "language")
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
