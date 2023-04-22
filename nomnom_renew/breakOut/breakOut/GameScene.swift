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
    
    let ballCategory    : UInt32 = 0x1 << 0
    let bottomCategory  : UInt32 = 0x1 << 1
    let brickCategory   : UInt32 = 0x1 << 2
    let paddleCategory  : UInt32 = 0x1 << 3
    let BorderCategory  : UInt32 = 0x1 << 4

    override init(size: CGSize) {
        super.init(size: size)
        
        self.physicsWorld.contactDelegate = self
        
        let backgroundImage = SKSpriteNode(imageNamed: "bg")
        backgroundImage.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        self.addChild(backgroundImage)
        
        physicsWorld.gravity = CGVectorMake(0, 0)   // removes all gravity from scene
        
        let ball = SKSpriteNode(imageNamed: "ball") // getting the ball onto scene
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
        
        ball.physicsBody?.applyImpulse(CGVectorMake(0, -9.8))   // this gives the push -> gravitational movement
        
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 3) // height of paddle
        self.addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody?.isDynamic = false   // the paddle doesn't move
        

        ball.physicsBody?.categoryBitMask = ballCategory
        paddle.physicsBody?.categoryBitMask = paddleCategory
        ball.physicsBody!.contactTestBitMask = bottomCategory | brickCategory

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
                    return self.frame.size.height * 0.7
//                case 3:
//                    return self.frame.size.height * 0.2
                default:
                    return 0
                }
            }
            
            for index in 1 ... numberOfBricks {
                let brick = SKSpriteNode(imageNamed: "brick")
                
                let calc1: Float = Float(index) - 1
                let calc2: Float = Float(index) - 3
                
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
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody

        
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        bottom.physicsBody?.categoryBitMask = bottomCategory
        
        
        let paddle = childNode(withName: paddleCategoryName) as! SKSpriteNode
        bottom.physicsBody!.categoryBitMask = bottomCategory
        borderBody.categoryBitMask = BorderCategory
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

    /// code that gets touch and uses it to find location on screen where the touch occurred.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == paddleCategoryName {
                print("패들이 눌렸습니다.")
                fingerIsOnPaddle = true
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fingerIsOnPaddle {
            /// touch가 일어난 포인트를 알아야하니, 1) 현재 터치 부분 2) 이전 터치 부분으로 나뉘어 확인
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let prevTouchLocation = touch!.previousLocation(in: self)
            
            let paddle = childNode(withName: paddleCategoryName) as! SKSpriteNode
            
            /// 이 부분이 이해 안돼요... >>> paddle.position.x를 더하는 이유는 단순히 터치를 한 영역에서 현재 터치 영역을 뺀, 대략적인 값을 구하는게 아니라 - 절대적으로 존재하는 paddle 위치를 알려주어야 하기에!
            var paddleX = paddle.position.x + (touchLocation.x - prevTouchLocation.x)
            
            /// 이 부분이 min & max인 이유가 화면 범위 밖으로 내보내지 않도록 하는 거구나!
            paddleX = max(paddleX, paddle.size.width / 2)
            paddleX = min(paddleX, self.size.width - paddle.size.width / 2)
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /// touch가 끝났으니까 false로 변동
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
