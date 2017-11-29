//
//  CompleteProfileViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/29/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class CompleteProfileViewController: UIViewController {

    @IBOutlet weak var lblCompleteProfileHello: UILabel!
    @IBOutlet weak var lblCompleteProfileMsg: UILabel!
    @IBOutlet weak var btnAgreeTermsandConditions: UIButton!
    @IBOutlet weak var btnProfilepicture: UIButton!

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtmail: UITextField!

    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var viewContaineruserTextFields: UIView!
        {
        didSet {
            viewContaineruserTextFields.applyDimmviewBorderProperties()
        }
    }
    @IBOutlet weak var viewContaineMailTextFields: UIView!
        {
        didSet {
            viewContaineMailTextFields.applyDimmviewBorderProperties()
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
