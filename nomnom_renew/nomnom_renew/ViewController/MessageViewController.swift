//
//  MessageViewController.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
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
    let messageField = UITextField()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        view.addSubview(messageView)
        view.addSubview(messageField)
        view.addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 5).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: 5).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 10).isActive = true
        sendButton.backgroundColor = .blue
        sendButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        messageField.backgroundColor = .green
    }
    
    
    override func viewDidLayoutSubviews() {
        messageView.backgroundColor = .yellow
        messageView.layer.cornerRadius = view.layer.bounds.width/15
        messageView.clipsToBounds = true
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.setDimensions(height: 100, width: 100)
        messageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true //, constant: 80
        messageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true // , constant: -80
        messageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true //, constant: 250
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true //, constant: -150
    }

    /// dismiss everything outside this position
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.messageField //container >> 원래
        { self.dismiss(animated: true)}
    }
    
    // every time the button is clicked, it creates new todo and send back to the delegate && with this data I can use this to update the cell, create new one or anything else with it >> 버튼을 누르면 사라지기는 하지만 데이터는 업데이트가 되고 있지 않다 >> THIS HAS TO BE DONE ON TABLEVIEW

    @objc func saveTapped(_ sender: UIButton) {
        let todo = Todo(title: messageField.text!)
        delegate?.messageViewController(self, didSaveTodo: todo)
        print("되돌아가기 버튼이 눌렸습니다.")
        dismiss(animated: true)
    }
}

