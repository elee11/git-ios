
//
//  LawyerTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/15/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class LawyerTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLawyer: UIImageView!
    @IBOutlet weak var lbl_mowatheqName: UILabel!
    @IBOutlet weak var lbl_mowatheqRate: UILabel!
    @IBOutlet weak var btnFawd: TransitionButton!




    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
