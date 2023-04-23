//
//  Playing.swift
//  breakOut
//
//  Created by Jack Lee on 2023/04/23.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    let ballCategoryName = "ball"
    
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            let ball = scene.childNode(withName: ballCategoryName) as! SKSpriteNode
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: randomDirection()))
        }
    }
    
    /// calls every frame while game is in playing state - get ball & check velocity, if fall below certain speed - ball gets caught in a loop -> gives a kick from an angle - to prevent from happening.
    override func update(deltaTime seconds: TimeInterval) {
        let ball = scene.childNode(withName: ballCategoryName) as! SKSpriteNode
        let maxSpeed: CGFloat = 400.0
        
        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        
        if xSpeed <= 10.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        }
        if ySpeed <= 10.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx:0.0, dy: randomDirection()))
        }
        
        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
        } else {
            ball.physicsBody!.linearDamping = 0.0
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }
    
    /// flips coin and returns positive or negative number - randomness to the direction of ball
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 3.0
        if scene.randomFloat(from: 0.0, to: 100.0) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }
    
}
