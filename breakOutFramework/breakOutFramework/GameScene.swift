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
import AVFoundation

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var audioPlayer: AVAudioPlayer? ///추가된 데이터
    
    let displaySize: CGRect = UIScreen.main.bounds  ///추가된 데이터 >>> 공기 범위 내로 튕길 수 있도록 지정해 두었다
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
    
    /// 🙋🏻‍♂️ 더 좋은 방법이 없을까...GPT의 추천
    var brickNumbers = UserDefaults.standard.integer(forKey: "NumberOfBricks")
    var numberOfRows: Int {     ///추가된 데이터
        if brickNumbers <= 3 {
            return 1
        } else if brickNumbers >= 4 && brickNumbers <= 7 {
            return 2
        } else if brickNumbers < 50 {
            return 3
        } else {
            return 0
        }
    }
    
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
    
    override public init(size: CGSize) {
        super.init(size: size)
        self.physicsWorld.contactDelegate = self
        
        let backgroundImage = SKSpriteNode(imageNamed: "bg")
        backgroundImage.position = CGPointMake(0.5, 0.5)
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
        
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody!.contactTestBitMask = bottomCategory | brickCategory | borderCategory | paddleCategory
    }
    
    /// ⭐️ 이 친구의 역할 파악
    public override func didMove(to view: SKView) {
        /// scene이 하단으로 고정이 되어 있었기에 0.5로 위치를 변경시킨 것
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)        /// 추가된 데이터 >>> ball을 제외한 모든게 다 scene에 연결되어 있는건가 >>> 그런 듯, paddle은 제한 해제, brick 변경 필요⭐️
        scene?.size = CGSize(width: displaySize.width, height: displaySize.height)
        
        /// added edge-based Body -> 🙋🏻‍♂️ 정확하게 알지 못함
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        bottom.physicsBody!.categoryBitMask = bottomCategory
        borderBody.categoryBitMask = borderCategory
        
        let gameMessage = SKSpriteNode(imageNamed: "TapToPlay")
        gameMessage.name = GameMessageName
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
        gameState.enter(WaitingForTap.self)
    
        
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = paddleCategoryName
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * -7)    /// ⭐️ 여기가 아니야? >> 여기서 paddle 위치 지정 하단으로
        self.addChild(paddle)
        
        /// 패들의 크기 지정
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody?.isDynamic = false   // the paddle doesn't move
        paddle.physicsBody?.categoryBitMask = paddleCategory
        
        
        
        let brickWidth = SKSpriteNode(imageNamed: "brick").size.width
        let totalBrickWidth = brickWidth + CGFloat(brickNumbers)
        let xOffset = (frame.width - totalBrickWidth) / 2
        /// ⏲️ 해결? -> let numberOfRows = 2 >>> 여기에 todo 데이터를 가지고 올 수 있도록 >>> ⭐️ brick 수를 불러오는 함수가 이미 존재, 해당 함수에서 데이터를 던질 수 있도록 조정
        /// print number of rows on gameScene
//        for rows in 1...numberOfRows {
//            var yOffset: CGFloat {
//                if rows == 1 {
//                    /// when only one row, height of bricks
//                    return self.frame.size.height * 0.8
//                } else if rows == 2 {
//                    /// additionals
//                    return self.frame.size.height * 0.8
//                } else {
//                    return self.frame.size.height * 0
//                }
//            }
//        }
        
        for bricks in 1...brickNumbers {
            let brick = SKSpriteNode(imageNamed: "brick")
            /// 이 친구가 정확하게 어떤걸 뜻하는거지??? 내가 생각한건 판자 갯수인데 왜...?
//            brick.position = CGPoint(x: xOffset + CGFloat(CGFloat(bricks) + 0.5) * brickWidth, y: frame.height * 0.5)
            brick.position = CGPoint(x: 0 + CGFloat(CGFloat(bricks)), y: 0)
            
            /// 여기 x position을 언급할 때 사용이 되는거지??
            //                brick.position = CGPointMake(CGFloat(xCalculation * Float(brick.frame.size.width)), yOffset)
            brick.physicsBody = SKPhysicsBody(rectangleOf: brick.frame.size)
            brick.name = brickCategoryName
            brick.physicsBody?.allowsRotation = false
            brick.physicsBody?.isDynamic = false
            brick.physicsBody?.friction = 0
            brick.physicsBody?.categoryBitMask = brickCategory
            brick.zPosition = 2
            self.addChild(brick)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /// code that gets touch and uses it to find location on screen where the touch occurred.
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            }
        default:
            break
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fingerIsOnPaddle {
            /// touch가 일어난 포인트를 알아야하니, 1) 현재 터치 부분 2) 이전 터치 부분으로 나뉘어 확인
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            
            let paddle = childNode(withName: paddleCategoryName) as! SKSpriteNode
            
            /// 이 부분이 이해 안돼요... >>> paddle.position.x를 더하는 이유는 단순히 터치를 한 영역에서 현재 터치 영역을 뺀, 대략적인 값을 구하는게 아니라 - 절대적으로 존재하는 paddle 위치를 알려주어야 하기에!
            /// ⭐️ gameScene 위치 변동하면서 값 확인 필요
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            ///⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 이 부분이 min & max인 이유가 화면 범위 밖으로 내보내지 않도록 하는 거구나!
            //            paddleX = max(paddleX, paddle.size.width/2)
            //            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    
    /// gesture 움직임 종료 확인 시점
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fingerIsOnPaddle = false
    }
    
    /// mainVC에서 데이터 값을 gameScene에서 업데이트할 수 있도록 함수로 데이터 전달 시도 ⭐️
    //    public func updateBricksInGame(completedTodos: Int) {
    //        brickNumbers = completedTodos
    //    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
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
            
            /// you hit floor, game lost
            if firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory {
                print("탈락!")
                //                gameState.enter(GameOver.self)
                //                gameWon = false
            }
            
            /// ball hitting the bricks, making sound & removing brick from node
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
    
    /// 판자가 부셔지는 애니메이션 - 나중에 이 친구도 해결해보기로, 우선은 제거만
    func breakBlock(node: SKNode) {
        //        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")
        //        particles?.position = node.position
        //        particles?.zPosition = 3
        //        addChild(particles!)
        //        particles!.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
        node.removeFromParent()
    }
    
    /// returns random float between two passed in numbers - vaiability to the ball starting direction
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    /// this method is called before each frame is rendered - where we call playing state update to manage ball velocity
    public override func update(_ currentTime: TimeInterval) {
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
