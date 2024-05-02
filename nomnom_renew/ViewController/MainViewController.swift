//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit
import SpriteKit
import breakOutFramework

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let defaults = UserDefaults.standard
    let presenter = Presenter()
    var newGame: GameScene!
    let messageVC = MessageViewController()
    
    var todos: [Todo] = [
        Todo(title: "저장된 투두는 밤 11시 59분에 리셋됩니다.", isCompleted: false),
        Todo(title: "오늘 완료할 투두를 24자 이내로 작성하세요!", isCompleted: false),
        Todo(title: "투두를 완료할수록 놀이도 더 커집니다!", isCompleted: false)
    ]
    
    var totalCount: Int {
        return todos.count
    }
    
    public var completedTodos: Int {
        return todos.filter({ $0.isCompleted }).count
    }
    
    private let todoButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = .systemPink
        bt.setTitle("NOM", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        bt.frame.size = CGSize(width: 250, height: 40)
        bt.layer.cornerRadius = bt.frame.height/2
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(todoButtonTapped), for: .touchUpInside)
        bt.addTarget(self, action: #selector(animateButton), for: .touchUpInside)
        return bt
    }()
    
    private let resetButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = .white
        bt.layer.borderWidth = 0.2
        bt.layer.borderColor = UIColor.gray.cgColor
        bt.frame.size = CGSize(width: 100, height: 40)
        bt.layer.cornerRadius = bt.frame.height/2
        bt.clipsToBounds = true
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        bt.addTarget(self, action: #selector(animateButton), for: .touchUpInside)
        return bt
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.frame.size = CGSize(width: 250, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemPink
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    
    @IBSegueAction func todoViewController(_ coder: NSCoder) -> MessageViewController? {
        let vc = MessageViewController(coder: coder)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let todo = todos[indexPath.row]
            vc?.todo = todo
            vc?.presentationController?.delegate = self
        }
        vc?.delegate = self
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        view.backgroundColor = .white
        
        loadTodos()
        configureView()
        dateCalculator()
        scheduleReset()
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
    
    func configureView() {
        buttonStack.addArrangedSubview(resetButton)
        buttonStack.addArrangedSubview(todoButton)
        view.addSubview(countLabel)
        buttonStack.distribution = .fillProportionally
        buttonStack.spacing = 10
        buttonStack.alignment = .center
        buttonStack.axis = .vertical
        
        todoButton.rightAnchor.constraint(equalTo: buttonStack.rightAnchor).isActive = true
        todoButton.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor).isActive = true
        
        resetButton.leftAnchor.constraint(equalTo: buttonStack.leftAnchor).isActive = true
        resetButton.rightAnchor.constraint(equalTo: buttonStack.rightAnchor).isActive = true
        
        countLabel.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor).isActive = true
    }
    
    @objc func todoButtonTapped(_ sender: UIButton) {
        print(description)
        print("투두 화면이 보입니다")
        messageVC.delegate = self
        
        self.animateButton(sender)
        presenter.present(messageVC, from: self)
    }
    
    @objc func resetButtonTapped() {
        print("리셋 버튼이 눌렸습니다")
        
        defaults.set(completedTodos, forKey: "NumberOfBricks")
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
    
    func saveTodos() {
        do {
            let data = try JSONEncoder().encode(todos)
            defaults.set(data, forKey: "todos")
            defaults.synchronize()
        } catch {
            print("에러가 발생했습니다 \(error)")
        }
    }
    
    func loadTodos() {
        if let savedTodos = defaults.object(forKey: "todos") as? Data {
            let decoder = JSONDecoder()
            if let decodedTodos = try?decoder.decode([Todo].self, from: savedTodos) {
                todos = decodedTodos
            }
        }
    }
    
    @objc func resetTodos() {
        defaults.removeObject(forKey: "todos")
        defaults.synchronize()
    }
    
    func scheduleReset() {
        let calender = Calendar(identifier: .gregorian)
        let now = Date()
        let todayAtMidnight = calender.startOfDay(for: now)
        let resetDate = calender.date(byAdding: .day, value: 1, to: todayAtMidnight)!
        let resetTime = calender.date(bySettingHour: 21, minute: 00, second: 00, of: resetDate)!
        
        let timer = Timer(fireAt: resetTime, interval: 0, target: self, selector: #selector(resetTodos), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
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
        countLabel.text = "\(completedTodos)"
        saveTodos()
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        cell.delegate = self
        let todos = todos[indexPath.row]
        cell.set(title: todos.title, checked: todos.isCompleted)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { action, view, complete in
            let todos = self.todos[indexPath.row].completeToggled()
            self.todos[indexPath.row] = todos
            
            let cell = tableView.cellForRow(at: indexPath) as! TodoTableViewCell
            cell.set(checked: todos.isCompleted)
            complete(true)
            print("완료되었습니다.")
        }
        saveTodos()
        return UISwipeActionsConfiguration(actions: [action]) // 왜 이렇게 되지?
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        saveTodos()
    }
}

extension MainViewController: MessageViewControllerDelegate {
    
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
        dismiss(animated: true) {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.todos[indexPath.row] = todo
                self.tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                self.todos.append(todo)
                self.tableView.insertRows(at: [IndexPath(row: self.todos.count-1, section: 0)], with: .automatic)
            }
            self.saveTodos()
        }
    }
}

extension MainViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView .deselectRow(at: indexPath, animated: true)
        }
    }
}
