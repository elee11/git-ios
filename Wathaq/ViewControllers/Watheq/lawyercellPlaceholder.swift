//
//  lawyercellPlaceholder.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/7/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import Skeleton


class lawyercellPlaceholder: UITableViewCell {

    @IBOutlet weak var lblServiceNum: GradientContainerView!
    @IBOutlet weak var lblLawerName: GradientContainerView!
    @IBOutlet weak var lblOrderStatus: GradientContainerView!
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

extension lawyercellPlaceholder: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [lblServiceNum.gradientLayer,lblOrderStatus.gradientLayer]
    }
}
