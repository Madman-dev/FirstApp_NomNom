//
//  LoginPage.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/11.
//

import UIKit

class IntroViewController: UIViewController {

    private let loadingView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "Logo2")
        return imageView
    }()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        loadingView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.animation()
        }
    }
    
    private func animation() {
        UIView.animate(withDuration: 1, animations: {
            
            let size = self.view.frame.size.width
            let differenceX = size - self.view.frame.size.width
            let differenceY = self.view.frame.size.height - size
            
            self.loadingView.frame = CGRect(
                x: -(differenceX/2),
                y: differenceY/2,
                width: size,
                height: size )
        })
        
        UIView.animate(withDuration: 2, animations: {
            self.loadingView.alpha = 0 }, completion: {done in
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
