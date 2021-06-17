//
//  FriendModel.swift
//  PERS
//
//  Created by Buzzware Tech on 17/06/2021.
//

import Foundation
class FriendModel: Codable {
    
    var id:String!
    init(id: String? = nil) {
        self.id = id
    }
    init?(dic:NSDictionary) {
        let id = (dic as AnyObject).value(forKey: Constant.id) as? String
        self.id = id
    }
}
//
//class FriendStatusModel: Codable {
//    
//    var isFriend:Bool!
//    init(isFriend: Bool? = false) {
//        self.isFriend = isFriend
//    }
//    
//    init?(dic:NSDictionary) {
//        let isFriend = (dic as AnyObject).value(forKey: Constant.isFriend) as! Bool
//        self.isFriend = isFriend
//    }
//}