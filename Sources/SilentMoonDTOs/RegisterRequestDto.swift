//
//  RegisterRequest.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 30.07.26.
//

import Foundation

   public struct RegisterRequest: Encodable {
       public let name: String
       public let email: String
       public let password: String
       
   public init(name: String, email: String, password: String) {
           self.name = name
           self.email = email
           self.password = password
       }
     
      public  enum CodingKeys: String, CodingKey {
            case name = "name"
            case email = "email"
            case password = "password"
        }
    }


