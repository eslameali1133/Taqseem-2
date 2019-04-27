//
//  PlaygroundModel.swift
//  Taqseem
//
//  Created by Husseinomda16 on 3/18/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import Foundation
import UIKit

class PlaygroundModelClass: NSObject {
    var _owner_id = ""
    var _updated_at = ""
    var _name = ""
    var _lng = ""
    var _hour_to = ""
    var _phone = ""
    var _image = ""
    var _note = ""
    var _lat = ""
    var _capacity = ""
    var _address = ""
    var _name_en = ""
    var _city_id = ""
    var _id = ""
    var _name_ar = ""
    var _created_at = ""
    var _hour_from = ""
    var _cancel_fee = ""
    var _price = ""
    var _cancelation_time = ""
    var _days = ""
    var _matches = ""
    var _member = ""
    var _favorite = ""
    var _group_id = ""
    init(owner_id:String ,
         updated_at : String ,
         name : String ,
         lng : String ,
         hour_to :String ,
         phone :String ,
         image :String,
         note :String,
         lat :String,
         capacity :String,
         address :String,
         name_en :String,
         city_id :String,
         id :String,
         name_ar :String,
         created_at :String,
         hour_from :String,
         cancel_fee :String,
         price :String,
         cancelation_time :String,
        days :String,
        matches :String,
        member :String,
        favorite :String,
        group_id :String
        ) {
        
        self._owner_id = owner_id
        self._updated_at = updated_at
        self._name = name
        self._lng = lng
        self._hour_to = hour_to
        self._phone = phone
        self._image = image
        self._note = note
        self._lat = lat
        self._capacity = capacity
        self._address = address
        self._name_en = name_en
        self._city_id = city_id
        self._id = id
        self._name_ar = name_ar
        self._created_at = created_at
        self._hour_from = hour_from
        self._cancel_fee = cancel_fee
        self._price = price
        self._cancelation_time = cancelation_time
        self._days = days
        self._matches = matches
        self._member = member
        self._favorite = favorite
        self._group_id = group_id
    }
}
