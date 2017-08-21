//
//  ViewController.swift
//  AR Measure
//
//  Created by Alex Wong on 8/20/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // MARK: - Properties
    
    var firstBox: SCNNode?
    var secondBox: SCNNode?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var theButton: UIButton!
    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    
    // MARK: - Button method
    
    @IBAction func buttonTapped(_ sender: Any) {
        
        if firstBox == nil {
        
        
        firstBox = addBox()
            if firstBox != nil {
            theButton.setTitle("Set end point", for: .normal)
            }
        
        } else if secondBox == nil {
            
            theButton.setTitle("Reset", for: .normal)
            
            secondBox = addBox()
            
            // do calculation for distance
            
            if secondBox != nil{
            calculateDistance()
            }
        } else {
            firstBox?.removeFromParentNode()
            secondBox?.removeFromParentNode()
            firstBox = nil
            secondBox = nil
            measureLabel.text = ""
            theButton.setTitle("Set start point", for: .normal)
            
            
        }
        
        
    }
    
    // MARK: - Calculation method
    
    func calculateDistance() {
        
        if let firstBox = firstBox {
            if let secondBox = secondBox{
                
                let vector = SCNVector3Make(secondBox.position.x - firstBox.position.x, secondBox.position.y - firstBox.position.y, secondBox.position.z - firstBox.position.z)
                
                let distance = sqrt(vector.x * vector.x+vector.y * vector.y+vector.z * vector.z)
                
                measureLabel.text = "\(distance)m"
                
            }
        
        }
        
        
    }
    
    // MARK: - Add box method
    
    func addBox() -> SCNNode? {
        let userTouch = sceneView.center
        
        let testResults = sceneView.hitTest(userTouch, types: .featurePoint)
        
        if let theResult = testResults.first {
            
            let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.05)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.green
            box.firstMaterial = material
            
            let boxNode = SCNNode(geometry: box)
            boxNode.position = SCNVector3(theResult.worldTransform.columns.3.x, theResult.worldTransform.columns.3.y, theResult.worldTransform.columns.3.z)
            
            sceneView.scene.rootNode.addChildNode(boxNode)
            
            return boxNode
        }
        
        return nil
    }
    
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        measureLabel.text = ""
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
