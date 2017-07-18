//
//  Hospital.swift
//  rssi
//
//  Created by Dan Morton on 7/17/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import Foundation
import UIKit

class Hospital {
    var name: String = ""
    var acronym: String = ""
    var maps: [Map] = []
    var color: UIColor = UIColor.red
    convenience init(name: String, acronym: String, maps: [Map], color: UIColor) {
        self.init()
        self.name = name
        self.acronym = acronym
        self.maps = maps
        self.color = color
    }
}
