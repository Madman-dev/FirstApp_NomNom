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
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var stackVIew: UIStackView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var viewHolder: UIView!
    
    var todo: Todo?
    
    weak var delegate: MessageViewControllerDelegate?
    
    //    var animatedView: UIView!
    //    var animateCallback: (() -> Void)?
    
//    let viewHolder: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 10
//        return view
//    }()
    
    
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
        messageField.text = todo?.title

        
        // 🔥 animation 효과 적용 시도
        //        animatedView = UIView(frame: CGRect(x: 50, y: 180, width: 300, height: 300))
        //        animatedView.backgroundColor = UIColor.red
        //        view.addSubview(animatedView)
        
        //        triggerAnimateCallback()
        
        //        UIView.animate(withDuration: 5, animations: {
        //            self.view.backgroundColor = UIColor.clear
        //        })
        //        container.frame = UIScreen.main.bounds/// 여기에 바운드 효과를 넣는거다..?
//        configure()
        
    }
    
//    func configure() {
        //        view.addSubview(todoField)
        //        view.addSubview(registerButton)
//        view.addSubview(viewHolder)
//        viewHolder.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
//        viewHolder.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
//        viewHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
//        viewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
//        viewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    
    /// 🔥 failed impletmenting a transition of UIView
    //    func triggerAnimateCallback() {
    //        animateCallback?()
    //    }
    
    
    /// dismiss everything outside this position
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.viewHolder //container >> 원래
        { self.dismiss(animated: true)}
    }
    
    // every time the button is clicked, it creates new todo and send back to the delegate && with this data I can use this to update the cell, create new one or anything else with it >> 버튼을 누르면 사라지기는 하지만 데이터는 업데이트가 되고 있지 않다 >> THIS HAS TO BE DONE ON TABLEVIEW
    @IBAction func save(_ sender: UIButton) {
        let todo = Todo(title: messageField.text!)
        delegate?.messageViewController(self, didSaveTodo: todo)
    }
    
}

