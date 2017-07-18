//
//  Map.swift
//  rssi
//
//  Created by Dan Morton on 7/17/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import Foundation
import UIKit

class Map {
    var mapImage : UIImage = UIImage()
    var gateways : [Gateway] = [Gateway()]
    
    convenience init(mapImage: UIImage, gateways: [Gateway]) {
        self.init()
        self.mapImage = mapImage
        self.gateways = gateways
    }
    
}
