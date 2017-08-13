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
import QuartzCore
import MessageUI

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
                let colorString = (entry as AnyObject).value(forKey: "color") as! String
                var finalColor = UIColor.black
                if (colorString == "Red") {
                    finalColor = Constants.Color.material_red
                } else if (colorString == "Green") {
                    finalColor = Constants.Color.material_green
                } else if (colorString == "Yellow") {
                    finalColor = Constants.Color.material_yellow
                } else if (colorString == "Orange") {
                    finalColor = Constants.Color.material_orange
                } else if (colorString == "Blue") {
                    finalColor = Constants.Color.material_blue
                }
                
                let maps = self.loadMapsForHospital(hospitalName: name)
                
                
                let newHospital = Hospital(name: name, acronym: acronym, maps: maps, color: finalColor)
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
                            print("We found a gateway for this map!")
                            let newGateway = Gateway()
                            let g = gateway as! Gateway_
                            let name = g.value(forKey: "name") as! String
                            let x = g.value(forKey: "x") as! Float
                            let y = g.value(forKey: "y") as! Float
                            let installed = g.value(forKey: "installed") as! Bool
                            newGateway.name = name
                            newGateway.x = CGFloat(x)
                            newGateway.y = CGFloat(y)
                            newGateway.installed = installed
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
    
    func deleteMapFromHospital(hospitalName: String, mapName: String) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let hospitalFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospital_")
        do {
            let fetchedHospitals = try managedObjectContext.fetch(hospitalFetch)
            
            for i in 0..<fetchedHospitals.count {
                let entry = fetchedHospitals[i] as! Hospital_
                //print((entry as AnyObject).value(forKey: "name") ?? "Could not fetch name values in AppManager::loadDataFromDataStore")
                let name = (entry as AnyObject).value(forKey: "name") as! String
                if name == hospitalName {
                    for map in entry.relationship! {
                        let m = map as! Plot_
                        entry.removeFromRelationship(m)
                    }
                }
            }
            
        } catch {
            fatalError("Could not load hospital data in AddMapViewController")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Could not save data change to core data")
        }

    }
    
    func saveGatewayToMap(hospitalName: String, mapName: String, gateway: Gateway) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let hospitalFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospital_")
        do {
            let fetchedHospitals = try managedObjectContext.fetch(hospitalFetch)
            
            for i in 0..<fetchedHospitals.count {
                let entry = fetchedHospitals[i] as! Hospital_
                //print((entry as AnyObject).value(forKey: "name") ?? "Could not fetch name values in AppManager::loadDataFromDataStore")
                let name = (entry as AnyObject).value(forKey: "name") as! String
                if name == hospitalName {
                    for j in entry.relationship! {
                        let map = j as! Plot_
                        if map.name == mapName {
                            let gWay = Gateway_(context: managedObjectContext)
                            gWay.name = gateway.name
                            gWay.x = Float(gateway.x)
                            gWay.y = Float(gateway.y)
                            gWay.installed = false
                        
                            map.addToGateways(gWay)
                        }
                    }
                }
            }
            
        } catch {
            fatalError("Could not load hospital data in AddMapViewController")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Could not save to core data")
        }
    }
    
    func removeGatewayFromMap(hospitalName: String, mapName: String, gway: Gateway) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let hospitalFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospital_")
        do {
            let fetchedHospitals = try managedObjectContext.fetch(hospitalFetch)
            
            for i in 0..<fetchedHospitals.count {
                let entry = fetchedHospitals[i] as! Hospital_
                //print((entry as AnyObject).value(forKey: "name") ?? "Could not fetch name values in AppManager::loadDataFromDataStore")
                let name = (entry as AnyObject).value(forKey: "name") as! String
                if name == hospitalName {
                    for j in entry.relationship! {
                        let map = j as! Plot_
                        if map.name == mapName {
                            for gateway in map.gateways! {
                                let a = gateway as! Gateway_
                                if a.name == gway.name {
                                    managedObjectContext.delete(a)
                                }
                            }
                        }
                    }
                }
            }
            
        } catch {
            fatalError("Could not load hospital data in AddMapViewController")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Could not save to core data")
        }

    }
    
    func removeMapFromHospital(mapName: String) {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let mapFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Plot_")
        do {
            let fetchedMaps = try managedObjectContext.fetch(mapFetch)
            for i in 0..<fetchedMaps.count {
                let entry = fetchedMaps[i] as! Plot_
                let mName = entry.name
                if (mName == mapName) {
                    managedObjectContext.delete(entry)
                }
            }
        } catch {
            fatalError("Unable to delete map from history")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Could not save MOC in removeMapFromHospital()")
        }
    }
    
    func markGatewayAsInstalled(gateway: Gateway, truthVal: Bool) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let gatewayFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Gateway_")
        do {
            let fetchedGateways = try moc.fetch(gatewayFetch)
            for i in 0..<fetchedGateways.count {
                let entry = fetchedGateways[i] as! Gateway_
                if (entry.name == gateway.name) {
                    print("FOUND SOMETHING TO MARK")
                    entry.installed = truthVal
                    
                }
            }
            
        } catch {
            fatalError("Could not mark gateway as installed in AppManager::markGatewayAsInstalled()")
        }
        
        do {
            try moc.save()
        } catch {
            fatalError("Could not save to local datastore in AppManager::markGatewayAsInstalled")
        }
    }
    
    func addHosptial(name: String, acronym: String, color: UIColor) {
        let newHospital = Hospital(name: name, acronym: acronym, maps: [], color: color)
        hospitals.append(newHospital)
    }
    
}

extension AppManager {
    func createPDFfromView(view: UIView) -> Data {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, view.bounds, nil)
        UIGraphicsBeginPDFPage()
        let pdfContext = UIGraphicsGetCurrentContext()
        
        
        view.layer.render(in: pdfContext!)
        UIGraphicsEndPDFContext()
        
        let result = pdfData as Data
        
        return result
    }
    
    
}





































