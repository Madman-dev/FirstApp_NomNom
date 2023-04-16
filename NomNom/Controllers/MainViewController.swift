/// ⭐️🙋🏻‍♂️ One of the major problem I was not able to fix - but rewind was all of a sudden, the codes I've written + the boundaries of every func, selectors, class had lost its connection from the Protocol. >>> will have to look into it

//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let gradientLayer = CAGradientLayer()
    
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
        bt.frame.size = CGSize(width: 300, height: 300)
        bt.layer.cornerRadius = 200/2
        bt.clipsToBounds = true
//        bt.layer.shadowColor = UIColor.black.cgColor
//        bt.layer.shadowRadius = 8
//        bt.layer.shadowOffset = CGSize(width: 0, height: 0)
        bt.addTarget(self, action: #selector(TodoButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    
    private let storageButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(systemName: "tray"), for: .normal)
        bt.backgroundColor = .white
        bt.layer.cornerRadius = 50/2
        bt.clipsToBounds = true
        bt.layer.shadowRadius = 8
        bt.layer.shadowColor = UIColor.black.cgColor
        bt.layer.shadowOpacity = 0.7
        bt.addTarget(self, action: #selector(storageButtonTapped), for: .touchUpInside)
        return bt
    }()
    
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
//        view.fadeIn(duration: 1)
        return view
    }()

    let presenter = Presenter()

    // 👀 message >> 이건 어떤 코드? >> connecting the tableViewCell to the messageField ⭐️⭐️⭐️⭐️
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
        view.addSubview(storageButton)
        view.addSubview(todoButton)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        storageButton.translatesAutoresizingMaskIntoConstraints = false

        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

        todoButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15).isActive = true
        todoButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        todoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        todoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
                
        storageButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5).isActive = true
        storageButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        storageButton.rightAnchor.constraint(equalTo: todoButton.leftAnchor, constant: 0).isActive = true
        storageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
    }
    
    override func viewWillLayoutSubviews() {  /// 🙋🏻‍♂️still covers the app - why? > called too late?
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.3764705882, green: 0.4235294118, blue: 0.5333333333, alpha: 1)).cgColor,
                                UIColor(#colorLiteral(red: 0.2470588235, green: 0.2980392157, blue: 0.4196078431, alpha: 1)).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! RetodoTableViewCell
        let todo = todos[indexPath.row]
        cell.set(title: todo.title, checked: todo.isCompleted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "완료") { action, view, complete in
            let todo = self.todos[indexPath.row].completeToggled()
            self.todos[indexPath.row] = todo
            
            let cell = tableView.cellForRow(at: indexPath) as! RetodoTableViewCell
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

//public extension UIView {
//    func fadeIn(duration: TimeInterval = 1.0) {
//        UIView.animate(withDuration: duration, animations: {
//            self.alpha = 1.0
//        })
//    }
//
//    func fadeOut(duration: TimeInterval = 1.0) {
//        UIView.animate(withDuration: duration, animations: {
//            self.alpha = 0
//        })
//    }
//}

/// 방식을 바꿔야겠다
/// 위로 올려보내는 느낌 + 테이블 뷰 느낌 변경
///
