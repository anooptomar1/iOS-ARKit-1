//
//  ViewController.swift
//  AR Portal
//
//  Created by Alex Wong on 9/26/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        // Set up horizontal plane detection
        
        configuration.planeDetection = .horizontal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // Delegate method from ARSCNViewDelegate
    // Called when horizontal plane is detected
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor{
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // create a plane geometry with the help of dimensions we got from the plane anchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // a node is basically a position
            let planeNode = SCNNode()
            
            // set the position of the plane geomtry to the position we got using plane anchor
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            // when a plane is created its created in xy plane instead of xz plane so we need to rotate it along x axis
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            // create a material object
            let gridMaterial = SCNMaterial()
            
            // set the material as an image. a material can also be set to a color
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            // assign the material to the plane
            plane.materials = [gridMaterial]
        
            // assign the position to the plane
            planeNode.geometry = plane
            
            // add the plane node to our scene
            node.addChildNode(planeNode)
            
            
            
            
            
            
            
            
            
            
        } else {
            return
        }
        
    }
}
