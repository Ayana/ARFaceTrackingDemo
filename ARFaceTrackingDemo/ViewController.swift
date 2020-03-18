//
//  ViewController.swift
//  ARFaceTrackingDemo
//
//  Created by Ayana Osawa on 2020/03/17.
//  Copyright © 2020 Ayaos. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

//class ViewController: UIViewController {
class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var arView: ARView!
    var faceAnchor: FaceExperience.FaceMask!
    var allowsTalking = true
    var mouthB: Entity!
    var eyeL: Entity!
    var eyeR: Entity!
    var hat: Entity!
//    var lastJawValue: Float = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config)
        arView.session.delegate = self // Set to use front camera
        
        // Load the "Box" scene from the "Experience" Reality File
        let faceAnchor = try! FaceExperience.loadFaceMask()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(faceAnchor)

        mouthB = faceAnchor.findEntity(named: "mouthB")
        hat = faceAnchor.findEntity(named: "hat")

        eyeL = faceAnchor.findEntity(named: "eyeL")
        eyeR = faceAnchor.findEntity(named: "eyeR")

        faceAnchor.actions.finishedTalking.onAction = { _ in
            self.allowsTalking = true
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        var pointAnchor: ARFaceAnchor?

        for a in anchors {
            if let anchor = a as? ARFaceAnchor {
                pointAnchor = anchor
            }
        }

        guard let blendShapes = pointAnchor?.blendShapes,
            let jawValue = blendShapes[.jawOpen]?.floatValue,
//            let browLValue = blendShapes[.eyeBlinkLeft]?.floatValue,
            let browIUValue = blendShapes[.browInnerUp]?.floatValue,
            let eyeLValue = blendShapes[.eyeBlinkLeft]?.floatValue,
            let eyeRValue = blendShapes[.eyeBlinkRight]?.floatValue else { return }

//        if (jawValue >= 0.5) && allowsTalking && lastJawValue < 0.5 {
//            allowsTalking = false
//            faceAnchor.notifications.talk.post()
//        }

//        lastJawValue = jawValue

        eyeL.position.z = -0.025 - eyeLValue * -0.01
        eyeR.position.z = -0.025 - eyeRValue * -0.01

        mouthB.position.z = 0.05 - jawValue * -0.03
        
        hat.position.z = -0.115 - browIUValue * 0.07
        hat.position.x = 0.04 - browIUValue * -0.03
    }
}
