//
//  Diary.swift
//  wasocial
//
//  Created by 陈逸山 on 4/15/17.
//  Copyright © 2017 陈逸山. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct Diary{
    let key: String
    let title: String
    let content:String
    let user: String
    let ref: FIRDatabaseReference?
    
    init(title: String, user: String, content: String, key:String = ""){
        self.key = key
        self.title = title
        self.content = content
        self.user = user
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapshotvalue = snapshot.value as! [String: AnyObject]
        title = snapshotvalue["title"] as! String
        content = snapshotvalue["content"] as! String
        user = snapshotvalue["user"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return[
            "title": title,
            "content": content,
            "user" : user
        ]
    }
    
    
    
}
