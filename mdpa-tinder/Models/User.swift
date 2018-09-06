//
//  User.swift
//  mdpa-tinder
//
//  Created by Guillermo Antich Soler on 9/7/18.
//  Copyright © 2018 Guillermo Antich Soler. All rights reserved.
//

import RealmSwift

class User: Object {
    @objc dynamic var token: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var gender: String = "undefined"
    @objc dynamic var logitude: Double = 0.000000
    @objc dynamic var latitude: Double = 0.000000
    @objc dynamic var distance_min: Int = 0
    @objc dynamic var distance_max: Int = 0
    @objc dynamic var range_min: Int = 18
    @objc dynamic var range_max: Int = 65
    @objc dynamic var visibility: Bool = true
}
