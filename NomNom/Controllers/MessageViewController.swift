//
//  MessageViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/08.
//

import UIKit

class MessageViewController: UIViewController {

    let messageChat: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.backgroundColor = UIColor.blue
        tf.placeholder = "Placeholder"
        tf.text = "시험"
        tf.font = UIFont.systemFont(ofSize: 12, weight: .medium)
///        tf.topAnchor.constraint(equalTo: view., constant: 10)
//        tf.backgroundColor = .blue
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
    }
    
    func configure() {
        view.addSubview(messageChat)
//        messageChat.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        messageChat.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
//        messageChat.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
//        messageChat.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        view.backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Message: UIView {
    let messageChat: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        //        tf.backgroundColor = UIColor.blue
        tf.placeholder = "Placeholder"
        tf.text = "시험"
        tf.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        ///        tf.topAnchor.constraint(equalTo: view., constant: 10)
        //        tf.backgroundColor = .blue
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(messageChat)
        messageChat.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageChat.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        messageChat.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        messageChat.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
        
        self.backgroundColor = .black
        self.frame = UIScreen.main.bounds/// 여기에 바운드 효과를 넣는거다..?
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
