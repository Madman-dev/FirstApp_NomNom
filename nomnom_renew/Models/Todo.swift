//
//  Todos.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

enum Section: Int, CaseIterable {
    case complete = 0,
         incomplete
}

struct Todo: Equatable, Encodable, Decodable {
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func completeToggled() -> Todo {
        return Todo(title: title, isCompleted: !isCompleted)
    }
}
