//
//  NotificationModel.swift
//  Taqseem
//
//  Created by Husseinomda16 on 4/23/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import Foundation
import UIKit

class NotificationModelClass: NSObject {
    
    var _msg = ""
    var _type = ""
    var _type_id = ""
    var _from = ""
    var _seen = ""
    var _created_at = ""
    init(
        msg : String ,
        type:String ,
        type_id : String ,
        from : String,
        seen : String,
        created_at : String
        ) {
        self._msg = msg
        self._type = type
        self._type_id = type_id
        self._from = from
        self._seen = seen
        self._created_at = created_at
    }
}
