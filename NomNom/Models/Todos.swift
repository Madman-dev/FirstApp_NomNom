//
//  Todos.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/06.
//

import UIKit

struct Todo {
    let title: String
    let isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
    
    func completeToggled() -> Todo {
        return Todo(title: title, isCompleted: !isCompleted)
    }
}

//
//class CheckBox: UIView {
//    private weak var imageView: UIImageView!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setup() {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(imageView)
//        
//        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        
//        imageView.image = UIImage(systemName: "checkmark.square.fill")
//        imageView.contentMode = .scaleAspectFit
//        
//        self.imageView = imageView  /// assigning it to the property through private weak var
//        
//        backgroundColor = .clear
//    }
//}
