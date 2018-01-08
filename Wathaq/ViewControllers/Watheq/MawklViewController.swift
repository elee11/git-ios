//
//  MawklViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/11/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton
import EasyAnimation

class MawklViewController: UIViewController,ToastAlertProtocol {
  
    var OrderDataDic : NSMutableDictionary!
    var TotalCost : Int!
    @IBOutlet weak var lblMwklMsg: UILabel!
    @IBOutlet weak var lblServiceTotalPrice: UILabel!
    @IBOutlet weak var viewTotalProgressBar: UIView!
    @IBOutlet weak var viewMovingProgressBar: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCivilRegistry: UITextField!
    var IsMovingPrgressBarDrawn = false
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
        view.addTapToDismissKeyboard()

        lblServiceTotalPrice.text = "\(TotalCost as Int) \(NSLocalizedString("SR", comment: "") as String)"
        self.title = NSLocalizedString("client", comment: "")
        lblMwklMsg.text = NSLocalizedString("AddClientMsg", comment: "")
        ConfirmButton.setTitle(NSLocalizedString("nextStep", comment: ""), for: .normal)
        txtName.placeholder = NSLocalizedString("name", comment: "")
        txtCivilRegistry.placeholder = NSLocalizedString("civilReg", comment: "")
        if OrderDataDic != nil
        {
            txtName.text = OrderDataDic.value(forKey: "clientName") as? String
            txtCivilRegistry.text = OrderDataDic.value(forKey: "clientNationalID") as? String
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {

        //To Avoid Drawing moving progress bar every time loads view
        if IsMovingPrgressBarDrawn == false {
        viewMovingProgressBar.alpha = 0
        viewMovingProgressBar.width = viewTotalProgressBar.frame.size.width / 4
        viewMovingProgressBar.x = -viewMovingProgressBar.width
        viewMovingProgressBar.alpha = 1
        viewTotalProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
        viewMovingProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
    
            UIView.animate(withDuration: 2.0, animations: {
                self.viewMovingProgressBar.x = 0
            }, completion: { (true) in
                self.IsMovingPrgressBarDrawn = true

            })
            
        }



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMawklDataToOrder(_ sender: Any) {
        view.endEditing(true)
        
        if txtName.text?.isEmpty == true || txtCivilRegistry.text?.isEmpty == true {
            self.showToastMessage(title: NSLocalizedString(("FillAllFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            return
        }
        
            let username =  txtName.text!
            let civilReg =  txtCivilRegistry.text!
            
        
            
            OrderDataDic.setValue(username, forKey: "clientName")
            OrderDataDic.setValue(civilReg, forKey: "clientNationalID")
        
           self.performSegue(withIdentifier: "S_Mawkl_MawkelOwner", sender: OrderDataDic)


        
            
       
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Mawkl_MawkelOwner"  {
            let OrderDic = sender as!  NSMutableDictionary
            let MawklownerView = segue.destination as! TawkeelOwnerViewController
            MawklownerView.OrderDataDic = OrderDic
            MawklownerView.TotalCost = self.TotalCost

            
        }
    }

}

extension MawklViewController : UITextFieldDelegate {
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

