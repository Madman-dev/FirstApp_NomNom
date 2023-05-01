//
//  LoginPage.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/11.
//

import UIKit

class IntroViewController: UIViewController {

    private let imageView: UIImageView = {
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
        view.addSubview(imageView)
        imageView.center = view.center
        // imageView.frame = view.bounds >> 이 코드로 인해 X,Y 값이 반전 되었다.
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { /// ⭐️ 이부분은 우리에게 보이고 나서 실행되는 부분을 뜻하는구나
            self.animation()
        }
    }
    
    private func animation() {
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
