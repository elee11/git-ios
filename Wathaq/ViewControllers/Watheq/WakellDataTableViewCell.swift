//
//  WakellDataTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 2/1/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit

class WakellDataTableViewCell: UITableViewCell {
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCivilRegistry: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
