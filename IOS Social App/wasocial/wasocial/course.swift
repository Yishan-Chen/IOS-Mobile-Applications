//
//  course.swift
//  wasocial
//
//  Created by 陈逸山 on 4/16/17.
//  Copyright © 2017 陈逸山. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Course{
    let course:String
    let key: String
    let ref: FIRDatabaseReference?
    
    init(course: String, key: String = ""){
        self.key = key
        self.course = course
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapshotvalue = snapshot.value as! [String: AnyObject]
        course = snapshotvalue["course"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any{
        return[
            "course": course
        ]
    }
    
}
