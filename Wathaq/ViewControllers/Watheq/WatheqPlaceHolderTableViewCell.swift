//
//  WatheqPlaceHolderTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/7/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import Skeleton


class WatheqPlaceHolderTableViewCell: UITableViewCell {
    @IBOutlet weak var imagePlaceholderView: UIView!
    @IBOutlet weak var lbl_CatPlaceholderView: GradientContainerView!
    @IBOutlet weak var lbl_Desc1PlaceholderView: GradientContainerView!
    @IBOutlet weak var lbl_Desc2PlaceholderView: GradientContainerView!
    @IBOutlet weak var lbl_Desc3PlaceholderView: GradientContainerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension WatheqPlaceHolderTableViewCell: GradientsOwner {
    var gradientLayers: [CAGradientLayer] {
        return [lbl_CatPlaceholderView.gradientLayer, lbl_Desc1PlaceholderView.gradientLayer,lbl_Desc2PlaceholderView.gradientLayer, lbl_Desc3PlaceholderView.gradientLayer]
    }
}

