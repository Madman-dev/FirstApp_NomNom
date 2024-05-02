//
//  GameOver.swift
//  breakOut
//
//  Created by Jack Lee on 2023/04/23.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    let ballCategoryName = "ball"
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing {
            let ball = scene.childNode(withName: ballCategoryName) as! SKSpriteNode
            ball.physicsBody!.linearDamping = 1.0
            scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }
    
}
