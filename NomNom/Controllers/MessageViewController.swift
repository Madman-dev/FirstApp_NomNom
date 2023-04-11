//
//  MessageViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/08.
//

import UIKit

class MessageViewController: UIViewController {
    
//    var animatedView: UIView!
//    var animateCallback: (() -> Void)?

    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
//
//    let todoField: UITextField = {
//        let tf = UITextField()
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        //        tf.backgroundColor = UIColor.blue
//        tf.placeholder = "Placeholder"
//        tf.text = "시험"
//        tf.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        ///        tf.topAnchor.constraint(equalTo: view., constant: 10)
//        //        tf.backgroundColor = .blue
//        return tf
//    }()
//
//    let registerButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor.red
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        // 🔥 animation 효과 적용 시도
//        animatedView = UIView(frame: CGRect(x: 50, y: 180, width: 300, height: 300))
//        animatedView.backgroundColor = UIColor.red
//        view.addSubview(animatedView)
        
//        triggerAnimateCallback()

//        UIView.animate(withDuration: 5, animations: {
//            self.view.backgroundColor = UIColor.clear
//        })
//        container.frame = UIScreen.main.bounds/// 여기에 바운드 효과를 넣는거다..?
        configure()
        
    }
    
    func configure() {
//        view.addSubview(todoField)
//        view.addSubview(registerButton)
        view.addSubview(container)
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    }
    
    /// 🔥 failed impletmenting a transition of UIView
//    func triggerAnimateCallback() {
//        animateCallback?()
//    }

    
    /// dismiss everything outside this position
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.container //container >> 원래
        { self.dismiss(animated: true)}
    }
    
}

