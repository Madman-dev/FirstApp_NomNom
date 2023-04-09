/// ⭐️🙋🏻‍♂️ One of the major problem I was not able to fix - but rewind was all of a sudden, the codes I've written + the boundaries of every func, selectors, class had lost its connection from the Protocol. >>> will have to look into it


//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    /// 🔥 텍스트가 이쁘게 나오지는 않네 - Font, 길이 제한 (몇 자 정도...), 테두리 한번 보자
    let todos = [
        Todo(title: "이렇게"),
        Todo(title: "하면 될까?"),
        Todo(title: "문제없이 출력 제발")
    ]
     
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let monthlyLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("ListUp", for: .normal)
        button.backgroundColor = .purple
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        button.heightAnchor.constraint(equalToConstant: 200).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        button.addTarget(self, action: #selector(showTodoButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        configureBackground()
        configure()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true


    }
    
    func configure() {
        let stack = UIStackView(arrangedSubviews: [todayLabel, monthlyLabel])   /// stack 구성은 화면에 올려져야 하기에 property 선언에 함께 되면 X, init or viewDidLoad 형식
        stack.spacing = 10
        stack.axis = .horizontal
        
        view.addSubview(stack)
        view.addSubview(addButton)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.layer.cornerRadius = 200 / 2
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
        
    @objc func showTodoButton() {
        print("button Clicked")
        let messageVC = storyboard?.instantiateViewController(withIdentifier: "messageVC") as! MessageViewController
        present(messageVC, animated: true)
    }
    
//    @objc func addButtonTapped(_ sender: UIButton) {
//        print("버튼이 눌렸습니다")
//        let messageVC = storyboard?.instantiateViewController(withIdentifier: "messageVC") as! MessageViewController
//        present(messageVC, animated: true)
////        let controller = MessageViewController()
////        controller.delegate = self
////        let nav = UINavigationController(rootViewController: controller)
////        nav.modalPresentationStyle = .fullScreen
////        present(nav)
//
//    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! RetodoTableCell
//        let cell = RetodoTableCell()
//        cell.textLabel?.text = todos[indexPath.row].title
        let todo = todos[indexPath.row]
        cell.set(title: todo.title, checked: todo.isCompleted)
        return cell
    }
    
    
}
