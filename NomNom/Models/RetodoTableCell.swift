//
//  RetodoTableCell.swift
//  NomNom
//
//  Created by Jack Lee on 2023/04/09.
//

import UIKit

class RetodoTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkBox: Checkbox!
    
    @IBAction func checked(_ sender: Checkbox) {
    }
    
    func set(title: String, checked: Bool) {
        titleLabel.text = title
        checkBox.checked = checked
        updateChecked()
    }
    
    private func updateChecked() {  /// 정확하게 어떤 코드들인지 한번 더 체크
        let attributedString = NSMutableAttributedString(string: titleLabel.text!)
        
        if checkBox.checked {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        titleLabel.attributedText = attributedString
    }
    
}
