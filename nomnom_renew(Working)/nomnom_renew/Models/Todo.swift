//
//  Todos.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

let mainVC = MainViewController()

struct Todo: Equatable {
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
    
    /// leadingAction을 적용하기 위해 만든 코드 >> isCompleted false if done >> 왜지?? 🙋🏻‍♂️ - completeToggled 함수는 새로운 Todo를 찍어내는데, isCompleted는 눌리지 않은 상태로 뽑아내는 것이라고 한다.
    func completeToggled() -> Todo {
        return Todo(title: title, isCompleted: !isCompleted)
    }
}

/// 타입으로 지정을 해야하는구나... - todo를 만들기 좋은 구성이 enum일줄은 몰랐네
enum Section: Int, CaseIterable {
    case complete = 0, incomplete
}

var completedTodos = mainVC.todos.filter{$0.isCompleted}
var completeCounts = String(completedTodos.count)

//var completedTodo: [Todo] = []
//var incompletedTodo: [Todo] = []


