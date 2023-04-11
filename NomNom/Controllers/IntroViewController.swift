//
//  LoginPage.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/11.
//

import UIKit

class IntroViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .black
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.center = view.center
        imageView.frame = view.bounds
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { /// ⭐️ 이부분은 우리에게 보이고 나서 실행되는 부분을 뜻하는구나
            self.animate()
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            
            let size = self.view.frame.size.width
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size )
        })
        
        UIView.animate(withDuration: 2, animations: {
            self.imageView.alpha = 0 }, completion: {done in
                if done {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
                        homeVC.modalTransitionStyle = .crossDissolve
                        homeVC.modalPresentationStyle = .fullScreen
                        self.present(homeVC, animated: true)
                    })
                }
            })
    }
}

//    private func animation() {
//        UIView.animate(withDuration: 1) {   /// 이 부분이 애니메이션을 실행하는 속도
//            let size = self.view.frame.size.width * 2.5
//            let diffX = size - self.view.frame.size.width
//            let diffY = self.view.frame.size.height - size
//
//            self.imageView.frame = CGRect(
//                x: -(diffX / 2),
//                y: diffY / 2,
//                width: size,
//                height: size
//            )
//        }
//        UIView.animate(withDuration: 1.5, animations: {
//            self.imageView.alpha = 0    /// 이 부분이 opacity 적용되는 구간
//        }, completion: { done in
//            if done {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
////                    let viewController = MainViewController()
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let homeVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
//                    homeVC.modalTransitionStyle = .crossDissolve
//                    homeVC.modalPresentationStyle = .fullScreen
//                    self.present(homeVC, animated: true)
//                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)  // MainViewController()로 연결을 하면 연결이 되는게 아니라 새로운 ViewController을 만드는 것이라고 한다. 그렇기에 UIStoryboard(name:,bundle)을 통해 특정한 viewController로 연결을 시키는 것!
//                        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
//                    })
//                })
//            }
//        })
//    }
//}
//    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 3) {
//            self.imageView.frame.origin.x += 500
//            self.animation()
//        }
//    }



//extension AppDelegate {
//
//    func initNavigationVC() {
//        self.navigationVC = UINavigationController()
//        self.navigationVC?.isNavigationBarHidden = true
//
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Intro", bundle: nil)
//        let introVC = storyBoard.instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
//        self.navigationVC?.setViewControllers([introVC], animated: false)
//
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window!.rootViewController = navigationVC
//        self.window!.makeKeyAndVisible()
