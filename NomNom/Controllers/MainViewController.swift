/// ⭐️🙋🏻‍♂️ One of the major problem I was not able to fix - but rewind was all of a sudden, the codes I've written + the boundaries of every func, selectors, class had lost its connection from the Protocol. >>> will have to look into it


//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
            
    let gradientLayer = CAGradientLayer()

    /// 🔥 텍스트가 이쁘게 나오지는 않네 - Font, 길이 제한 (몇 자 정도...), 테두리 한번 보자
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
    
    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("ListUp", for: .normal)
        button.backgroundColor = .black
//        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.cornerRadius = 200/2
        button.heightAnchor.constraint(equalToConstant: 200).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        button.addTarget(self, action: #selector(showTodoButton), for: .touchUpInside)
        return button
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
        
    override func viewDidLoad() {
        super.viewDidLoad()

//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = view.bounds
//        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.3764705882, green: 0.4235294118, blue: 0.5333333333, alpha: 1)).cgColor,
//                                UIColor(#colorLiteral(red: 0.2470588235, green: 0.2980392157, blue: 0.4196078431, alpha: 1)).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradientLayer.shouldRasterize = true    // 🙋🏻‍♂️bitmap으로 변형해야하는 이유가 있는건가?
//        view.layer.insertSublayer(gradientLayer, at: 0) /// 그동안 문제를 일으켰던 이유는 background를 부르는 시점이 너무 느렸다는 점
        
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
        view.addSubview(storageButton)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        storageButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        storageButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5).isActive = true
        storageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        storageButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: 0).isActive = true
        storageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    override func viewWillLayoutSubviews() {  /// 🙋🏻‍♂️still covers the app - why? > called too late?
        //        gradientLayer.removeFromSuperlayer()    /// 🙋🏻‍♂️이거의 의미는 gradient Layer을 화면에서 지우고 다시한번 얹이는건가?
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(#colorLiteral(red: 0.3764705882, green: 0.4235294118, blue: 0.5333333333, alpha: 1)).cgColor,
                                UIColor(#colorLiteral(red: 0.2470588235, green: 0.2980392157, blue: 0.4196078431, alpha: 1)).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0) /// 그동안 문제를 일으켰던 이유는 background를 부르는 시점이 너무 느렸다는 점
    }
    
    
    /// 이것도 실패
//    func setTableViewBackgroundColor(sender: UITableViewController, _ topColor: UIColor, _ bottomColor: UIColor) {
//        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
////        let gradientLocations = [0.0,1.0]
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = gradientBackgroundColors
////        gradientLayer.locations = gradientLocations
//
//        gradientLayer.frame = sender.tableView.bounds
//        let backgroundView = UIView(frame: sender.tableView.bounds)
//        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
//        sender.tableView.backgroundView = backgroundView
//    }
        
    @objc func showTodoButton() {
        print("투두 버튼이 눌렸습니다.")
        let messageVC = storyboard?.instantiateViewController(withIdentifier: "messageVC") as! MessageViewController
        present(messageVC, animated: true)
    }
    
    /// connecting 2nd VC - changed to present entire view
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
    
    @objc func storageButtonTapped() {
        print("저장 버튼이 눌렸습니다.")
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! RetodoTableViewCell    /// ⭐️ 여기서 중요한건 셀을 새롭게 만드는게 아니라 기존에 가지고 있던 셀을 "재활용"함으로써 효율성을 높이는데 차이가 존재한다. The app increases efficiency through recycling their memory and its views
//        let cell = RetodoTableCell()
//        cell.textLabel?.text = todos[indexPath.row].title
        let todo = todos[indexPath.row]
        cell.set(title: todo.title, checked: todo.isCompleted)
        
        // adding gradient behind tableView >>> Cell에 컬러를 적용하는 코드였다.
//        let layer = CAGradientLayer()
//        layer.frame = cell.bounds.insetBy(dx: 4, dy: 4)
//        layer.colors = [UIColor(#colorLiteral(red: 0.3764705882, green: 0.4235294118, blue: 0.5333333333, alpha: 1)).cgColor,
//                        UIColor(#colorLiteral(red: 0.2470588235, green: 0.2980392157, blue: 0.4196078431, alpha: 1)).cgColor]
//        cell.contentView.layer.insertSublayer(layer, at: 0) /// 이게 뭘하는 코드지?
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        /// 1도 일단 모르지만 따라 적는다!
        let action = UIContextualAction(style: .normal, title: "완료") { action, view, complete in
            /// ⭐️leadingAction을 했을 때 -> 텍스트도 반응을 하고 toggle 될 수 있도록 ++ 추후 나는 삭제한 것들은 아래로 내려가게 하고 싶기는 한데 일단!
            let todo = self.todos[indexPath.row].completeToggled()       /// 🙋🏻‍♂️ 이 친구들은 왜 Todo Struct에 접근 권한이 생기는거지?
            self.todos[indexPath.row] = todo
            
            let cell = tableView.cellForRow(at: indexPath) as! RetodoTableViewCell  // 테이블 뷰의 특정 셀, 영역을 의미하고
            cell.set(checked: todo.isCompleted)                                     // 특정 셀의 checkbox 상태를 확인하는 set() 함수에서 todo가 완료 되었다면~ 으로 확인한다. (todo에 접근이 가능 한 이유는 let todo로 바로 위 코드에서 선언을 했기 떄문)
            
            complete(true)  /// 완료되었을 때 행동이기 때문에 여기서는 animation을 적용하는 방향으로 정리가 된 것
            print("완료되었습니다.")
        }
        return UISwipeActionsConfiguration(actions: [action]) // 왜 이렇게 되지?
    }
    
    /// ⭐️ 지우기 위해 사용한 코드라고 생각했는데 - 이건 아니였네
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .destructive, title: "삭제") { action, view, complete in
//            let todo = self.todos[indexPath.row].isCompleted
//
//            complete(true)
//            print("삭제 되었습니다.")
//        }
//        return UISwipeActionsConfiguration(actions: [action])
//    }
  
    /// tableView에 추가 행동을 적용하려고 했는데 - 이럴 경우 대부분 canEdit, editingStyle 등으로 많이 소개를 하고 있었다 - 하지만 더 쉬운 방법이 있는 듯하다! (지금 내 상황에 딱 맞는?)
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            self.tableView.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete  /// 이 메서드에서 리턴하는 수는 하나의 셀에 적용할 수 있는 변경점들이다.
        ///
    }
    
    /// ⭐️ delegate과 datasource 관련해서 사용하는 코드가 다르다. 무엇을 하느냐에 따라 다르게 활용할 것
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {    /// ⭐️ 이 함수를 실행하면 지금 기본으로 제공하고 있는 todo 값들이 삭제된다. 하지만 재생성하면 삭제된 값들도 다시 리턴이 되는데 >> 삭제된 값들을 저장 할 수 있는 공간이 필요해보인다!
        if editingStyle == .delete {
            todos.remove(at: indexPath.row) // 여기는 indexPath.row를 할 때 Array에 담으면 안되네? >> 🙋🏻‍♂️ 등록된 todos에서 하나의 줄을 삭제하는 행위 - 다만 remove(at:) 자체가 Array에서 삭제를 할 때 사용하는 코드이다. 따라서 지금은 이미 Array에 있는 특정한 값, 줄을 삭제할 수 있도록 안내하는 것 ++ [indexPath.row]로 할 수 없는 이유 중 하나는 '값 타입'이기 때문인데 - Int 같이 값을 가지는 데이터들은 원본 위치를 가르키는게 아니라 값을 복사해서 가기 때문에 문제가 발생할 수 있다!! okok~
            tableView.deleteRows(at: [indexPath], with: .automatic)  // 여기는 [indexPath]를 Array 속에 담아야 하는구나...>> deleteRows(at:)는 tableView에서 제공하는 값이기 떄문에 Array로 담아야하는 것 - it's not a given built in action for arrays. Thus we have to point out the entire indexPath.
            /// 이런 코드 같은 경우, 순서를 지켜서 작성하는게 매!우! 중요하다. what tableView should be presenting needs to match with what data is stored? shown?
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)    // 기존에 있던 위치에서 ⭐️🙋🏻‍♂️
        todos.insert(todo, at: destinationIndexPath.row)    // 변경되는 위치로 이동을 시키는 것
    }
}
