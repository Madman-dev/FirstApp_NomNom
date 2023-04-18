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
    let messageField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        view.addSubview(messageView)
        view.addSubview(messageField)
        view.addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerYAnchor.constraint(equalTo: messageView.centerYAnchor, constant: 50).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.setTitle("Press Here", for: .normal)
        sendButton.layer.cornerRadius = 15
        sendButton.backgroundColor = .white
        sendButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        messageField.becomeFirstResponder()
        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.attributedPlaceholder = NSAttributedString(string: "Write Your Todos!",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemPink])
        messageField.textColor = .black
        messageField.textAlignment = .center
        messageField.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
        messageField.leftAnchor.constraint(equalTo: messageView.leftAnchor).isActive = true
        messageField.rightAnchor.constraint(equalTo: messageView.rightAnchor).isActive = true
        messageField.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 50).isActive = true
        messageField.backgroundColor = .clear
        
    }
    
    override func viewDidLayoutSubviews() {
        messageView.backgroundColor = .systemPink
        messageView.layer.cornerRadius = 180/5
        messageView.clipsToBounds = true
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 20).isActive = true
        messageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        messageView.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    /// dismiss everything outside this position
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.messageView
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

