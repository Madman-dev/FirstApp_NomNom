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
//    weak var delegate: MessageViewControllerDelegate?
//    var todo: Todo?
//
//    let messageView = UIView()
//    let sendButton = UIButton()
//    let messageField = UITextField()
////    @IBOutlet weak var messageField: UITextField!
////    @IBOutlet weak var stackVIew: UIStackView!
////    @IBOutlet weak var sendButton: UIButton!
////    @IBOutlet weak var viewHolder: UIView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //        messageField.text = todo?.title
////        view.backgroundColor = UIColor.black
//        view.addSubview(messageView)
//        view.addSubview(messageField)
//        view.addSubview(sendButton)
//        
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
//        sendButton.backgroundColor = .blue
//        sendButton.addTarget(self, action: #selector(save), for: .touchUpInside)
//        
//        messageField.translatesAutoresizingMaskIntoConstraints = false
//        messageField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        messageField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
//        messageField.backgroundColor = .green
//
//        
//        // 🔥 animation 효과 적용 시도
//        //        animatedView = UIView(frame: CGRect(x: 50, y: 180, width: 300, height: 300))
//        //        animatedView.backgroundColor = UIColor.red
//        //        view.addSubview(animatedView)
//        
//        //        triggerAnimateCallback()
//        
//        //        UIView.animate(withDuration: 5, animations: {
//        //            self.view.backgroundColor = UIColor.clear
//        //        })
//        //        container.frame = UIScreen.main.bounds/// 여기에 바운드 효과를 넣는거다..?
////        configure()
//        
//    }
//    
//    override func viewDidLayoutSubviews() {
//        messageView.backgroundColor = .white
//        messageView.layer.cornerRadius = view.layer.bounds.width/2
//        messageView.clipsToBounds = true
//        
//        messageView.translatesAutoresizingMaskIntoConstraints = false
//        messageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        messageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        messageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//    
////    func configure() {
//        //        view.addSubview(todoField)
//        //        view.addSubview(registerButton)
////        view.addSubview(viewHolder)
////        viewHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
////        viewHolder.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
////        viewHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
////        viewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
////        viewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
//    
//    /// 🔥 failed impletmenting a transition of UIView
//    //    func triggerAnimateCallback() {
//    //        animateCallback?()
//    //    }
//    
//    
//    /// dismiss everything outside this position
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        if touch?.view != self.sendButton //container >> 원래
//        { self.dismiss(animated: true)}
//    }
//    
//    // every time the button is clicked, it creates new todo and send back to the delegate && with this data I can use this to update the cell, create new one or anything else with it >> 버튼을 누르면 사라지기는 하지만 데이터는 업데이트가 되고 있지 않다 >> THIS HAS TO BE DONE ON TABLEVIEW
//
//    @objc func save(_ sender: UIButton) {
//        print("되돌아가기 버튼이 눌렸습니다.")
//        let todo = Todo(title: messageField.text!)
//        delegate?.messageViewController(self, didSaveTodo: todo)
//        dismiss(animated: true)
//    }
//    
////    @IBAction func save(_ sender: UIButton) {
////        print("되돌아가기 버튼이 눌렸습니다.")
////        let todo = Todo(title: messageField.text!)
////        delegate?.messageViewController(self, didSaveTodo: todo)
////        dismiss(animated: true)
////    }
//}
//
