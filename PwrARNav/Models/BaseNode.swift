//
//  BaseNode.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 14/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import SceneKit
import ARKit
import CoreLocation

class BaseNode: SCNNode {
    let title: String
    
    var anchor: ARAnchor? {
        didSet {
            guard let transform = anchor?.transform else { return }
            self.position = SCNVector3.position(fromTransform: transform)
        }
    }
    
    var location: CLLocation!
    
    init(title: String, location: CLLocation) {
        self.title = title
        super.init()
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
//        return sphereNode
        let newText = SCNText(string: "Destination", extrusionDepth: 0.2)
        newText.font = UIFont(name: "Helvetica", size: 1)
        newText.firstMaterial?.diffuse.contents = UIColor.red
        newText.firstMaterial?.transparency = 1
        let textNode = SCNNode(geometry: newText)
        let annotationNode = SCNNode()
        annotationNode.addChildNode(textNode)
        annotationNode.addChildNode(sphereNode)
        return annotationNode
    }
    
    func addSphere(with radius: CGFloat, and color: UIColor) {
        let sphereNode = createSphereNode(with: radius, color: color)
        addChildNode(sphereNode)
    }
    
    func addNode(with radius: CGFloat, and color: UIColor, and text: String) {
        let sphereNode = createSphereNode(with: radius, color: color)
        let newText = SCNText(string: text, extrusionDepth: 0.1)
        newText.font = UIFont(name: "Helvetica", size: 5)
        newText.firstMaterial?.diffuse.contents = UIColor.red
        newText.firstMaterial?.transparency = 0
        let _textNode = SCNNode(geometry: newText)
        let annotationNode = SCNNode()
        annotationNode.addChildNode(_textNode)
        annotationNode.position = sphereNode.position
        addChildNode(sphereNode)
        addChildNode(annotationNode)
        print(annotationNode)
    }
    
}
