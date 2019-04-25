//
//  HistoryMsgModel.swift
//  Taqseem
//
//  Created by Husseinomda16 on 4/16/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import Foundation
import UIKit

class HistoryMsgModelClass: NSObject {
    var _from_name = ""
    var _from_id = ""
    var _from_photo = ""
    var _to_name = ""
    var _to_id = ""
    var _to_photo = ""
    var _count = ""
    var _time = ""
    var _type = ""
    init(
        from_name : String ,
        from_id : String ,
        from_photo : String ,
        to_name : String ,
        to_id : String ,
        to_photo : String ,
        count : String ,
        time : String ,
        type : String
        ) {
        self._from_name = from_name
        self._from_id = from_id
        self._from_photo = from_photo
        self._to_name = to_name
        self._to_id = to_id
        self._to_photo = to_photo
        self._count = count
        self._time = time
        self._type = type
    }
}
