//
//  MapViewController.swift
//  rssi
//
//  Created by Dan Morton on 8/8/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import CoreData
import CoreGraphics

class MapViewController: UIViewController {

    @IBOutlet weak var mapImageView: UIImageView!
    var map : Map! // to be set in prepare for segue
    var hospitalName: String!
    var plotting = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapImageView.image = map.mapImage
        self.loadGateways()
    }
    
    
    @IBAction func plotGatewayButtonPressed(_ sender: Any) {
        if (plotting) {
            // insert styling here to show that we are not plotting
        } else {
            // insert styling here to show that we are plotting
        }
        
        plotting = !plotting
    }
    
    
    @IBAction func userTappedScreen(_ sender: UITapGestureRecognizer) {
        if (plotting) {
            let tapCoordinates = sender.location(in: mapImageView)
            self.saveGatewayLocation(x: tapCoordinates.x, y: tapCoordinates.y)
        } else {
            let g = self.findSelectedGateway(point: sender.location(in: mapImageView))
            if let result = g {
                let alertController = UIAlertController(title: "Gateway \(result.name)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil)
                let removeAction = UIAlertAction(title: "Remove Gateway", style: UIAlertActionStyle.destructive, handler: nil)
                
                
                alertController.addAction(doneAction)
                alertController.addAction(removeAction)
                
                self.present(alertController, animated: true, completion: nil)
                self.plotting = false
            }
        }
    }

}

extension MapViewController {
    func saveGatewayLocation(x: CGFloat, y: CGFloat) {
        // create the gateway in memory
        let gateway = Gateway()
        gateway.x = x
        gateway.y = y
        
        let alertViewController = UIAlertController(title: "Name this gateway", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) in
            let t = alertViewController.textFields![0]
            let name = t.text!
            gateway.name = name
            
            self.map.gateways.append(gateway)
            appManager.saveGatewayToMap(hospitalName: self.hospitalName, mapName: self.map.label, gateway: gateway)
            self.loadGateways()
        }
        
        alertViewController.addTextField { (textField) in
            textField.placeholder = "-Enter a name-"
        }
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func loadGateways() {
        var count = 0
        for entry in map.gateways {
            let frame = CGRect(x: entry.x - 10, y: entry.y - 10, width: 20, height: 20)
            let gatewayView = UIView(frame: frame)
            gatewayView.layer.cornerRadius = 10.0
            gatewayView.backgroundColor = UIColor.red
            mapImageView.addSubview(gatewayView)
            count += 1
        }
        
    }
}

extension MapViewController {
    func findSelectedGateway(point: CGPoint) -> Gateway? {
        for v in mapImageView.subviews {
            if v.frame.contains(point) {
                let g = findGatewayWithCoordinates(frame: v.frame)
                if let result = g {
                        return result
                }
                
            }
        }
        return nil
    }
    
    func findGatewayWithCoordinates(frame: CGRect) -> Gateway? {
        for gateway in map.gateways {
            if (gateway.x - 10 == frame.origin.x && gateway.y - 10 == frame.origin.y) {
                return gateway
            }
        }
        
        return nil
    }
}











