//
//  GameViewController.swift
//  HitTheTree
//
//  Created by Brian Advent on 26.04.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    let CategoryBall = 1
    let CategoryCrossbar = 2
    let CategoryGoal = 4
    let CategoryGoalKeeper = 8
    
    var sceneView:SCNView!
    var scene:SCNScene!
    
    var ballNode:SCNNode!
    var goalkeeperNode:SCNNode!
    var selfieStickNode:SCNNode!
    
    var motion = MotionHelper()
    var motionForce = SCNVector3(0, 0, 0)
    
    var sounds:[String:SCNAudioSource] = [:]
    
    override func viewDidLoad() {
        setupScene()
        setupNodes()
        setupSounds()
    }
    
    func setupScene(){
        sceneView = (self.view as! SCNView)
//        sceneView.delegate = self
        
        //sceneView.allowsCameraControl = true
        scene = SCNScene(named: "art.scnassets/MainScene.scn")
        sceneView.scene = scene
        
        scene.physicsWorld.contactDelegate = self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(GameViewController.sceneViewTapped(recognizer:)))
        sceneView.addGestureRecognizer(tapRecognizer)
        
    }
    
    func setupNodes() {
        ballNode = scene.rootNode.childNode(withName: "ball", recursively: true)!
        ballNode.physicsBody?.contactTestBitMask = CategoryCrossbar
        goalkeeperNode = scene.rootNode.childNode(withName: "goalkeeper", recursively: true)!
        goalkeeperNode.physicsBody?.contactTestBitMask = CategoryBall
        selfieStickNode = scene.rootNode.childNode(withName: "selfieStick", recursively: true)!
    }
    
    func setupSounds() {
        let sawSound = SCNAudioSource(fileNamed: "chainsaw.wav")!
        let jumpSound = SCNAudioSource(fileNamed: "jump.wav")!
        sawSound.load()
        jumpSound.load()
        sawSound.volume = 0.8
        jumpSound.volume = 1.0
        
        sounds["saw"] = sawSound
        sounds["jump"] = jumpSound
        
        let backgroundMusic = SCNAudioSource(fileNamed: "background.mp3")!
        backgroundMusic.volume = 0.3
        backgroundMusic.loops = true
        backgroundMusic.load()
        
        let musicPlayer = SCNAudioPlayer(source: backgroundMusic)
        ballNode.addAudioPlayer(musicPlayer)
        
    }
    
    @objc func sceneViewTapped (recognizer:UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first
            if let node = result?.node {
                if node.name == "ball" {
                    let jumpSound = sounds["jump"]!
                    ballNode.runAction(SCNAction.playAudio(jumpSound, waitForCompletion: false))
                    let sideVector:[Float]! = [-1.4, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1.5]
                    let heightVector:[Float]! = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
                    let distanceVector:[Float]! = [-5.5, -5.4, -5.3, -5.2, -5.1, -5.0, -4.9, -4.8, -4.7, -4.6, -4.5]
                    
//                    var p1:[[Float]] = []
//                    p1[0] = [0, 0.05]
//                    p1[1] = [0.05, 0.1]
//                    p1[2] = [0.1, 0.15]
//                    p1[3] = [0.15, 0.16]
//                    p1[4] = [0.16, 0.22]
//                    p1[5] = [0.22, 0.28]
//                    p1[6] = [0.28, 0.33]
//                    p1[7] = [0.33, 0.37]
//                    p1[8] = [0.37, 0.43]
//                    p1[9] = [0.43, 0.5]
//                    p1[10] = [0.5, 0.61]
//                    p1[11] = [0.61, 0.69]
//                    p1[12] = [0.69, 0.72]
//                    p1[13] = [0.72, 0.85]
//                    p1[14] = [0.85, 1]
                    
                    
                    let side = sideVector[Int.random(in: 0...10)]
                    let height = heightVector[Int.random(in: 0...10)]
                    let distance = distanceVector[Int.random(in: 0...10)]
                    ballNode.physicsBody?.applyForce(SCNVector3(x: side, y: height, z: distance), asImpulse: true)
                    
                    let waitDefend = SCNAction.wait(duration: 0.01)
                    let defending = SCNAction.run { (node) in
                        let sideVectorGoalKeeper:[Float]! = [-1.0, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1]
                        let jumpVectorGoalKeeper:[Float]! = [0, 0.2, 0.4, 0.6, 0.8, 1]
                        let sideGoalKeeper = sideVectorGoalKeeper[Int.random(in: 0...10)] * 250.0
                        let jumpVector = jumpVectorGoalKeeper[Int.random(in: 0...5)] * 250.0
                        node.physicsBody?.applyForce(SCNVector3(x: sideGoalKeeper, y: jumpVector, z: 0), asImpulse: true)
                    }
                    let defend = SCNAction.sequence([waitDefend, defending])
                    goalkeeperNode.runAction(defend)
                    
                    let waitAction = SCNAction.wait(duration: 3)
                    let reset = SCNAction.run { (node) in
                        node.physicsBody?.clearAllForces()
                        node.position = SCNVector3(x: 0, y: 0, z: 0)
                    }
                    let actionSequence = SCNAction.sequence([waitAction, reset])
                    ballNode.runAction(actionSequence)
                    goalkeeperNode.runAction(actionSequence)
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

//extension GameViewController : SCNSceneRendererDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        let ball = ballNode.presentation
//        let ballPosition = ball.position
//
//        let targetPosition = SCNVector3(x: ballPosition.x, y: ballPosition.y + 5, z:ballPosition.z + 5)
//        var cameraPosition = selfieStickNode.position
//
//        let camDamping:Float = 0.3
//
//        let xComponent = cameraPosition.x * (1 - camDamping) + targetPosition.x * camDamping
//        let yComponent = cameraPosition.y * (1 - camDamping) + targetPosition.y * camDamping
//        let zComponent = cameraPosition.z * (1 - camDamping) + targetPosition.z * camDamping
//
//        cameraPosition = SCNVector3(x: xComponent, y: yComponent, z: zComponent)
//        selfieStickNode.position = cameraPosition
//
//
//        motion.getAccelerometerData { (x, y, z) in
//            self.motionForce = SCNVector3(x: x * 0.05, y:0, z: (y + 0.8) * -0.05)
//        }
//
//        ballNode.physicsBody?.velocity += motionForce
//
//    }
//
//
//}

extension GameViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var contactNode:SCNNode!
        
        if contact.nodeA.name == "ball" {
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        if contactNode.physicsBody?.categoryBitMask == CategoryCrossbar || contactNode.physicsBody?.categoryBitMask == CategoryGoal || contactNode.physicsBody?.categoryBitMask == CategoryGoalKeeper {
//            contactNode.isHidden = true
            
            let sawSound = sounds["saw"]!
            ballNode.runAction(SCNAction.playAudio(sawSound, waitForCompletion: false))
            
//            let waitAction = SCNAction.wait(duration: 5)
//            let unhideAction = SCNAction.run { (node) in
//                node.isHidden = false
//            }
//            let actionSequence = SCNAction.sequence([waitAction, unhideAction])
//            contactNode.runAction(actionSequence)
        }
        
    }
    
    
}

