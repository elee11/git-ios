//
//  SettingsTableCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/14/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSepartor: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
