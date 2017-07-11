//
//  ViewController.swift
//  rssi
//
//  Created by Dan Morton on 7/11/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import TOCropViewController

class ViewController: UIViewController, TOCropViewControllerDelegate {
    
    @IBOutlet weak var showControllerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showControllerButton.layer.cornerRadius = 15.0
        showControllerButton.clipsToBounds = false
    }
    
    @IBAction func showControllerButtonPressed(_ sender: Any) {
        let image = UIImage(named: "samc")
        let cropViewController = TOCropViewController(image: image!)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        print("That was cool!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

