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
import MessageUI

class MapViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var plotGatewayButton: UIBarButtonItem!
    
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var menuView: UIView!
    
    var map : Map! // to be set in prepare for segue
    var hospitalName: String!
    var plotting = false
    var movingGateway = false
    var pinSizeChanged = false
    var gatewayBeingMoved = Gateway()
    var originalImageFrame = CGRect()
    
    var deltaXCounter = 0
    var deltaYCounter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapImageView.image = map.mapImage
        self.loadGateways()
        statusLabel.text = "     View Gateway Mode"
        statusLabel.textColor = UIColor.white
        statusLabel.backgroundColor = Constants.Color.material_blue
        
        zoomInButton.layer.cornerRadius = 5.0
        zoomOutButton.layer.cornerRadius = 5.0
        menuButton.layer.cornerRadius = 5.0
        
        menuView.layer.cornerRadius = 5.0
        originalImageFrame = self.mapImageView.frame
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // let data = appManager.createPDFfromView(view: mapImageView)
    
        //self.sendMail(data: data)
    }
    
    
    @IBAction func userPanned(_ sender: UIPanGestureRecognizer) {
        
        
        
        let velX = sender.velocity(in: self.view).x
        let velY = sender.velocity(in: self.view).y
        
        let hypotnuseSquared = pow(velX, 2) + pow(velY, 2)
        let hypotnuse = sqrt(hypotnuseSquared)
        
        let changeRate = hypotnuse / 100
        
        
        
        if (!movingGateway) {
            let velocity = sender.velocity(in: self.view)
            
            if (velocity.x > 0) {
                mapImageView.center.x += changeRate
            } else {
                mapImageView.center.x -= changeRate
            }
            
            if (velocity.y > 0) {
                mapImageView.center.y += changeRate
            } else {
                mapImageView.center.y -= changeRate
            }
            return
        } else {
            let panCoordinates = sender.location(in: mapImageView)
            let gateway = mapImageView.subviews[0]
            let frame = CGRect(x: panCoordinates.x - 20, y: panCoordinates.y - 20, width: 20, height: 20)
            gatewayBeingMoved.x = frame.origin.x + 10
            gatewayBeingMoved.y = frame.origin.y + 10
            let gatewayView = UIView(frame: frame)
            gateway.frame = frame
            mapImageView.addSubview(gatewayView)
        }
    }
    
    
    @IBAction func plotGatewayButtonPressed(_ sender: Any) {
        if (plotting) {
            // insert styling here to show that we are not plotting
            statusLabel.text = "     View Gateway Mode"
            statusLabel.textColor = UIColor.white
            statusLabel.backgroundColor = Constants.Color.material_blue
            plotGatewayButton.title = "     Plot Gateway"
        } else if (movingGateway) {
            
            statusLabel.text = "     View Gateway Mode"
            statusLabel.textColor = UIColor.white
            statusLabel.backgroundColor = Constants.Color.material_blue
            plotGatewayButton.title = "     Plot Gateway"
            
            appManager.saveGatewayToMap(hospitalName: hospitalName, mapName: map.label, gateway: gatewayBeingMoved)
            
            gatewayBeingMoved = Gateway()
            movingGateway = false
            plotting = !plotting
            self.loadGateways()
                
        } else {
            // insert styling here to show that we are plotting
            statusLabel.text = "     Plotting Mode"
            statusLabel.textColor = UIColor.white
            statusLabel.backgroundColor = Constants.Color.material_green
            plotGatewayButton.title = "     View Gateway"
        }
        
        plotting = !plotting
    }
    
    
    @IBAction func userPinched(_ sender: UIPinchGestureRecognizer) {
        if sender.velocity > 0 {
            let tr = mapImageView.transform.scaledBy(x: 1.02, y: 1.02)
            self.mapImageView.transform = tr
            mapImageView.center = sender.location(in: self.mapImageView)
        } else {
            let tr = mapImageView.transform.scaledBy(x: 0.98, y: 0.98)
            self.mapImageView.transform = tr
            mapImageView.center = sender.location(in: self.mapImageView)
        }
        
    }
    
    
    @IBAction func zoomInButtonPressed(_ sender: Any) {
        let tr = mapImageView.transform.scaledBy(x: 1.10, y: 1.10)
        self.mapImageView.transform = tr
        
       // mapImageView.center = sender.location(in: self.mapImageView)
    }
    
    
    
    @IBAction func zoomOutButtonPressed(_ sender: Any) {
        let tr = mapImageView.transform.scaledBy(x: 0.90, y: 0.90)
        self.mapImageView.transform = tr
        //mapImageView.center = sender.location(in: self.mapImageView)
    }
    
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
         let alertController = UIAlertController(title: "Menu", message: "Select and Option", preferredStyle: UIAlertControllerStyle.actionSheet)
        
       
        let exportAction = UIAlertAction(title: "Export to PDF", style: UIAlertActionStyle.default) { (action) in
            self.sendMail(data: appManager.createPDFfromView(view: self.mapImageView))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        
        alertController.addAction(exportAction)
        alertController.addAction(cancelAction)
        
        let popOver = alertController.popoverPresentationController
        popOver?.sourceView = self.view
        popOver?.sourceRect = CGRect(x: self.view.frame.width - menuView.frame.width, y: sender.frame.origin.y, width: 100, height: 100)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func userTappedScreen(_ sender: UITapGestureRecognizer) {
        if (movingGateway) {
            return
        }
        if (plotting) {
            let tapCoordinates = sender.location(in: mapImageView)
            self.saveGatewayLocation(x: tapCoordinates.x, y: tapCoordinates.y)
        } else {
            let g = self.findSelectedGateway(point: sender.location(in: mapImageView))
            if let result = g {
                let alertController = UIAlertController(title: "Gateway \(result.name)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                let doneAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil)
                let markAsInstalledAction = UIAlertAction(title: "Mark as installed", style: UIAlertActionStyle.default, handler: { (action) in
                    appManager.markGatewayAsInstalled(gateway: result, truthVal: true)
                    
                    for gateway in self.map.gateways {
                        if (gateway.name == result.name) {
                            gateway.installed = true
                        }
                    }
                    
                    self.loadGateways()
                })
                
                let adjustLocationAction = UIAlertAction(title: "Move Gateway", style: UIAlertActionStyle.default, handler: { (action) in
                    self.setMoveGatewayMode(g: result)
                })
                
                let markAsUninstalledAction = UIAlertAction(title: "Mark as unisntalled", style: UIAlertActionStyle.default, handler: { (action) in
                    appManager.markGatewayAsInstalled(gateway: result, truthVal: false)
                
                    for gateway in self.map.gateways {
                        if (gateway.name == result.name) {
                            gateway.installed = false
                        }
                    }
                    
                    self.loadGateways()
                })
                let removeAction = UIAlertAction(title: "Remove Gateway", style: UIAlertActionStyle.destructive, handler: { (action) in
                    var counter = 0
                    for gateway in self.map.gateways {
                        if (gateway.name == result.name) {
                            self.map.gateways.remove(at: counter)
                            appManager.removeGatewayFromMap(hospitalName: self.hospitalName, mapName: self.map.label, gway: gateway)
                            self.loadGateways()
                            break
                        }
                        counter += 1
                    }
    
                    
                })
                
                if (result.installed) {
                    alertController.addAction(markAsUninstalledAction)
                } else {
                    alertController.addAction(markAsInstalledAction)
                }
                alertController.addAction(doneAction)
                alertController.addAction(adjustLocationAction)
                alertController.addAction(removeAction)
                
                
                self.present(alertController, animated: true, completion: nil)
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
        
        // The following to clear the current displayed gateways for reload
        for view in mapImageView.subviews {
            view.removeFromSuperview()
        }
        
        var count = 0
        for entry in map.gateways {
            let frame = CGRect(x: entry.x - 10, y: entry.y - 10, width: 20, height: 20)
            let gatewayView = UIView(frame: frame)
            gatewayView.layer.cornerRadius = 10.0
            gatewayView.backgroundColor = Constants.Color.material_red
            gatewayView.alpha = 0.8
            if (entry.installed) {
                gatewayView.backgroundColor = Constants.Color.material_blue
            }
            mapImageView.addSubview(gatewayView)
            count += 1
        }
        
    }
    
    
}

extension MapViewController {
    func setMoveGatewayMode(g: Gateway) {
        movingGateway = true
        appManager.removeGatewayFromMap(hospitalName: hospitalName, mapName: map.label, gway: g)
        
        for view in mapImageView.subviews {
            view.removeFromSuperview()
        }
        
        let frame = CGRect(x: g.x - 10, y: g.y - 10, width: 20, height: 20)
        let gatewayView = UIView(frame: frame)
        gatewayView.layer.cornerRadius = 10.0
        gatewayView.backgroundColor = Constants.Color.material_red
        if (g.installed) {
            gatewayView.backgroundColor = Constants.Color.material_blue
        }
        
        mapImageView.addSubview(gatewayView)
        
        statusLabel.text = "Drag where you want the gateway ..."
        plotGatewayButton.title = "Finished"
        statusLabel.backgroundColor = Constants.Color.material_orange
        gatewayBeingMoved = g
        
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

extension MapViewController {
    func sendMail(data: Data) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setSubject("Map from Intelligent Locations")
        composeVC.setToRecipients(["dmorton2297@gmail.com"])
        composeVC.addAttachmentData(data, mimeType: "", fileName: "map.pdf")
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}











