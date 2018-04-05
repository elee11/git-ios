//
//  MyOrderTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/7/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var lblServiceNum: UILabel!
    @IBOutlet weak var lblLawerName: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var LblOrderTime: UILabel!
    @IBOutlet weak var imgLawyer: UIImageView!
    @IBOutlet weak var viewBigContainer: UIView!
    @IBOutlet weak var viewsmallContainer: UIView!
    @IBOutlet weak var btn_ChooseLawyer: UIButton!




    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
