//
//  AppManager.swift
//  rssi
//
//  Created by Dan Morton on 7/17/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import Foundation
import CoreData
import UIKit

let appManager = AppManager()

class AppManager {
    var hospitals : [Hospital] = []
    var hospitalCollectionView : UICollectionView?
    
    
    func loadDataFromDataStore() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let hospitalFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospital_")
        do {
            let fetchedHospitals = try moc.fetch(hospitalFetch)
        
            for i in 0..<fetchedHospitals.count {
                let entry = fetchedHospitals[i] as! Hospital_
                //print((entry as AnyObject).value(forKey: "name") ?? "Could not fetch name values in AppManager::loadDataFromDataStore")
                let name = (entry as AnyObject).value(forKey: "name") as! String
                let acronym = (entry as AnyObject).value(forKey: "acronym") as! String
                let _ = (entry as AnyObject).value(forKey: "color") as! String
                
                
                let newHospital = Hospital(name: name, acronym: acronym, maps: [], color: UIColor.black)
                hospitals.append(newHospital)
                
            }
        } catch {
            fatalError("Unable to run core data query in AppManager::loadDataFromDataStore()")
        }
        
    }
    
    func addHosptial(name: String, acronym: String, color: UIColor) {
        let newHospital = Hospital(name: name, acronym: acronym, maps: [], color: color)
        hospitals.append(newHospital)
    }
    
}
