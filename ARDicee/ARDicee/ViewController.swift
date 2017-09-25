//
//  ViewController.swift
//  ARDicee
//
//  Created by Alex Wong on 9/25/17.
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
        
        // Create a cube
        //let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
//        let sphere = SCNSphere(radius: 0.2)
//
//        // Create material
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//
//        // Add material (which makes the cube red) to the cube
//        sphere.materials = [material]
//
//        // Create our node = points in 3D space
//        let node = SCNNode()
//
//        // Give it a position
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//
//        // Assign the node an object to display which is our cube
//        node.geometry = sphere
//
//        // Putting our node in the sceneview
//        sceneView.scene.rootNode.addChildNode(node)
        
        // By running now, cube may look flat and that is due to light, let's add it
        sceneView.autoenablesDefaultLighting = true
        
    
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
            diceNode.position = SCNVector3(0, 0, -0.1)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
