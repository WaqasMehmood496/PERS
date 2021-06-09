//
//  perm.swift
//  Prosperity Financial
//
//  Created by Buzzware Tech on 27/05/2021.
//

import Foundation
class LoginModel: Codable {
    
    var id:String!
    
    init(id: String? = nil) {
        self.id = id

    }
    
    init?(dic:NSDictionary) {
        
        let id = (dic as AnyObject).value(forKey: Constant.id) as! String
        
        self.id = id

    }
}
