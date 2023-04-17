/// ⭐️🙋🏻‍♂️ One of the major problem I was not able to fix - but rewind was all of a sudden, the codes I've written + the boundaries of every func, selectors, class had lost its connection from the Protocol. >>> will have to look into it

//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit


class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonStack: UIStackView!
    
    var myButtons: [String] = []
    let gradientLayer = CAGradientLayer()
    let presenter = Presenter()
    
    var todos = [
        Todo(title: "Testing cell"),
        Todo(title: "leaing out a point from behind?")
    ]
    
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
    
    
    private let todoButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .red
        bt.setTitle("Press Here", for: .normal)
        bt.frame.size = CGSize(width: 100, height: 40)
        bt.layer.cornerRadius = bt.frame.height/2
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(TodoButtonTapped), for: .touchUpInside)
        return bt
    }()

    
    private let storageButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(systemName: "tray"), for: .normal)
        bt.backgroundColor = .white
        bt.frame.size = CGSize(width: 250, height: 40)
        bt.layer.cornerRadius = bt.frame.height/2
        bt.clipsToBounds = true
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(storageButtonTapped), for: .touchUpInside)
        return bt
    }()


    // 👀 message >> 이건 어떤 코드? >> connecting the tableViewCell to the 2nd VC messageField ⭐️⭐️⭐️⭐️
    @IBSegueAction func todoViewController(_ coder: NSCoder) -> MessageViewController? {
        let vc = MessageViewController(coder: coder)

        if let indexPath = tableView.indexPathForSelectedRow {
            let todo = todos[indexPath.row]
            vc?.todo = todo
            vc?.presentationController?.delegate = self  // to make selected row not be noticed as to modify >> ...?? if canceled
        }
        vc?.delegate = self
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        configure()
        
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
    }
    
    func configure() {
        let stack = UIStackView(arrangedSubviews: [todayLabel, monthlyLabel])   /// stack 구성은 화면에 올려져야 하기에 property 선언에 함께 되면 X, init or viewDidLoad 형식
        stack.spacing = 10
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        storageButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        buttonStack.addArrangedSubview(todoButton)
        buttonStack.addArrangedSubview(storageButton)
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        buttonStack.alignment = .center
        buttonStack.axis = .vertical
        

        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        todoButton.leftAnchor.constraint(equalTo: buttonStack.leftAnchor).isActive = true
        todoButton.rightAnchor.constraint(equalTo: buttonStack.rightAnchor).isActive = true
        
        storageButton.rightAnchor.constraint(equalTo: buttonStack.rightAnchor).isActive = true
        storageButton.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor).isActive = true
    }
    
    override func viewWillLayoutSubviews() {  /// 🙋🏻‍♂️still covers the app - why? > called too late?
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.1294117647, green: 0.1450980392, blue: 0.1607843137, alpha: 1)).cgColor,
                                UIColor(#colorLiteral(red: 0.2862745098, green: 0.3137254902, blue: 0.3411764706, alpha: 1)).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        view.layer.insertSublayer(gradientLayer, at: 0) /// 그동안 문제를 일으켰던 이유는 background를 부르는 시점이 너무 느렸다는 점
    }
    
    @objc func TodoButtonTapped(_ sender: UIButton) {
        print("투두 버튼이 눌렸습니다.")
        presenter.present(MessageViewController(), from: self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.createOverlay()
//         }
    }
    
    @objc func storageButtonTapped() {
        print("저장 버튼이 눌렸습니다.")
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        cell.set(title: todo.title, checked: todo.isCompleted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "완료") { action, view, complete in
            let todo = self.todos[indexPath.row].completeToggled()
            self.todos[indexPath.row] = todo
            
            let cell = tableView.cellForRow(at: indexPath) as! TodoTableViewCell
            cell.set(checked: todo.isCompleted)
            complete(true)
            print("완료되었습니다.")
        }
        return UISwipeActionsConfiguration(actions: [action]) // 왜 이렇게 되지?
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete  /// 이 메서드에서 리턴하는 수는 하나의 셀에 적용할 수 있는 변경점들이다.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)    // 기존에 있던 위치에서 ⭐️🙋🏻‍♂️
        todos.insert(todo, at: destinationIndexPath.row)    // 변경되는 위치로 이동을 시키는 것
    }
}

/// ⭐️ 여기서 데이터 업데이트를 다루고 있다!! ⭐️
extension MainViewController: MessageViewControllerDelegate {
    func messageViewController(_ vc: MessageViewController, didSaveTodo todo: Todo) {
        dismiss(animated: true) {    // Not dismissed automatically - thus need to do manually
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // update!! 🔥
                self.todos[indexPath.row] = todo // 여기에서 todo를 스코프 내에 찾지 못하는 문제가 있었는데 - parameter을 제대로 확인하지 않아서 발생한 문제
                self.tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                // create new!!
                self.todos.append(todo)
                self.tableView.insertRows(at: [IndexPath(row: self.todos.count-1, section: 0)], with: .automatic)
            }
        }
     }
}

extension MainViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
