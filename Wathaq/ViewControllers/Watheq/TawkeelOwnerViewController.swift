//
//  TawkeelOwnerViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/11/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class TawkeelOwnerViewController: UIViewController {
    @IBOutlet weak var lblMwklMsg: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCivilRegistry: UITextField!
    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }
    @IBOutlet weak var viewContainerNameTextFields: UIView!
        {
        didSet {
            viewContainerNameTextFields.applyDimmviewBorderProperties()
        }
    }
    @IBOutlet weak var viewContaineCivilReigestryTextFields: UIView!
        {
        didSet {
            viewContaineCivilReigestryTextFields.applyDimmviewBorderProperties()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("clientOwner", comment: "")
        lblMwklMsg.text = NSLocalizedString("AddClientOwnerMsg", comment: "")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TawkeelOwnerViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtName {
            viewContainerNameTextFields.applyActiveviewBorderProperties()
            viewContaineCivilReigestryTextFields.applyDimmviewBorderProperties()
            
        }
        else
        {
            viewContainerNameTextFields.applyDimmviewBorderProperties()
            viewContaineCivilReigestryTextFields.applyActiveviewBorderProperties()
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtName {
            viewContainerNameTextFields.applyDimmviewBorderProperties()
        }
        else
        {
            viewContaineCivilReigestryTextFields.applyDimmviewBorderProperties()
        }
    }
}

