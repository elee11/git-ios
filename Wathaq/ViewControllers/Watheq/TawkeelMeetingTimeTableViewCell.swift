//
//  TawkeelMeetingTimeTableViewCell.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 2/1/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import BetterSegmentedControl


class TawkeelMeetingTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var SegmentControl: BetterSegmentedControl!



    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    func adjustSegmentControl ()
    {
        SegmentControl.titles = [NSLocalizedString("1Hour", comment: ""), NSLocalizedString("2Hours", comment: ""),NSLocalizedString("3Hours", comment: "")]
        SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
        SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            
        }
        else if sender.index == 1  {
            
        }
        else
        {
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
