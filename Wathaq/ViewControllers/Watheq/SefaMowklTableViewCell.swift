//
//  SefaMowklTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/31/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit

class SefaMowklTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainerMowklTextFields: UIView!
        {
        didSet {
            viewContainerMowklTextFields.applyDimviewBorderProperties()
        }
    }
    @IBOutlet weak var txtSefaMowkl: UITextField!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}

extension UIView {
    func applyactivViewBorderProperties() {
        layer.borderWidth = 1.0
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 6.0
    }
    
    func applyDimviewBorderProperties() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.manatee1.cgColor
        layer.cornerRadius = 6.0
    }
}


