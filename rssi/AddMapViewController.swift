//
//  AddMapViewController.swift
//  rssi
//
//  Created by Dan Morton on 8/1/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import CoreData

class AddMapViewController: UIViewController {
    @IBOutlet weak var mapNameField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createMapButton: UIButton!
    
    var hospitalName : String!
    var image : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = self.image
        cancelButton.layer.cornerRadius = 5.0
        createMapButton.layer.cornerRadius = 5.0
    }
    
    // This action will run when user pressed "Create Map"
    @IBAction func createMapPressed(_ sender: Any) {
        print("We are trying to create a map here")
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let plot = Plot_(context: managedObjectContext)
        plot.image = UIImagePNGRepresentation(image)! as NSData
        plot.name = mapNameField.text
        plot.pinsize = 20.0
        
        
        let hospitalFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Hospital_")
        do {
            let fetchedHospitals = try managedObjectContext.fetch(hospitalFetch)
            
            for i in 0..<fetchedHospitals.count {
                let entry = fetchedHospitals[i] as! Hospital_
                //print((entry as AnyObject).value(forKey: "name") ?? "Could not fetch name values in AppManager::loadDataFromDataStore")
                let name = (entry as AnyObject).value(forKey: "name") as! String
                if name == hospitalName {
                    entry.addToRelationship(plot)
                    break
                }
            }
            
        } catch {
            fatalError("Could not load hospital data in AddMapViewController")
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Unable to save plot to core data")
        }
        
        let navigationController = self.presentingViewController as! UINavigationController
        let hospitalViewController = navigationController.viewControllers[1] as! HospitalViewController
        hospitalViewController.viewDidLoad()
        
        self.performSegue(withIdentifier: "unwindToHospitalViewController", sender: self)
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
