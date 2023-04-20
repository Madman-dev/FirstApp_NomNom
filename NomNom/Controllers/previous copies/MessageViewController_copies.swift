////
////  MessageViewController.swift
////  NomNom
////
////  Created by Jack Lee on 2023/04/08.
////
//
//import UIKit
//
//protocol MessageViewControllerDelegate: AnyObject {
//    func messageViewController(_ vc: MessageViewController, didSaveTodo: Todo)
//}
//
//class MessageViewController: UIViewController {
//
////    @IBOutlet weak var messageView: UIView!
////    @IBOutlet weak var messageField: UITextField!
//    
//    @IBOutlet weak var myButton: UIButton!
//    
//    
//    weak var delegate: MessageViewControllerDelegate?
//    var todo: Todo?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .green
//        
//        print("여기까지 열림")
//        myButton.backgroundColor = .white
//        print("여기까지 열림2")
//
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
////        messageView.backgroundColor = .white
////        messageView.layer.cornerRadius = 180/2
////        messageView.clipsToBounds = true
//        
//        messageView.translatesAutoresizingMaskIntoConstraints = false
//        messageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//        messageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
//        messageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//    
//    
//    /// dismiss everything outside this position
////    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        let touch = touches.first
////        if touch?.view != self.sendButton //container >> 원래
////        { self.dismiss(animated: true)}
////    }
//
////    @IBAction func save(_ sender: UIButton) {
////        print("되돌아가기 버튼이 눌렸습니다.")
////        let todo = Todo(title: messageField.text!)
////        delegate?.messageViewController(self, didSaveTodo: todo)
////        dismiss(animated: true)
////    }
//    
////    @objc func save(_ sender: UIButton) {
////    }
//}
//
