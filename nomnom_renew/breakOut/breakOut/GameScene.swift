//
//  GameScene.swift
//  breakOut
//
//  Created by Jack Lee on 2023/04/21.
//

/// 1) 범위 지정하기
/// 2) 모든 브릭을 없앤 이후 문구 출력

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var fingerIsOnPaddle = false
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    
    var gameWon: Bool = false {
        didSet {
            let gameOver = childNode(withName: GameMessageName) as! SKSpriteNode
            let textureName = gameWon ? "YouWon" : "GameOver"
            let texture = SKTexture(imageNamed: textureName)
            let actionSequence = SKAction.sequence([SKAction.setTexture(texture), SKAction.scale(to: 1.0, duration: 0.25)])
            
            run(gameWon ? gameOverSound : gameOverSound)
            gameOver.run(actionSequence)
        }
    }
    
    /// series of SKAction constants - load and play sound files - need to update contactTestBitMask - ball
    let blipSound = SKAction.playSoundFileNamed("pongblip", waitForCompletion: false)
    let blipPaddleSound = SKAction.playSoundFileNamed("paddleBlip", waitForCompletion: false)
    let bambooBreakSound = SKAction.playSoundFileNamed("BambooBreak", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("game-over", waitForCompletion: false)
    
    let ballCategoryName = "ball"
    let paddleCategoryName = "paddle"
    let brickCategoryName = "brick"
    let GameMessageName = "gameMessage"
    
    let ballCategory    : UInt32 = 0x1 << 0
    let bottomCategory  : UInt32 = 0x1 << 1
    let brickCategory   : UInt32 = 0x1 << 2
    let paddleCategory  : UInt32 = 0x1 << 3
    let borderCategory  : UInt32 = 0x1 << 4
    
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
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1.001
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        //        ball.physicsBody?.applyImpulse(CGVectorMake(10, -15))   // this gives the push -> gravitational movement
        
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
        ball.physicsBody!.contactTestBitMask = bottomCategory | brickCategory | borderCategory | paddleCategory   /// just to make sure sound is played when ball hits border or paddle
        
        let numberOfRows = 2    // 여기에 todo 데이터를 가지고 올 수 있도록
        let numberOfBricks = 5  // 여기도 바꿀 수 있도록
        let brickWidth = SKSpriteNode(imageNamed: "brick").size.width
        //        let totalBrickWidth = brickWidth * CGFloat(numberOfBricks)
        //        let padding: Float = 5
        
        //        let xOffset: Float = (Float(self.frame.size.width) - Float(brickWidth) * Float(numberOfBricks) + padding * (Float(numberOfBricks) - 1)) / 2
        
        for index in 1 ... numberOfRows {   /// This code is to print out the bricks on to screen
            var yOffset: CGFloat {
                switch index {
                case 1:
                    return self.frame.size.height * 0.9
                case 2:
                    return self.frame.size.height * 0.88    /// 🙋🏻‍♂️bricks have a gravitational movement of their own... why? >> fixed
                default:
                    return 0
                }
            }
            
            for index in 1 ... numberOfBricks {
                let brick = SKSpriteNode(imageNamed: "brick")
                
                let calc1: Float = Float(index) + 1.2
                //                let calc2: Float = Float(index) - 2
                
                brick.position =
                //                CGPointMake(CGFloat(calc1 * Float(brick.frame.size.width) + calc2 * padding + xOffset), yOffset)
                CGPointMake(CGFloat(calc1 * Float(brick.frame.size.width)), yOffset)
                
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
                brick.name = brickCategoryName
                brick.physicsBody?.allowsRotation = false
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.friction = 0
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
        borderBody.categoryBitMask = borderCategory
        
        let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
        gameMessage.name = GameMessageName
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
        gameState.enter(WaitingForTap.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// code that gets touch and uses it to find location on screen where the touch occurred.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enter(Playing.self)
            fingerIsOnPaddle = true
            
        case is Playing:
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            
            if let body = physicsWorld.body(at: touchLocation) {
                if body.node!.name == paddleCategoryName {
                    print("패들이 눌렸습니다.")
                    fingerIsOnPaddle = true
                }
            }
            /// 여기서 이전 화면으로 전환을 할 수 있는지 확인을 해보자
        case is GameOver:
            if let newScene = SKScene(fileNamed: "GameScene") as? GameScene {
                newScene.scaleMode = .aspectFit
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                self.view?.presentScene(newScene, transition: reveal)
                /// never ending loop -> successful game loading but never ends
//                let newGameScene = GameScene(size: (view?.bounds.size)!)
//                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//                self.view?.presentScene(newGameScene, transition: reveal)
            }
        default:
            break
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
        
        if gameState.currentState is Playing {
            
            var firstBody = SKPhysicsBody()
            var secondBody = SKPhysicsBody()
            
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            /// sound for border hit
            if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == borderCategory {
                run(blipSound)
            }
            
            /// sound for when ball hits paddle
            if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == paddleCategory {
                run(blipPaddleSound)
            }
            
            if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory {
                /// you hit floor, game lost
                print("탈락!")
                gameState.enter(GameOver.self)
                gameWon = false
            }
            
            if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == brickCategory {
                run(bambooBreakSound)
                breakBlock(node: secondBody.node!)
                secondBody.node?.removeFromParent()
                
                /// bricks are all broken - you win
                if isGameCompleted() {
                    print("끝!")
                    gameState.enter(GameOver.self)
                    gameWon = true
                }
            }
            
        }
    }
    
    func breakBlock(node: SKNode) {
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
        node.removeFromParent()
    }
    
    /// returns random float between two passed in numbers - vaiability to the ball starting direction
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    /// this method is called before each frame is rendered - where we call playing state update to manage ball velocity
    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)
    }
    
    /// checks how many bricks are left in scene by going through all scene's children.
    /// checks whether the child name is equal to brickCategoryName, if none is left - player has won and method returns true
    func isGameCompleted() -> Bool {
        var numberOfBricks = 0
        self.enumerateChildNodes(withName: brickCategoryName) {
            node, stop in
            numberOfBricks = numberOfBricks + 1
        }
        return numberOfBricks == 0
    }
    
}
