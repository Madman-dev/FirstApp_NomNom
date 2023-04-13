//
//  MessageViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/08.
//

import UIKit

protocol MessageViewControllerDelegate: AnyObject {
    func messageViewController(_ vc: MessageViewController, didSaveTodo: Todo)
}

class MessageViewController: UIViewController {
    
    weak var delegate: MessageViewControllerDelegate?
    var todo: Todo?

    let messageView = UIView()
    let sendButton = UIButton()
//    let messageField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(messageView)
        view.addSubview(sendButton)
        //        view.addSubview(messageField)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        sendButton.backgroundColor = .blue
        sendButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
//        messageField.translatesAutoresizingMaskIntoConstraints = false
//        messageField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        messageField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
//        messageField.backgroundColor = .green
    }
    
    override func viewDidLayoutSubviews() {
        messageView.backgroundColor = .yellow
        messageView.layer.cornerRadius = 180/2
        messageView.clipsToBounds = true
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messageView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    /// dismiss everything outside this position
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        if touch?.view != self.sendButton //container >> 원래
//        { self.dismiss(animated: true)}
//    }

    @objc func save(_ sender: UIButton) {
        print("되돌아가기 버튼이 눌렸습니다.")
//        let todo = Todo(title: messageField.text!)
//        delegate?.messageViewController(self, didSaveTodo: todo)
        dismiss(animated: true)
    }
}

