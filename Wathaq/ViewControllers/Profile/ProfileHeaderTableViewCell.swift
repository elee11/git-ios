//
//  ProfileHeaderTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/7/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNumOfServices: UILabel!
    @IBOutlet weak var lblNumOfConsultation: UILabel!
    @IBOutlet weak var lblTitleNumOfServices: UILabel!
    @IBOutlet weak var lblTitleNumOfConsultation: UILabel!
    @IBOutlet weak var imgUserImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
