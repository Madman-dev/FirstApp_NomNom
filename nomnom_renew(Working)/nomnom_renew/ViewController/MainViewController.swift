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
    @IBOutlet weak var dateLabel: UILabel!

    let gradientLayer = CAGradientLayer()
    let presenter = Presenter()
    
    var todos = [
        Todo(title: "Testing cell"),
        Todo(title: "leaping out a point from behind?"),
        Todo(title: "값 저장이 왜 안될까?")
    ]
    
    private let todoButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .red
        bt.setTitle("Press Here", for: .normal)
        bt.frame.size = CGSize(width: 100, height: 40)
        bt.layer.cornerRadius = bt.frame.height/2
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(TodoButtonTapped), for: .touchUpInside)
        bt.addTarget(self, action: #selector(animateButton), for: .touchUpInside)   // 버튼 튕김 효과
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
        bt.addTarget(self, action: #selector(animateButton), for: .touchUpInside)
        return bt
    }()

    // 👀 message >> 이건 어떤 코드? >> connecting the tableViewCell to the 2nd VC messageField ⭐️⭐️⭐️⭐️
    @IBSegueAction func todoViewController(_ coder: NSCoder) -> MessageViewController? {
        let vc = MessageViewController(coder: coder)

        if let indexPath = tableView.indexPathForSelectedRow {
            let todo = todos[indexPath.row]
            vc?.todo = todo
            vc?.presentationController?.delegate = self // to make selected row not be noticed as to modify >> ...?? if canceled >>>> this code is for when you do not wish have cell maintain touched - after dragged down - in terms of segue
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
        tableView.backgroundColor = .clear
        dateCalculator()
    }
    
    func dateCalculator() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM/dd at h:mm a"
        dateLabel.text = formatter.string(from: date)
    }
    
    
    func configure() {
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        storageButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(todoButton)
        buttonStack.addArrangedSubview(storageButton)
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
        buttonStack.alignment = .center
        buttonStack.axis = .vertical
                
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
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0) /// 그동안 문제를 일으켰던 이유는 background를 부르는 시점이 너무 느렸다는 점
    }
    
    @objc func TodoButtonTapped(_ sender: UIButton) {
        print("투두 버튼이 눌렸습니다.")
        let messageVC = MessageViewController()
        
        /// ⭐️ 이 부분이 있기 때문에 todo 버튼을 누르고 다음 화면으로 넘어갔을 때 데이터를 전달 받을 수 있는건가 ⭐️
        messageVC.delegate = self
        self.animateButton(sender)
        presenter.present(messageVC, from: self)
    }
    
    @objc func storageButtonTapped() {
        print("저장 버튼이 눌렸습니다.")
        
        let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gameVC") as! breakOutViewController
        
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: false) {
                self.present(gameVC, animated: true)
            }
        }
       
        gameVC.modalPresentationStyle = .fullScreen
        
        self.present(gameVC, animated: true)
//        DispatchQueue.main.async {
//            self.getTopMostViewController()?.present(gameVC, animated: true, completion: nil)
//        }
        /// 시간 텀을 두어야 하는걸까?
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let gameVC = breakOutViewController()
//            gameVC.present(gameVC, animated: true)
//        }
        
    }
    
    @objc func animateButton(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)}, completion: nil)
        }
    }
    
    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
}

extension MainViewController: TodoTableViewCellDelegate {
    func todoTableViewCell(_ cell: TodoTableViewCell, didChangeCheckedState checked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let todo = todos[indexPath.row]
        let newTodo = Todo(title: todo.title, isCompleted: checked)
        
        todos[indexPath.row] = newTodo
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
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
    
    ///🔥 지금은 reordering을 적용하지 않을 것이기 때문에 제외
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let todo = todos.remove(at: sourceIndexPath.row)    // 기존에 있던 위치에서 ⭐️🙋🏻‍♂️
//        todos.insert(todo, at: destinationIndexPath.row)    // 변경되는 위치로 이동을 시키는 것
//    }
}

/// ⭐️ 여기서 데이터 업데이트를 다루고 있다!! ⭐️
extension MainViewController: MessageViewControllerDelegate {

    func messageViewController(_ vc: MessageViewController, didSaveTodo todo: Todo) {

        dismiss(animated: true) {    // Not dismissed automatically - thus need to do manually
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // update!! 🔥 >> custom transition을 사용하면 이게 없어지는거 아닌가?
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
