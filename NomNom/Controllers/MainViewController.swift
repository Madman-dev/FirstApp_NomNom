/// ⭐️🙋🏻‍♂️ One of the major problem I was not able to fix - but rewind was all of a sudden, the codes I've written + the boundaries of every func, selectors, class had lost its connection from the Protocol. >>> will have to look into it


//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate {
    
    /// 🔥 텍스트가 이쁘게 나오지는 않네 - Font, 길이 제한 (몇 자 정도...), 테두리 한번 보자
    let todos = [
        Todo(title: "내용이 다 작성이 되는 건 이해되는데, 필요한 게...", description: ""),
        Todo(title: "스타벅스 가서 공부하기", description: ""),
        Todo(title: "코딩을 통해 어느정도 기본 어플의 구성은 잡아두기ㅁㅇㄴㄴㅇㅁㄴ", description: ""),
    ]

//    lazy var todoTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .white
//        tableView.layer.cornerRadius = view.frame.width/15
//        tableView.clipsToBounds = true
//        return tableView
//    }()
     
    private let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private let monthlyLabel: UILabel = {
        let label = UILabel()
        label.text = "Monthly"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
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
    
    
//    private var todoTable: UITableView = {    >> 안됨1
//        let tableView = UITableView()
//        tableView.backgroundColor = .gray
//        tableView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        return tableView
//    }()
    
//    private lazy var todoTableView: UITableView = {   >> 안됨2
//        let tableView = UITableView()
//        tableView.backgroundColor = .gray
//        tableView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        return tableView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        tableViewSetup()
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print("테이블뷰를 만들었습니다.")
//    }
    
    func configure() {
        configureBackground()
        print("배경을 만들었습니다.")

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
    
//    func tableViewSetup() {
//        view.addSubview(todoTableView)  /// 테이블 뷰가 보이지 않는다. >> 보인다!!
////        todoTableView.contentMode = .scaleAspectFit /// auto resizing? >> apparently not
//
//        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "cell")    /// programatically creating? >>> 유튜브에 설명을 일단 그대로 작성하면 - it looks at the table in func, asks for if being registered (we do with UITableViewCell), creates indexPath && we create the label?.text with "cell" and return it
//        todoTableView.delegate = self
//        todoTableView.dataSource = self
//
//        todoTableView.translatesAutoresizingMaskIntoConstraints = false
////        todoTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
////        todoTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        todoTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
//        todoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
//        todoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
//        todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive = true
//    }
    
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
    /// i need to populate the tableView... with what??
    /// 1st leave blank
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count  // returns the number of arrays within todos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoTableViewCell
        cell.cellDelegate = self
        cell.textLabel?.text = todos[indexPath.row].title
        cell.backgroundColor = .white
        
//        cellLabel = UILabel(frame: CGRectMake(10, 0, 330, 50))

//        cell.textLabel?.text = self.vm.myTodo[indexPath.row]
        return cell
    }
}

extension MainViewController: TodoTableViewCellDelegate {
    func buttonTapped(_ cell: TodoTableViewCell, didChangeCheckedState checked: Bool) {
        return
    }
}
