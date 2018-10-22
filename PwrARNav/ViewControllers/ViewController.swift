//
//  ViewController.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 11/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    private let configuration = ARWorldTrackingConfiguration()
    private var destinationNode: BaseNode?
    private var updateNodes: Bool = false
    private var currentLocation: CLLocation?
    private var updatedLocations = [CLLocation]()
    internal var startingLocation: CLLocation!
    private var destinationLocation: CLLocation!
    
    var locationService: LocationManager?
    
    private var locationUpdates: Int = 0 {
        didSet {
            if locationUpdates >= 4 {
                updateNodes = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentLocationSetupMessage()
        
        setupScene()
        setupLocationService()
    }
    
    private func setupLocationService() {
        locationService = LocationManager()
        locationService?.delegate = self
    }
    
    private func setupScene() {
        sceneView.delegate = self as? ARSCNViewDelegate
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        runSession()
    }
    
    private func presentLocationSetupMessage() {
        let ac = UIAlertController(title: "Choose location", message: "Choose test location", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Latitude"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "Longtitude"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            let first = ac.textFields![0] as UITextField
            let second = ac.textFields![1] as UITextField
            let latitude = first.text
            let longtitude = second.text
            if let latitude = latitude, let longtitude = longtitude {
                let lat = Double(latitude)!
                let lon = Double(longtitude)!
                self.destinationLocation = CLLocation(latitude: lat, longitude: lon)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(saveAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true)
        navigationController?.navigationBar.isHidden = true
    }
}

extension ViewController: MessagePresenter {
    func runSession() {
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration, options: [.resetTracking])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateNodes = true
        if updatedLocations.count > 0 {
            startingLocation = CLLocation.estimateBestLocation(locations: updatedLocations)
            if startingLocation != nil {
                DispatchQueue.main.async {
                    self.addSphere(for: self.destinationLocation)
                }
            }
        }
    }
    
    private func updateNodePosition() {
        if updateNodes {
            locationUpdates += 1
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            if updatedLocations.count > 0 {
                startingLocation = CLLocation.estimateBestLocation(locations: updatedLocations)
                print(startingLocation)
                if let node = destinationNode, startingLocation != nil {
                    let translation = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: node.location)
                    let position = SCNVector3.position(fromTransform: translation)
                    let distance = node.location.distance(from: startingLocation)
                    DispatchQueue.main.async {
                        let scale = 100 / Float(distance)
                        node.scale = SCNVector3Make(scale, scale, scale)
                        node.anchor = ARAnchor(transform: translation)
                        node.position = position
                    }
                }
            }
            SCNTransaction.commit()
        }
    }
    
    private func addSphere(for location: CLLocation) {
        let locationTransform = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: location)
        let stepAnchor = ARAnchor(transform: locationTransform)
        let sphere = BaseNode(title: "Destination", location: location)
        sphere.addSphere(with: 0.5, and: .blue)
        sphere.location = location
        sceneView.session.add(anchor: stepAnchor)
        sceneView.scene.rootNode.addChildNode(sphere)
        sphere.anchor = stepAnchor
    }
    
}

extension ViewController: LocationManagerDelegate {
    func trackingLocation(for currentLocation: CLLocation) {
        if currentLocation.horizontalAccuracy <= 65.0 {
            updatedLocations.append(currentLocation)
            updateNodePosition()
        }
    }
    
    func trackingLocationDidFail(with error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
}
