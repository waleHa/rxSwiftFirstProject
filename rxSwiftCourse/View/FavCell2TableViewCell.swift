//
//  FavCell2TableViewCell.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-04-04.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

class FavCell2TableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textfield.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.endEditing(true)
        return true
    }
    @IBAction func commentsTextfieldPressed(_ sender: UITextField) {
        textfield.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
