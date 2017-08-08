//
//  MapViewController.swift
//  rssi
//
//  Created by Dan Morton on 8/8/17.
//  Copyright © 2017 Intelligent Locations. All rights reserved.
//

import UIKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapImageView: UIImageView!
    var map : Map! // to be set in prepare for segue
    var hospitalName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapImageView.image = map.mapImage
        self.loadGateways()
    }
    
    
    @IBAction func userTappedScreen(_ sender: UITapGestureRecognizer) {
        let tapCoordinates = sender.location(in: mapImageView)
        self.createGatewayLocation(x: tapCoordinates.x, y: tapCoordinates.y)
    }

}

extension MapViewController {
    func createGatewayLocation(x: CGFloat, y: CGFloat) {
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
            
           // self.plotGatewayOnMap(gateway: gateway)`
        }
        
        alertViewController.addTextField { (textField) in
            textField.placeholder = "-Enter a name-"
        }
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func loadGateways() {
        for entry in map.gateways {
            let frame = CGRect(x: entry.x, y: entry.y, width: 15, height: 15)
            let gatewayView = UIView(frame: frame)
            view.layer.cornerRadius = 10.0
            gatewayView.backgroundColor = UIColor.red
            
            mapImageView.addSubview(gatewayView)
        }
        
    }
    
    func saveGateway(gateway: Gateway) {
        
    }
    
    func plotGatewayOnMap(gateway: Gateway) {

    }
}

