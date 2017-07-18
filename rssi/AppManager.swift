//
//  AppManager.swift
//  rssi
//
//  Created by Dan Morton on 7/17/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import Foundation
import UIKit

let appManager = AppManager()

class AppManager {
    var hospitals : [Hospital] = []
    var hospitalCollectionView : UICollectionView?
    
    
    func addHosptial(name: String, acronym: String, color: UIColor) {
        let newHospital = Hospital(name: name, acronym: acronym, maps: [], color: color)
        hospitals.append(newHospital)
    }
    
}
