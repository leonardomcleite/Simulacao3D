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
    
    var goals:Int = 0
    var defenses:Int = 0
    var lost:Int = 0
    var entrou:Bool = false
    
    var sceneView:SCNView!
    var scene:SCNScene!
    
    var ballNode:SCNNode!
    var crossbarNode:SCNNode!
    var goalkeeperNode:SCNNode!
    var selfieStickNode:SCNNode!
    
    var goalsNode:SCNNode!
    var lostNode:SCNNode!
    var defenseNode:SCNNode!
    
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
        ballNode.physicsBody?.contactTestBitMask = 46
        goalkeeperNode = scene.rootNode.childNode(withName: "goalkeeper", recursively: true)!
        goalkeeperNode.physicsBody?.contactTestBitMask = CategoryBall
        selfieStickNode = scene.rootNode.childNode(withName: "selfieStick", recursively: true)!
        crossbarNode = scene.rootNode.childNode(withName: "crossbar", recursively: true)!
        crossbarNode.physicsBody?.contactTestBitMask = CategoryBall
        goalsNode = scene.rootNode.childNode(withName: "goals", recursively: true)!
        lostNode = scene.rootNode.childNode(withName: "lost", recursively: true)!
        defenseNode = scene.rootNode.childNode(withName: "defense", recursively: true)!
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
                    let sideVector:[Float]! = [-2, -1.4, -0.8, -0.6, -0.2, 0, 0.2, 0.6, 0.8, 1.5, 2]
                    let heightVector:[Float]! = [0.0, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 2.0, 3.0]
                    let distanceVector:[Float]! = [-5.5, -5.4, -5.3, -5.2, -5.1, -5.0, -4.9, -4.8, -4.7, -4.6, -4.5]
                    
                    var side = sideVector[Int.random(in: 0...10)]
                    var height = heightVector[Int.random(in: 0...10)]
                    var distance = distanceVector[Int.random(in: 0...10)]
                    
                    let dadoSide = Int.random(in: 0...100);
                    if dadoSide >= 0 && dadoSide <= 5 {
                        side = sideVector[0]
                    } else if dadoSide <= 22 {
                        side = sideVector[1]
                    } else if dadoSide <= 25 {
                        side = sideVector[2]
                    } else if dadoSide <= 30 {
                        side = sideVector[3]
                    } else if dadoSide <= 31 {
                        side = sideVector[4]
                    } else if dadoSide <= 32 {
                        side = sideVector[5]
                    } else if dadoSide <= 33 {
                        side = sideVector[6]
                    } else if dadoSide <= 80 {
                        side = sideVector[7]
                    } else if dadoSide <= 95 {
                        side = sideVector[8]
                    } else {
                        side = sideVector[9]
                    }
                    
                    let dadoHeight = Int.random(in: 0...100);
                    if dadoHeight >= 0 && dadoHeight <= 10 {
                        height = heightVector[0]
                    } else if dadoHeight > 10  && dadoHeight <= 20 {
                        height = heightVector[1]
                    } else if dadoHeight > 20 && dadoHeight <= 30 {
                        height = heightVector[2]
                    } else if dadoHeight > 0 && dadoHeight <= 40 {
                        height = heightVector[3]
                    } else if dadoHeight > 0 && dadoHeight <= 50 {
                        height = heightVector[4]
                    } else if dadoHeight > 0 && dadoHeight <= 60 {
                        height = heightVector[5]
                    } else if dadoHeight > 0 && dadoHeight <= 70 {
                        height = heightVector[6]
                    } else if dadoHeight > 0 && dadoHeight <= 80 {
                        height = heightVector[7]
                    } else if dadoHeight > 0 && dadoHeight <= 90 {
                        height = heightVector[8]
                    } else {
                        height = heightVector[9]
                    }
                    
                    let dadoDistance = Int.random(in: 0...100);
                    if dadoDistance >= 0 && dadoDistance <= 10 {
                        distance = distanceVector[0]
                    } else if dadoDistance > 10  && dadoDistance <= 20 {
                        distance = distanceVector[1]
                    } else if dadoDistance > 20 && dadoDistance <= 30 {
                        distance = distanceVector[2]
                    } else if dadoDistance > 0 && dadoDistance <= 40 {
                        distance = distanceVector[3]
                    } else if dadoDistance > 0 && dadoDistance <= 50 {
                        distance = distanceVector[4]
                    } else if dadoDistance > 0 && dadoDistance <= 60 {
                        distance = distanceVector[5]
                    } else if dadoDistance > 0 && dadoDistance <= 70 {
                        distance = distanceVector[6]
                    } else if dadoDistance > 0 && dadoDistance <= 80 {
                        distance = distanceVector[7]
                    } else if dadoDistance > 0 && dadoDistance <= 90 {
                        distance = distanceVector[8]
                    } else {
                        distance = distanceVector[9]
                    }
                    
                    ballNode.physicsBody?.applyForce(SCNVector3(x: side, y: height, z: distance), asImpulse: true)
                    
                    let waitDefend = SCNAction.wait(duration: 0.01)
                    let defending = SCNAction.run { (node) in
                        
                        let sideVectorGoalKeeper:[Float]! = [-1.0, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1]
                        let jumpVectorGoalKeeper:[Float]! = [0, 0.2, 0.4, 0.6, 0.8, 1]
                        
                        var sideGoalKeeper = sideVectorGoalKeeper[Int.random(in: 0...10)] * 250.0
                        var jump = jumpVectorGoalKeeper[Int.random(in: 0...5)] * 200.0
                        
                        let dadoSide = Int.random(in: 0...100);
                        if dadoSide >= 0 && dadoSide <= 21 {
                            sideGoalKeeper = sideVectorGoalKeeper[0]
                        } else if dadoSide <= 42 {
                            sideGoalKeeper = sideVectorGoalKeeper[1]
                        } else if dadoSide <= 43 {
                            sideGoalKeeper = sideVectorGoalKeeper[2]
                        } else if dadoSide <= 44 {
                            sideGoalKeeper = sideVectorGoalKeeper[3]
                        } else if dadoSide <= 45 {
                            sideGoalKeeper = sideVectorGoalKeeper[4]
                        } else if dadoSide <= 46 {
                            sideGoalKeeper = sideVectorGoalKeeper[5]
                        } else if dadoSide <= 47 {
                            sideGoalKeeper = sideVectorGoalKeeper[6]
                        } else if dadoSide <= 48 {
                            sideGoalKeeper = sideVectorGoalKeeper[7]
                        } else if dadoSide <= 70 {
                            sideGoalKeeper = sideVectorGoalKeeper[8]
                        } else {
                            sideGoalKeeper = sideVectorGoalKeeper[9]
                        }
                        
                        let dadoJump = Int.random(in: 0...100);
                        if dadoJump >= 0 && dadoJump <= 16 {
                            jump = jumpVectorGoalKeeper[0]
                        } else if dadoJump >  16  && dadoJump <= 33 {
                            jump = jumpVectorGoalKeeper[1]
                        } else if dadoJump >  33 && dadoJump <= 50 {
                            jump = jumpVectorGoalKeeper[2]
                        } else if dadoJump > 50 && dadoJump <= 67 {
                            jump = jumpVectorGoalKeeper[3]
                        } else if dadoJump > 67 && dadoJump <= 83 {
                            jump = jumpVectorGoalKeeper[4]
                        } else {
                            jump = jumpVectorGoalKeeper[5]
                        }
                        
                        sideGoalKeeper = sideGoalKeeper * 100.0
                        jump = jump * 100.0
                        
                        node.physicsBody?.applyForce(SCNVector3(x: sideGoalKeeper, y: jump, z: 0), asImpulse: true)
                    }
                    let defend = SCNAction.sequence([waitDefend, defending])
                    goalkeeperNode.runAction(defend)
                    
                    let waitAction = SCNAction.wait(duration: 3)
                    let reset = SCNAction.run { (node) in
                        node.physicsBody?.clearAllForces()
                        node.position = SCNVector3(x: 0, y: 0, z: 0)
                        self.entrou = false
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
        if entrou {
            return
        }
        lost += 1
        entrou = true
        if contact.nodeA.name == "ball" {
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        if contactNode.physicsBody?.categoryBitMask == CategoryCrossbar ||
            contactNode.physicsBody?.categoryBitMask == CategoryGoal ||
            contactNode.physicsBody?.categoryBitMask == CategoryGoalKeeper {
            
            let cat = (contactNode.physicsBody?.categoryBitMask)
            
            switch cat {
            case CategoryGoal:
                lost -= 1
                goals += 1
            case CategoryCrossbar:
                lost -= 1
                goals += 1
            case CategoryGoalKeeper:
                lost -= 1
                defenses += 1
            default:
                print("Saiu")
            }
            
            let sawSound = sounds["saw"]!
            ballNode.runAction(SCNAction.playAudio(sawSound, waitForCompletion: false))
        }
        
    
        let goalsNodeText = goalsNode.geometry as! SCNText
        goalsNodeText.string = String(goals)
        
        let defensesText = defenseNode.geometry as! SCNText
        defensesText.string = String(defenses)
        
        let lostText = lostNode.geometry as! SCNText
        lostText.string = String(lost)
        
    }
    
    
}

