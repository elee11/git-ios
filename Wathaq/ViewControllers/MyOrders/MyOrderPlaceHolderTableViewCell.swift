//
//  MyOrderPlaceHolderTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/7/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import Skeleton


class MyOrderPlaceHolderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblServiceNum: GradientContainerView!
    @IBOutlet weak var lblServiceNum1: GradientContainerView!
    @IBOutlet weak var lblLawerName: GradientContainerView!
    @IBOutlet weak var lblOrderStatus: GradientContainerView!
    @IBOutlet weak var LblOrderTime: GradientContainerView!
    @IBOutlet weak var imgLawyer: UIView!



    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension MyOrderPlaceHolderTableViewCell: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [lblServiceNum.gradientLayer, lblServiceNum1.gradientLayer,lblOrderStatus.gradientLayer, LblOrderTime.gradientLayer]
    }
}

