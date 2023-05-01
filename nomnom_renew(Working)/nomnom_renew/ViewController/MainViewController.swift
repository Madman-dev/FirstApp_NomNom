/// ⭐️🙋🏻‍♂️ One of the major problem I was not able to fix - but rewind was all of a sudden, the codes I've written + the boundaries of every func, selectors, class had lost its connection from the Protocol. >>> will have to look into it

//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //    let gradientLayer = CAGradientLayer()
    let presenter = Presenter()
    var section = [Section]()
    var todo = [Todo]()
    
    var todos = [
        Todo(title: "Testing cell"),
        Todo(title: "leaping out a point from behind?"),
        Todo(title: "값 저장이 왜 안될까?")
    ]
    
    /// Todo 속에서 이미 checked로 구분할 수 있을 줄 알았는데 - 이 방식이 더 좋은 건가? 🙋🏻‍♂️
    //    var sectionData: [Section] = [
    //        .complete,
    //        .incomplete
    //    ]
    
    private let todoButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .systemPink
        bt.setTitle("NOM", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
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
        bt.layer.borderWidth = 0.2
        bt.layer.borderColor = UIColor.gray.cgColor
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
        view.backgroundColor = .white
        
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
        dateLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count   // 🙋🏻‍♂️ enum으로 만들었는데 모든 값을 계산해야하니까?
    }
    
    /// 이 부분은 section 별로 제목을 붙여주는 거고
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch Section(rawValue: section) {
        case .complete:
            return "완료"
        case .incomplete:
            return "미완료"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // section 별로 구분할 수 있도록 정리 - complete && incomplete
//        switch Section(rawValue: section) {  /// 🙋🏻‍♂️이건 왜...?
//        case .complete:
//            return completeTodo.count
//        case .incomplete:
//            return incompleteTodo.count
//        case .none:     /// case .default가 아니어도 되네?
//            return 0
//        }
        return todos.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// 🙋🏻‍♂️ 이전에 지정한 cell이 필요한 이유는 checked cell을 사용하기 위해서 >>>> 다시 보니까 굳이 명칭을 이렇게 하지 않아도 되긴하네..?
//        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! TodoTableViewCell
//        let todo: Todo
//
//        switch Section(rawValue: indexPath.section) {
//        case .complete:
//            todo = completeTodo[indexPath.row]
//        case .incomplete:
//            todo = incompleteTodo[indexPath.row]
//        case .none:
//            fatalError("No section is needed")
//        }
//
//        cell.titleLabel.text = todo.title
//        cell.checkBox.checked = todo.isCompleted
//        return cell
        
        /// ⏲️ 이전 방식으로 잠시 돌아오는걸로~
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        let todo = todos[indexPath.row]
        cell.set(title: todo.title, checked: todo.isCompleted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { action, view, complete in
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
    
    //    🔥 지금은 reordering을 적용하지 않을 것이기 때문에 제외
    //    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    //        let todo = todos.remove(at: sourceIndexPath.row)    // 기존에 있던 위치에서 ⭐️🙋🏻‍♂️
    //        todos.insert(todo, at: destinationIndexPath.row)    // 변경되는 위치로 이동을 시키는 것
    //    }
}

/// ⭐️ 여기서 데이터 업데이트를 다루고 있다!! ⭐️
extension MainViewController: MessageViewControllerDelegate {
    
    ///custom Transition 적용하기 위한 코드 적용된 상황
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let messageVC = MessageViewController()
        messageVC.delegate = self
        messageVC.todo = todo
        messageVC.modalPresentationStyle = .custom
        messageVC.transitioningDelegate = self
        presenter.present(messageVC, from: self)
    }
    
    func messageViewController(_ vc: MessageViewController, didSaveTodo todo: Todo) {
        
        /// 정확하게 이 코드는 custom transition으로 띄운 textField에 값을 넣으면 대입하는 걸로 기억해... 근데 나는 넣을 뿐만 아니라 코드를 불러야한단 말이지?
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
    /// 그래서 여기서 완료 미 완료를 확인하고 옮기는 걸로 적용해보는 걸로
    func toggleComplete(for task: Todo) {
        if task.isCompleted {
            if let index = incompleteTodo.firstIndex(of: task) {
                incompleteTodo.remove(at: index)
                completeTodo.append(task)
            }
        } else {
            if let index = completeTodo.firstIndex(of: task) {
                completeTodo.remove(at: index)
                incompleteTodo.append(task)
            }
        }
        tableView.reloadData()
    }
}

extension MainViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
