//
//  gameViewController.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/25.
//

import UIKit
import SpriteKit
//import GameplayKit
import breakOutFramework

class breakOutViewController: UIViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 아래와 같이 구현을 했을 때는 강제로 구현을 하게 되면서 발생하는 문제점들이 많다는 점! seperately하게 될 경우, 발생하는 문제가 없다고 한다~ (WHY.... Oh WHY....)
        // let skView = self.view as! SKView
        let skView = SKView()
        view = skView
        
        if skView.scene == nil {
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            let gameScene = GameScene(size: skView.bounds.size)
            gameScene.scaleMode = .resizeFill
            skView.presentScene(gameScene)
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

