//
//  perm.swift
//  Prosperity Financial
//
//  Created by Buzzware Tech on 27/05/2021.
//

import Foundation
class LoginModel: Codable {
    
    var email:String!
    var full_name:String!
    var location:String!
    var mobilenumber:String!
    var password:String!
    
    init(email: String? = nil,full_name: String? = nil,location: String? = nil,mobilenumber: String? = nil,password: String? = nil) {
        self.email = email
        self.full_name = full_name
        self.location = location
        self.mobilenumber = mobilenumber
        self.password = password
        
    }
    
    init?(dic:NSDictionary) {
        
        let email = (dic as AnyObject).value(forKey: Constant.email) as! String
        let full_name = (dic as AnyObject).value(forKey: Constant.full_name) as! String
        let location = (dic as AnyObject).value(forKey: Constant.location) as! String
        let mobilenumber = (dic as AnyObject).value(forKey: Constant.mobilenumber) as! String
        let password = (dic as AnyObject).value(forKey: Constant.password) as! String
        
        self.email = email
        self.full_name = full_name
        self.location = location
        self.mobilenumber = mobilenumber
        self.password = password
        
    }
}
