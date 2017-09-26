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

    // MARK: - IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - View Lifecycle
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
    
    // MARK: - ARSCNViewDelegate Method
    // Called when horizontal plane is detected - Delegate method from ARSCNViewDelegate
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
    
    // MARK: - Touch Began
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            // gives us the location of where we touched on the 2D screen
            let touchLocation = touch.location(in: sceneView)
            
            // HitTest is performed to get the 3D coordinates corresponding to the 2D coordinates that we got from touching the screen
            // That 3D coordinate will only be considered when it is on the existing plane that we detected
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            // if we have got some results using the hittest, then do this:
            if let hitResult = results.first{
                let boxScene = SCNScene(named: "art.scnassets/box.scn")!
                
                if let boxNode = boxScene.rootNode.childNode(withName: "box", recursively: true){
                    boxNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + boxNode.boundingSphere.radius, z: hitResult.worldTransform.columns.3.z)
                    
                    // box is added to the scene
                    sceneView.scene.rootNode.addChildNode(boxNode)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}
