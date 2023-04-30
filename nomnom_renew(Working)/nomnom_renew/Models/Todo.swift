//
//  Todos.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

struct Todo {
    let title: String
    let isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
    
    /// leadingAction을 적용하기 위해 만든 코드 >> isCompleted false if done >> 왜지?? 🙋🏻‍♂️ - completeToggled 함수는 새로운 Todo를 찍어내는데, isCompleted는 눌리지 않은 상태로 뽑아내는 것이라고 한다.
    func completeToggled() -> Todo {
        return Todo(title: title, isCompleted: !isCompleted)
    }
}
