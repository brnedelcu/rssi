//
//  ChangePinSizeViewController.swift
//  rssi
//
//  Created by Dan Morton on 8/14/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import CoreData

class ChangePinSizeViewController: UIViewController {

    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var slider: UISlider!
    let map : Map! = Map()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.minimumValue = 6.0
        slider.maximumValue = 20.0
        slider.value = 20.0
        
        pinView.frame = CGRect(x: pinView.frame.origin.x, y: pinView.frame.origin.y, width: CGFloat(slider.value), height: CGFloat(slider.value))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderChanged(_ slider: UISlider) {
        pinView.frame = CGRect(x: pinView.frame.origin.x, y: pinView.frame.origin.y, width: CGFloat(slider.value), height: CGFloat(slider.value))
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func setSizeButtonPressed(_ sender: Any) {
        map.pinSize = CGFloat(slider.value)
        
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let mapFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Plot_")
        
        do {
            let fetchedMaps = try moc.fetch(mapFetch)
            for i in 0..<fetchedMaps.count {
                let entry = fetchedMaps[i] as! Plot_
                if entry.name == self.map.label {
                    entry.pinsize = slider.value
                }
            }
        } catch {
            fatalError("Could update the map in the data store")
        }
        
        do {
            try moc.save()
        } catch {
            fatalError("Could not update the map in the data store.")
        }
        
        
        self.performSegue(withIdentifier: "unwindSegueToMap", sender: self)
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
