////
////  TodoTableViewCell.swift
////  NomNom
////
////  Created by Jack Lee on 2023/04/09.
////
//
//import UIKit
//
//protocol TodoTableViewCellDelegate: AnyObject {
//    func buttonTapped(_ cell: TodoTableViewCell, didChangeCheckedState checked: Bool)
//}
//
//class TodoTableViewCell: UITableViewCell {
//   weak var cellDelegate: TodoTableViewCellDelegate? /// weak을 한 이유가 뭘까?
//    
//    var cellLabel: UILabel!
////    var checkBox: CheckBox!
////    var checkBox: To!
//    
////    private var label: UILabel = {
////        let label = UILabel()
////        label.textColor = .red
////        label.font = UIFont.systemFont(ofSize: 14)
////        return label
////    }()
//    
//    private var checkBox: UIControl = {
//        let bt = UIControl()
//        bt.setDimensions(height: 25, width: 25)
//        bt.backgroundColor = .white
//        bt.layer.borderColor = UIColor.gray.cgColor
//        bt.layer.borderWidth = 1.0
////        bt.contentMode = .scaleAspectFit /// maintains the size of box (not stretchy)
//        bt.layer.cornerRadius = 6
//        bt.clipsToBounds = true
//        return bt
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.checkBox.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside) /// if this is placed within when creating the button, it won't work - the delegate pattern won't recognize the addTarget >> init에서 정리를 해야한다.
//        
/////        cellLabel = UILabel(frame: CGRectMake(-100, 30, 200, 40))   /// 위치 잡기
////        cellLabel.text = "겹치나?" >> NO
////        cellLabel.textColor = .black    // if this works, I'll set the font Size
//        
////        self.addSubview(checkBox) /// 여기서 어떤 차이점이 발생하는 거지?
////        self.contentView.addSubview(cellLabel)
//        self.contentView.addSubview(checkBox)
//        checkBox.translatesAutoresizingMaskIntoConstraints = false
////        checkBox.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
//        checkBox.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15).isActive = true
//        checkBox.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    @objc func buttonTapped() {
////        cellDelegate?.buttonTapped(self, didChangeCheckedState: checkBox.checked)
//        print("클릭 여부 확인")
//    }
////
////    func checked(_ sender: UIButton) {
////        updateChecked()
////    }
////
////    private func updateChecked() {
//////        let attributedString = NSMutableAttributedString(string: cellLabel.text!)
////
////
////    }
//}
