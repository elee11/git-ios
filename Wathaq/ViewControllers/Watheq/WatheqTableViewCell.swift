//
//  WatheqTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/6/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class WatheqTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCatName: UILabel!
    @IBOutlet weak var lblCatDesc: UILabel!
    @IBOutlet weak var imgCatIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
