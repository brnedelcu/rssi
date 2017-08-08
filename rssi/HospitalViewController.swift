//
//  HospitalViewController.swift
//  rssi
//
//  Created by Dan Morton on 8/1/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import TOCropViewController
import CoreData

class HospitalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var hospital : Hospital! // to be set in preprare for segue
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var image : UIImage? = UIImage()
    var maps : [Map] = []
    @IBOutlet weak var mapsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(hospital.name) (\(hospital.acronym))"
        // Do any additional setup after loading the view.
        maps = appManager.loadMapsForHospital(hospitalName: hospital.name)
    }
    
    @IBAction func addMapButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        let pickerController = UIImagePickerController();
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mapSegue") {
            let dvc = segue.destination as! MapViewController
            dvc.map = self.maps[(mapsTableView.indexPathForSelectedRow?.row)!]
        } else {
            let dvc = segue.destination as! AddMapViewController
            print("In prepare for segue");
            dvc.image = self.image
            dvc.hospitalName = hospital.name
        }
    }
    
    
}

extension HospitalViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            let cropViewController = TOCropViewController(croppingStyle: TOCropViewCroppingStyle.default, image: image)
            cropViewController.delegate = self
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
}

extension HospitalViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = maps[indexPath.row].label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "mapSegue", sender: self)
    }
}

extension HospitalViewController {
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        self.image = image
        self.performSegue(withIdentifier: "createMap", sender: self)
        activityIndicator.stopAnimating()
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        activityIndicator.stopAnimating()
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension HospitalViewController {
    @IBAction func unwindToHospitalViewController(segue:UIStoryboardSegue) {
        mapsTableView.reloadData()
    }
}
