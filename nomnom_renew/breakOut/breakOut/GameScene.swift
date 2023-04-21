//
//  GameScene.swift
//  breakOut
//
//  Created by Jack Lee on 2023/04/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var fingerIsOnPaddle = false
    let ballCategoryName = "ball"
    let paddleCategoryName = "paddle"
    let brickCategoryName = "brick"
    
    let ballCategory: UInt32 = 0x1 << 0
    let bottomCategory: UInt32 = 0x1 << 1
    let brickCategory: UInt32 = 0x1 << 2
    let paddleCategory: UInt32 = 0x1 << 3

    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsWorld.contactDelegate = self
        
        let backgroundImage = SKSpriteNode(imageNamed: "bg")
        backgroundImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(backgroundImage)
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        let worldBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = worldBorder
        self.physicsBody?.friction = 0
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.name = ballCategoryName
        ball.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        self.addChild(ball)

        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.isDynamic = true
        
        ball.physicsBody?.applyImpulse(CGVectorMake(1, -1))
        
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 2)
        self.addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.friction = 0.4
        paddle.physicsBody?.restitution = 0.1
        paddle.physicsBody?.isDynamic = false   // the paddle doesn't move
        
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        
        self.addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        ball.physicsBody?.categoryBitMask = bottomCategory
        paddle.physicsBody?.categoryBitMask = bottomCategory
        
        ball.physicsBody?.contactTestBitMask = bottomCategory | brickCategory
        
        let numberOfRows = 2    // 여기에 todo 데이터를 가지고 올 수 있도록
        let numberOfBricks = 5  // 여기도 바꿀 수 있도록
        let brickWidth = SKSpriteNode(imageNamed: "brick").size.width
        let padding: Float = 5
        
        let offset: Float = (Float(self.frame.size.width) - Float(brickWidth) * Float(numberOfBricks) + padding * (Float(numberOfBricks) - 1)) / 2
        
        for index in 1 ... numberOfRows {
            
            var yOffset: CGFloat {
                switch index {
                case 1:
                    return self.frame.size.height * 0.8
                case 2:
                    return self.frame.size.height * 0.6
                case 3:
                    return self.frame.size.height * 0.4
                default:
                    return 0
                }
            }
            
            for index in 1 ... numberOfBricks {
                let brick = SKSpriteNode(imageNamed: "brick")
                
                let calc1: Float = Float(index) - 0.5
                let calc2: Float = Float(index) - 1
                
                brick.position =
                CGPointMake(CGFloat(calc1 * Float(brick.frame.size.width) + calc2 * padding + offset), yOffset)
                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
                brick.physicsBody?.allowsRotation = false
                brick.physicsBody?.friction = 0
                brick.name = brickCategoryName
                brick.physicsBody?.categoryBitMask = brickCategory
                
                self.addChild(brick)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        <#code#>
    }
    
    func isGameCompleted() -> Bool {
        var numberOfBricks = 0
        
        for nodeObject in self.children {
            let node = nodeObject as SKNode
            if node.name == brickCategoryName {
                numberOfBricks += 1
            }
        }
        return numberOfBricks <= 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first
        let touchLocation = touch.location(in: self)
        
        let body: SKPhysicsBody? = self.physicsWorld.body(at: touchLocation)
        if body?.node?.name == paddleCategoryName {
            print("패들이 눌렸습니다.")
            fingerIsOnPaddle = true
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fingerIsOnPaddle {
            let touch: UITouch! = touches.first
            let touchLoc = touch.location(in: self)
            let prevTouchLoc = touch.previousLocation(in: self)
            
            let paddle = self.childNode(withName: paddleCategoryName) as! SKSpriteNode
            
            var newXPos = paddle.position.x + (touchLoc.x - prevTouchLoc.x)
            paddle.position = CGPointMake(newXPos, position.y)
            
            newXPos = max(newXPos, paddle.size.width/2)
            newXPos = min(newXPos, self.size.width - paddle.size.width / 2)
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         fingerIsOnPaddle = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory {
            print("탈락!")
        }
        
        if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == brickCategory {
            secondBody.node?.removeFromParent()
            
            if isGameCompleted() {
                print("끝!")
            }
        }
    }
    
}
