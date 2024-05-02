//
//  TodosTableViewCell.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func todoTableViewCell(_ cell: TodoTableViewCell, didChangeCheckedState checked: Bool)
}

class TodoTableViewCell: UITableViewCell {
    weak var delegate: TodoTableViewCellDelegate?
    let mainVC = MainViewController()
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: Checkbox!
    
    @IBAction func checked(_ sender: Checkbox) {
        updateChecked()
        delegate?.todoTableViewCell(self, didChangeCheckedState: checkBox.checked)
    }
    
    func set(title: String, checked: Bool) {
        titleLabel.text = title
        checkBox.checked = checked
        titleLabel.backgroundColor = .clear
        updateChecked()
    }
    
    func set(checked: Bool) {
        checkBox.checked = checked
        updateChecked()
    }
    
    private func updateChecked() {
        let attributedString = NSMutableAttributedString(string: titleLabel.text!)
        
        if checkBox.checked {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
        }
        titleLabel.attributedText = attributedString
    }
}
