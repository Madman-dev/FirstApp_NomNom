//
//  MessageViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/08.
//

import UIKit

class MessageViewController: UIViewController {
    
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
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        container.frame = UIScreen.main.bounds/// 여기에 바운드 효과를 넣는거다..?
        configure()
    }
    
    func configure() {
//        view.addSubview(todoField)
//        view.addSubview(registerButton)
        view.addSubview(container)
        //        view.addSubview(messageChat)
        //        messageChat.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        messageChat.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        //        messageChat.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        //        messageChat.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        container.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
    }
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.3) {
            self.container.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}

