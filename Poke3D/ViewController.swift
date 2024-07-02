//
//  ViewController.swift
//  Poke3D
//
//  Created by Mohd Haris on 16/02/24.
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
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
        // from here, I have started to code
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main){
            
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
//            print("Image added successfully")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageDetected = anchor as? ARImageAnchor{    // this ARAnchor will detect the reference image we have provided to the camera and return it as anchor and we will store it in imageDetected
            
            
            // after detecting that image we will create an plane for that image to be shown in the real world
            let plane = SCNPlane(width: imageDetected.referenceImage.physicalSize.width,
                                 height: imageDetected.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.5)
            
            // we are now creating a node called plane node with geometry as same as plane
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
            if(imageDetected.referenceImage.name == "eevee_png"){
                
                // creating a scene for the 3-D eevee model
                if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn"){
                    
                    if let pokeNode = pokeScene.rootNode.childNodes.first{
                        pokeNode.eulerAngles.x = .pi/2
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
            if(imageDetected.referenceImage.name == "oddish"){
                
                // creating a scene for the 3-D eevee model
                if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn"){
                    
                    if let pokeNode = pokeScene.rootNode.childNodes.first{
                        pokeNode.eulerAngles.x = .pi/2
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
            
        }
        
        return node
    }
    

}
