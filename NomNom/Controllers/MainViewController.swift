//
//  MainViewController.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let vm = UITableViewCell()
    
    let todos = [
    Todo(title: "이거면"),
    Todo(title: "될까..?")
    ]
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 날짜"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .brown
        return label
    }()
    
    
    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("더 하자!", for: .normal)
        button.backgroundColor = .purple
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)

        button.heightAnchor.constraint(equalToConstant: 200).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true

        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let mainTableView: UITableViewCell = {
        let tableView = UITableViewCell()
        tableView.backgroundColor = .gray
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        self.mainTableView.delegate = self
//        self.mainTableView.dataSource = self
    }
    
    func configure() {
        view.addSubview(mainTableView)  /// 테이블 뷰가 보이지 않는다. >> 보인다!!
        view.addSubview(addButton)
        view.addSubview(todayLabel)

        addButton.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.layer.cornerRadius = 200 / 2
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mainTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mainTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        todayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        todayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
    
    
    @objc func addButtonTapped() {
        print("버튼이 눌렸습니다")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
//        cell.textLabel?.text = self.vm.myTodo[indexPath.row]
        return cell
    }

}
