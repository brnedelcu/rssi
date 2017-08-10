//
//  AddHospitalViewController.swift
//  rssi
//
//  Created by Dan Morton on 7/18/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import CoreData

class AddHospitalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let colors = ["Red", "Green", "Blue", "Yellow", "Orange"]

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var hospitalNameTextField: UITextField!
    @IBOutlet weak var acronymTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        doneButton.layer.cornerRadius = 5.0
        cancelButton.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if (hospitalNameTextField.text == nil || hospitalNameTextField.text == ""
            || acronymTextField.text == nil || acronymTextField.text == "") {
            return
        }
        
        let hospitalName = hospitalNameTextField.text!
        let acronym = acronymTextField.text!
        let c = colors[pickerView.selectedRow(inComponent: 0)]
        
        var colorTheme = UIColor()
        if (c == "Red") {
            colorTheme = Constants.Color.material_red
        } else if (c == "Green") {
            colorTheme = Constants.Color.material_green
        } else if (c == "Yellow") {
            colorTheme = Constants.Color.material_yellow
        } else if (c == "Orange") {
            colorTheme = Constants.Color.material_orange
        } else if (c == "blue") {
            colorTheme = Constants.Color.material_blue
        }
        
        appManager.addHosptial(name: hospitalName, acronym: acronym, color: colorTheme)
        
        // core data
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let hospital = Hospital_(context: managedObjectContext)
        hospital.name = hospitalName
        hospital.acronym = acronym
        hospital.color = c
        
        appManager.hospitalCollectionView?.reloadData()
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Unable to save hospital to core data")
        }
        

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if (colors[row] == "Red") {
            let attribute = [NSForegroundColorAttributeName: Constants.Color.material_red]
            let string = NSAttributedString(string: "Red", attributes: attribute)
            return string
            
        } else if (colors[row] == "Green") {
            let attribute = [NSForegroundColorAttributeName: Constants.Color.material_green]
            let string = NSAttributedString(string: "Green", attributes: attribute)
            return string
            
        } else if (colors[row] == "Blue") {
            let attribute = [NSForegroundColorAttributeName: Constants.Color.material_blue]
            let string = NSAttributedString(string: "Blue", attributes: attribute)
            return string
            
        } else if (colors[row] == "Yellow") {
            let attribute = [NSForegroundColorAttributeName: Constants.Color.material_yellow]
            let string = NSAttributedString(string: "Yellow", attributes: attribute)
            return string
            
        } else {
            let attribute = [NSForegroundColorAttributeName: Constants.Color.material_orange]
            let string = NSAttributedString(string: "Orange", attributes: attribute)
            return string
        }
    }

}
