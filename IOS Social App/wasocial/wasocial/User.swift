//
//  User.swift
//  wasocial
//
//  Created by 陈逸山 on 4/15/17.
//  Copyright © 2017 陈逸山. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser){
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String){
        self.uid = uid
        self.email = email
    }
}
