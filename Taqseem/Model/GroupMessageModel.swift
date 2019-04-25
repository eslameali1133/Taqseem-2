//
//  GroupMessageModel.swift
//  Taqseem
//
//  Created by Husseinomda16 on 4/16/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import Foundation
import UIKit

class GroupMessageModelClass: NSObject {
    var _id = ""
    var _userId = ""
    var _from = ""
    var _message = ""
    var _created_at = ""
    init(
        id : String ,
        userId : String ,
        from : String ,
        message : String ,
        created_at :String
        ) {
        self._id = id
        self._userId = userId
        self._from = from
        self._message = message
        self._created_at = created_at
    }
}
