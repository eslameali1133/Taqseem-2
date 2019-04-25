//
//  MessageModel.swift
//  Taqseem
//
//  Created by Husseinomda16 on 4/10/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import Foundation
import UIKit

class MessageModelClass: NSObject {
    var _username = ""
    var _id = ""
    var _message = ""
    var _from = ""
    var _to = ""
    var _seen = ""
    var _created_at = ""
    var _updated_at = ""
    init(
        username : String ,
        id:String ,
        message : String ,
        from : String ,
        to : String ,
        seen :String ,
        created_at :String ,
        updated_at :String
        ) {
        self._username = username
        self._id = id
        self._message = message
        self._from = from
        self._to = to
        self._seen = seen
        self._created_at = created_at
        self._updated_at = updated_at
    }
}
