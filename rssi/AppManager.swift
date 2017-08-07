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
    
    func loadMapsForHospital(hospitalName: String) -> [Map] {
        var maps : [Map] = []
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let hospitalFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospital_")
        do {
            let fetchedHospitals = try managedObjectContext.fetch(hospitalFetch)
            
            for i in 0..<fetchedHospitals.count {
                let entry = fetchedHospitals[i] as! Hospital_
                //print((entry as AnyObject).value(forKey: "name") ?? "Could not fetch name values in AppManager::loadDataFromDataStore")
                let name = (entry as AnyObject).value(forKey: "name") as! String
                if name == hospitalName {
                    for i in entry.relationship! {
                        var gWays : [Gateway] = []
                        let plot = i as! Plot_
                        let name = plot.name
                        let imageData = plot.image as Data?
                        let img = UIImage(data: imageData!)
                        let gateways = plot.gateways
                        
                        for gateway in gateways! {
                            let newGateway = Gateway()
                            let g = gateway as! Gateway_
                            let name = g.value(forKey: "name") as! String
                            let x = g.value(forKey: "x") as! Float
                            let y = g.value(forKey: "y") as! Float
                            newGateway.name = name
                            newGateway.x = x
                            newGateway.y = y
                            gWays.append(newGateway)
                            
                        }
                        
                        let m = Map(mapImage: img!, gateways: gWays, label: name!)
                        maps.append(m)
                    }
                }
            }
            
        } catch {
            fatalError("Could not load hospital data in AddMapViewController")
        }
        
        return maps
    }
    
    func addHosptial(name: String, acronym: String, color: UIColor) {
        let newHospital = Hospital(name: name, acronym: acronym, maps: [], color: color)
        hospitals.append(newHospital)
    }
    
}
