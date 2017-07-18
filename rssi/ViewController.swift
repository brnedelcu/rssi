//
//  ViewController.swift
//  rssi
//
//  Created by Dan Morton on 7/11/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import TOCropViewController

class ViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = Constants.Color.material_blue
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!, NSForegroundColorAttributeName: UIColor.white]
        
        appManager.hospitalCollectionView = collectionView
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        print("This ran")
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Menu", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let addHospitalAction = UIAlertAction(title: "Add Hospital", style: UIAlertActionStyle.default) { (action) in
                self.performSegue(withIdentifier: "addHospitalModal", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertViewController.addAction(addHospitalAction)
        alertViewController.addAction(cancelAction)
        
        let popOver = alertViewController.popoverPresentationController
        popOver?.sourceView = self.view
        popOver?.sourceRect = CGRect(x: view.frame.width, y: 0, width: 100, height: 100)
        
        self.present(alertViewController, animated: true, completion: nil)
    }
}


// UICollectionViewDataSource
extension ViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appManager.hospitals.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HospitalCollectionViewCell
        
        cell.acronymLabel.text = appManager.hospitals[indexPath.row].acronym
        cell.hostpitalNameLabel.text = appManager.hospitals[indexPath.row].name
        cell.mapCountLabel.text = "# of maps: \(appManager.hospitals.count)"
        
        cell.layer.cornerRadius = 5.0
        cell.backgroundColor = Constants.Color.material_gray
        
        return cell
    }
}

