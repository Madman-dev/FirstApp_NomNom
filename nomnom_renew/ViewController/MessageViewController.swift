//
//  MessageViewController.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

protocol MessageViewControllerDelegate: AnyObject {
    func messageViewController(_ vc: MessageViewController, didSaveTodo todo: Todo)
}

class MessageViewController: UIViewController {
    
    weak var delegate: MessageViewControllerDelegate?
    var todo: Todo?
    
    let messageView = UIView()
    let saveButton = UIButton()
    let messageField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        messageField.text = todo?.title
        view.addSubview(messageView)
        view.addSubview(messageField)
        view.addSubview(saveButton)
        messageView.addSubview(saveButton)
        
        messageField.becomeFirstResponder()
        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.attributedPlaceholder = NSAttributedString(string: "24자 이내로 투두를 작성해보세요!",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        messageField.textColor = .white
        messageField.textAlignment = .center
        messageField.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
        messageField.leftAnchor.constraint(equalTo: messageView.leftAnchor).isActive = true
        messageField.rightAnchor.constraint(equalTo: messageView.rightAnchor).isActive = true
        messageField.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 100).isActive = true
        messageField.backgroundColor = .clear
        
        messageView.backgroundColor = .systemPink
        messageView.layer.cornerRadius = 180/10
        messageView.clipsToBounds = true
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        messageView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -155).isActive = true
        messageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -30).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: messageView.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.setTitle("더하기", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .white
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.messageView
        { self.dismiss(animated: true)}
    }
    
    @objc func saveTapped(_ sender: UIButton) {
        print("이건가 눌렷습니다")
        
        let todo = Todo(title: messageField.text!)
        delegate?.messageViewController(self, didSaveTodo: todo)
        dismiss(animated: true)
    }
    
}
