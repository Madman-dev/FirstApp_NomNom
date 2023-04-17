//
//  TodosTableViewCell.swift
//  nomnom_renew
//
//  Created by Jack Lee on 2023/04/17.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: Checkbox!
    
    @IBAction func checked(_ sender: Checkbox) {
        updateChecked()
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
    
    private func updateChecked() {  /// 정확하게 어떤 코드들인지 한번 더 체크
        let attributedString = NSMutableAttributedString(string: titleLabel.text!)
        
        if checkBox.checked {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))    /// -1을 했던 이유는 뭘까? / value는 두께를 말하는거구나 (addAttribute를 통해 원하는 스타일을 추가할 수 있다는 점이 있네... 색깔을 변하게 하는 방법도 알아보자!)
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length))   /// -1을 했던 이유는 뭘까?
        }
        titleLabel.attributedText = attributedString
    }
    
}
