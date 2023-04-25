//
//  gameViewController.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/25.
//

import UIKit
import SpriteKit
import GameplayKit
import breakOutFramework

class breakOutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView()
        view = skView
        
//        let skView = self.view as! SKView
        
        if skView.scene == nil {
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            let gameScene = GameScene(size: skView.bounds.size)
            gameScene.scaleMode = .aspectFill
            skView.presentScene(gameScene)
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
