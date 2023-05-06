/// ⭐️🙋🏻‍♂️ One of the major problem I was not able to fix - but rewind was all of a sudden, the codes I've written + the boundaries of every func, selectors, class had lost its connection from the Protocol. >>> will have to look into it

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
    
    //    let gradientLayer = CAGradientLayer()
    let defaults = UserDefaults.standard
    let presenter = Presenter()
    let messageVC = MessageViewController()
    
    /// creating sample todos
    var todos: [Todo] = [
        Todo(title: "저장된 투두는 밤 11시 59분에 리셋됩니다.", isCompleted: false),
        Todo(title: "오늘 완료할 투두를 24자 이내로 작성하세요!", isCompleted: false),
        Todo(title: "투두를 완료할수록 놀이도 더 커집니다!", isCompleted: false)
    ]

//    struct Keys {
//        static let todoName = "todoName"
//    }
    
    var totalCount: Int {
        return todos.count
    }
    
    public var completedTodos: Int {
        return todos.filter({ $0.isCompleted }).count
    }
    
    /// Todo 속에서 이미 checked로 구분할 수 있을 줄 알았는데 - 이 방식이 더 좋은 건가? 🙋🏻‍♂️ >> Section으로 구분하는건 포기
    //    var sectionData: [Section] = [
    //        .complete,
    //        .incomplete
    //    ]
    
    private let todoButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .systemPink
        bt.setTitle("NOM", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        bt.frame.size = CGSize(width: 250, height: 40)
        bt.layer.cornerRadius = bt.frame.height/2
        bt.clipsToBounds = true
        bt.addTarget(self, action: #selector(todoButtonTapped), for: .touchUpInside)
        bt.addTarget(self, action: #selector(animateButton), for: .touchUpInside)   // 버튼 튕김 효과
        return bt
    }()
    
    private let storageButton: UIButton = {
        let bt = UIButton(type: .custom)
        bt.backgroundColor = .white
        bt.layer.borderWidth = 0.2
        bt.layer.borderColor = UIColor.gray.cgColor
        bt.frame.size = CGSize(width: 100, height: 40)
        bt.layer.cornerRadius = bt.frame.height/2
        bt.clipsToBounds = true
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.addTarget(self, action: #selector(storageButtonTapped), for: .touchUpInside)
        bt.addTarget(self, action: #selector(animateButton), for: .touchUpInside)
        return bt
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.frame.size = CGSize(width: 250, height: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemPink
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        return label
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
        loadTodos()
        
//        trackLabel.text = "\(completedTodos)"

        configureView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
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
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        storageButton.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.addArrangedSubview(storageButton)
        buttonStack.addArrangedSubview(todoButton)
        view.addSubview(trackLabel)
        buttonStack.distribution = .fillProportionally
        buttonStack.spacing = 10
        buttonStack.alignment = .center
        buttonStack.axis = .vertical
        
        todoButton.rightAnchor.constraint(equalTo: buttonStack.rightAnchor).isActive = true
        todoButton.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor).isActive = true
        
        storageButton.leftAnchor.constraint(equalTo: buttonStack.leftAnchor).isActive = true
        storageButton.rightAnchor.constraint(equalTo: buttonStack.rightAnchor).isActive = true
        
        trackLabel.centerXAnchor.constraint(equalTo: storageButton.centerXAnchor).isActive = true
        trackLabel.centerYAnchor.constraint(equalTo: storageButton.centerYAnchor).isActive = true
    }
    
    @objc func todoButtonTapped(_ sender: UIButton) {
        print("2nd VC 출력")
        /// ⭐️ 이 부분이 있기 때문에 todo 버튼을 누르고 다음 화면으로 넘어갔을 때 데이터를 전달 받을 수 있는건가 ⭐️ >> YES!
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
    
    /// 새로운 todo를 저장하는 메서드
    func saveTodos() {
//        defaults.set(messageVC.messageField.text!, forKey: Keys.todoName)
//        defaults.set(todos, forKey: "todos")    // 🙋🏻‍♂️ 이방식으로도 저장은 불가능 -> 내가 저장하려고 하는 타입이 Todo 타입이기 때문에 UserDefault에서 건드릴 수 있는 범위를 벗어난 것이라고 한다. String, Int, Array, Date 등이 저장되어야 한다고~

        //        let encoder = JSONEncoder()
//        if let encodedTodos = try?encoder.encode(todos) {
//            defaults.set(encodedTodos, forKey: "todos")
//            defaults.synchronize()
//        }
        
        do {
            let data = try JSONEncoder().encode(todos)
            defaults.set(data, forKey: "todos")
            defaults.synchronize()
        } catch {
            print("에러가 발생했습니다 \(error)")
        }
    }
    
    /// 저장된 todo를 불러오는 방식 - using Decoder since Todo is NOT a type of String, a custom type
    func loadTodos() {
        if let savedTodos = defaults.object(forKey: "todos") as? Data {
            let decoder = JSONDecoder()
            if let decodedTodos = try?decoder.decode([Todo].self, from: savedTodos) {
                todos = decodedTodos
            }
//        if let savedTodos = UserDefaults.standard.array(forKey: "todos") as? [Todo] {
//            todos = savedTodos
            /// 2nd VC에 이렇게 접근하는 방식 자체가 잘못된 것
            //        let todo = defaults.value(forKey: Keys.todoName) as? String ?? ""
            //        messageVC.messageField.text = todo
        }
    }
    
    @objc func resetTodos() {
        defaults.removeObject(forKey: "todos")
        defaults.synchronize()
    }
    
    func scheduleReset() {
        let calender = Calendar(identifier: .gregorian)
        let now = Date()
        let todayAtMidnight = calender.startOfDay(for: now) /// 정확한가?
        let resetDate = calender.date(byAdding: .day, value: 1, to: todayAtMidnight)!
        let resetTime = calender.date(bySettingHour: 21, minute: 00, second: 00, of: resetDate)!
        
        let timer = Timer(fireAt: resetTime, interval: 0, target: self, selector: #selector(resetTodos), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func updateBricksInGameScene() {
        let gameScene = GameScene(size: UIScreen.main.bounds.size)
        return gameScene.updateCompletedTodos(completedTodos: completedTodos)
    }
        
    //    @IBAction func startEditing(_ sender: Any) {    /// 🙋🏻‍♂️ 이 친구는 어떤 역할을 하는지 한번 더 봐야한다
    //        tableView.isEditing = !tableView.isEditing
    //    }
    
    //    func addNewTodo(_ todo: Todo) {
    //        incompletedTodo.append(todo)
    //    }
    //
    //    func completeTodos(_ todo: Todo) {
    //        if let index = incompletedTodo.firstIndex(of: todo) {
    //            incompletedTodo.remove(at: index)
    //            completedTodo.append(todo)
    //        }
    //    }
    //
    //    func incompleteTodos(_ todo: Todo) {
    //        if let index = completedTodo.firstIndex(of: todo) {
    //            completedTodo.remove(at: index)
    //            incompletedTodo.append(todo)
    //        }
    //    }
}

extension MainViewController: TodoTableViewCellDelegate {
    func todoTableViewCell(_ cell: TodoTableViewCell, didChangeCheckedState checked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let todo = todos[indexPath.row]
        let newTodo = Todo(title: todo.title, isCompleted: checked)
        todos[indexPath.row] = newTodo
        
        trackLabel.text = "\(completedTodos)"
        
        /// 여기에 업데이트 상황을 확인해야하는데 없어서 못하는거였나?
        saveTodos()
    }
     /// 생각했던 것보다 더 복잡하게 운영이 되는 코드... 이건 한번 더 체크 + 적용을 하는게 좋을지 한번 더 확인해보자
//        todos[indexPath.row].isCompleted = checked
//
//        todos.sort { (todo1, todo2) -> Bool in
//            if todo1.isCompleted == todo2.isCompleted { // todo1이 완료되었다면 todo2
//                return todo1.title < todo2.title
//            } else {
//                return !todo1.isCompleted
//            }
//        }
//        tableView.reloadData()
//    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
        
        /// 이 부분은 section 별로 제목을 붙여주는 거고
        //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //
        //        switch Section(rawValue: section) {
        //        case .complete:
        //            return "완료"
        //        case .incomplete:
        //            return "미완료"
        //        default:
        //            return nil
        //        }
        //    }
        
        /// 이 친구는 고정 ⭐️
        //    func numberOfSections(in tableView: UITableView) -> Int {
        ///        return Section.allCases.count   // 🙋🏻‍♂️ enum으로 만들었는데 모든 값을 계산해야하니까?
        //        return 1
        //    }
        
        
        //        // section 별로 구분할 수 있도록 정리 - complete && incomplete
        //        // 여기선 if문을 쓸수가 없네, 이거 아니면 이거 - 형식으로 정리를 하니까 문제가 발생하겠네
        //
        //        /// 대박이다 이부분은
        //        guard let sectionType = Section(rawValue: section) else {
        //            return 0
        //        }
        //
        //        switch sectionType {
        //        case .incomplete:
        //            return incompletedTodo.count
        //        case .complete:
        //            return completedTodo.count
        //        }
        
        //        switch Section(rawValue: section) {  /// 🙋🏻‍♂️이건 왜...?  >>> 한 섹션에 들어가는 줄 수를 말하는거였구나... 그러면 switch문으로 적용을 하는게 좋을 것 같긴하네
        //        case .complete:
        //            return completeTodo.count
        //        case .incomplete:
        //            return incompleteTodo.count
        //        case .none:     /// case .default가 아니어도 되네?
        //            return 0
        //        }
        //        return todos.count  /// 여기에 .count가 들어가는 이유는 각 섹션별로 수치가 다르기 때문에 구분해서
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// ⏲️ 이전 방식으로 잠시 돌아오는걸로~
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! TodoTableViewCell
        cell.delegate = self
        cell.delegate = self
        let todos = todos[indexPath.row]
        cell.set(title: todos.title, checked: todos.isCompleted)
        
        return cell
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
        
        
        /// 이건 왜 있어야하지?
        //        guard let sectionType = Section(rawValue: indexPath.section) else {
        //            return cell
        //        }
        
        //        switch sectionType {
        //        case .incomplete:
        //            let todo = incompletedTodo[indexPath.row]
        ////            cell.set(title: todo.title, checked: !todo.isCompleted)
        ////            cell.configure(with: todo)
        //        case .complete:
        //            let todo = completedTodo[indexPath.row]
        //            cell.set(title: todo.title, checked: todo.isCompleted)
        ////            cell.configure(with: todo)
        //        }
        
        //        let todo = todos[indexPath.row]
        //        cell.set(title: todo.title, checked: todo.isCompleted)
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
        return .delete  /// 이 메서드에서 리턴하는 수는 하나의 셀에 적용할 수 있는 변경점들이다.
    }
    
    /// 이 부분 한번 더 체크
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        saveTodos()
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
                // update!! 🔥 >> custom transition을 사용하면 이게 없어지는거 아닌가? >>> NO
                self.todos[indexPath.row] = todo // 여기에서 todo를 스코프 내에 찾지 못하는 문제가 있었는데 - parameter을 제대로 확인하지 않아서 발생한 문제
                self.tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                // create new!!
                self.todos.append(todo)
                self.tableView.insertRows(at: [IndexPath(row: self.todos.count-1, section: 0)], with: .automatic)
            }
            self.saveTodos()
        }
    }
    /// 그래서 여기서 완료 미 완료를 확인하고 옮기는 걸로 적용해보는 걸로
    //    func toggleComplete(for task: Todo) {
    //        if task.isCompleted {
    //            if let index = incompletedTodo.firstIndex(of: task) {
    //                incompletedTodo.remove(at: index)
    //                completedTodo.append(task)
    //            }
    //        } else {
    //            if let index = completedTodo.firstIndex(of: task) {
    //                completedTodo.remove(at: index)
    //                incompletedTodo.append(task)
    //            }
    //        }
    //        tableView.reloadData()
    //    }
}

extension MainViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView .deselectRow(at: indexPath, animated: true)
        }
    }
}
