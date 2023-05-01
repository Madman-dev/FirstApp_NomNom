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
        messageField.attributedPlaceholder = NSAttributedString(string: "Write Your Todos!",
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
        saveButton.setTitle("맞아?", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .white
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
//    override func viewDidLayoutSubviews() {
        /* ⏲️기존 messageView -> error 수치 조정 중
        messageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 70).isActive = true
        messageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -70).isActive = true
        messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
         ==================== */
//    }

    /// dismiss everything outside this position
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.messageView
        { self.dismiss(animated: true)}
    }
    
    // every time the button is clicked, it creates new todo and send back to the delegate && with this data I can use this to update the cell, create new one or anything else with it >> 버튼을 누르면 사라지기는 하지만 데이터는 업데이트가 되고 있지 않다 >> THIS HAS TO BE DONE ON TABLEVIEW

    @objc func saveTapped(_ sender: UIButton) {
        print("이건가 눌렷습니다")
        
        let todo = Todo(title: messageField.text!)
        delegate?.messageViewController(self, didSaveTodo: todo)
        dismiss(animated: true)
            // 저장하려고 하는 텍스트가 저장되지 않는다
    }
    
}





