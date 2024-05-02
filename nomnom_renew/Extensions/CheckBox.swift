//
//  CheckBox.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

@IBDesignable
class Checkbox: UIControl {
    
    private weak var imageView: UIImageView!
    
    private var image: UIImage {
        return checked ? UIImage(systemName: "checkmark.circle.fill")! : UIImage(systemName: "circle")!
    }
    
    /// @IBInspectable은 무엇을 하는 코드인가?
    @IBInspectable
    public var checked: Bool = false {    // why make it public? >> able to put in package? hm...
        didSet {
            imageView.image = image // able to reset image according to whether if it is checked or not
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        
        backgroundColor = UIColor.clear
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc func touchUpInside() {    /// 🙋🏻‍♂️ 여기가 어떻게 작동하는지 확인 필요
        print("clicked")
        checked = !checked
        sendActions(for: .valueChanged)
    }
}
