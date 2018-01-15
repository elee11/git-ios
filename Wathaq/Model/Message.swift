//  MIT License

//  Copyright (c) 2017 Satish Babariya

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation
import UIKit
import Firebase

class Message {
    
    //MARK: Properties
    var from: String
    var to: String
    var body: String
    var timestamp: Int
    var dayTimestamp: Int

 

//    //MARK: Methods
    class func downloadAllMessages(toID: String, orderId:String, completion: @escaping (Message) -> Swift.Void) {
        
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User
        if let currentUserID = userObj?.userID{
            Database.database().reference().child("messages").child("\(currentUserID as! Int)").child("\(currentUserID as! Int)\(toID )\(orderId)").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                   // let data = snapshot.value as! [String: String]
                    Database.database().reference().child("messages").child("\(currentUserID as! Int)").child("\(currentUserID as! Int)\(toID )\(orderId)").observe(.childAdded, with: { (snap) in
                        if snap.exists() {
                            let receivedMessage = snap.value as! [String: Any]
                            let content = receivedMessage["body"] as! String
                            let fromID = receivedMessage["from"] as! String
                            let to = receivedMessage["to"] as! String

                            let timestamp = receivedMessage["timestamp"] as! Int
                            let message = Message.init(from: fromID, to: to, body: content, timestamp: timestamp, dayTimestamp: 123)
                            completion(message)

                            
                        }
                    })
                }
            })
        }
    }
//

//
//    class func markMessagesRead(forUserID: String)  {
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.exists() {
//                    let data = snapshot.value as! [String: String]
//                    let location = data["location"]!
//                    Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
//                        if snap.exists() {
//                            for item in snap.children {
//                                let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
//                                let fromID = receivedMessage["fromID"] as! String
//                                if fromID != currentUserID {
//                                    Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
//                                }
//                            }
//                        }
//                    })
//                }
//            })
//        }
//    }
//
//    class func unReadMessagesCount(forUserID: String , completion: @escaping (Int) -> Swift.Void) {
//        var count : Int = 0
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.exists() {
//                    let data = snapshot.value as! [String: String]
//                    let location = data["location"]!
//                    Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
//                        if snap.exists() {
//                            for item in snap.children {
//                                let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
//                                let fromID = receivedMessage["fromID"] as! String
//                                if fromID != currentUserID {
//                                    //Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
//                                    Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").queryOrderedByValue().queryEqual(toValue: false).observe(.value) { (data: DataSnapshot) in
//                                        count = count + 1
//                                    }
//                                }
//                            }
//                            completion(count)
//                        }
//                    })
//                }
//            })
//        }
//    }
//
//    func downloadLastMessage(forLocation: String, completion: @escaping (Void) -> Swift.Void) {
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            Database.database().reference().child("conversations").child(forLocation).observe(.value, with: { (snapshot) in
//                if snapshot.exists() {
//                    for snap in snapshot.children {
//                        let receivedMessage = (snap as! DataSnapshot).value as! [String: Any]
//                        self.content = receivedMessage["content"]!
//                        self.timestamp = receivedMessage["timestamp"] as! Int
//                        let messageType = receivedMessage["type"] as! String
//                        let fromID = receivedMessage["fromID"] as! String
//                        self.isRead = receivedMessage["isRead"] as! Bool
//                        var type = MessageType.text
//                        switch messageType {
//                        case "text":
//                            type = .text
//                        case "photo":
//                            type = .photo
//                        case "location":
//                            type = .location
//                        default: break
//                        }
//                        self.type = type
//                        if currentUserID == fromID {
//                            self.owner = .receiver
//                        } else {
//                            self.owner = .sender
//                        }
//                        completion()
//                    }
//                }
//            })
//        }
//    }

    class func send(message: Message, toID: String, orderId:String, completion: @escaping (Bool) -> Swift.Void)  {
        
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User

        
        let values = ["body": message.body, "from":"\(userObj?.userID as! Int)" , "to": toID , "timestamp":Int(Date().timeIntervalSince1970) , "negatedTimestamp":-Int(Date().timeIntervalSince1970)] as [String : Any]
        Message.uploadMessage(withValues: values, toID: toID, orderId:orderId ,  completion: { (status) in
            completion(status)
        })
    }
    
    
    class func uploadMessage(withValues: [String: Any], toID: String,orderId:String, completion: @escaping (Bool) -> Swift.Void) {
        
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User

        
        if let currentUserID = userObj?.userID
        {
            Database.database().reference().child("messages").child("\(currentUserID as! Int)").child("\(currentUserID as! Int)\(toID )\(orderId)").childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
       
        })
            
            Database.database().reference().child("messages").child(toID).child("\(currentUserID as! Int)\(toID )\(orderId)").childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in

            })
        }
    }
    

    
    //MARK: Inits
    init(from: String, to: String, body: String, timestamp: Int, dayTimestamp: Int) {
        self.from = from
        self.to = to
        self.body = body
        self.timestamp = timestamp
        self.dayTimestamp = dayTimestamp
    }
}
