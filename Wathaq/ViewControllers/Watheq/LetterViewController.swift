//
//  LetterViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/30/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class LetterViewController: UIViewController,ToastAlertProtocol {
    var OrderDataDic : NSMutableDictionary!
    var IsMovingPrgressBarDrawn = false

    var TotalCost : Int!
    var NumOfSteps : Int!
    
    @IBOutlet weak var lblServiceTotalPrice: UILabel!
    @IBOutlet weak var viewTotalProgressBar: UIView!
    @IBOutlet weak var viewMovingProgressBar: UIView!
    @IBOutlet weak var lblLetterMsg: UILabel!
    @IBOutlet weak var txtLetterNumber: UITextField!
    @IBOutlet weak var txtLetterDate: UITextField!
    @IBOutlet weak var txtLetterDateBtn: UIButton!
    var dateViewPicker : DatePickerViewController!


    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }
    @IBOutlet weak var viewContainerLetterNumTextFields: UIView!
        {
        didSet {
            viewContainerLetterNumTextFields.applyDimmviewBorderProperties()
        }
    }
    @IBOutlet weak var viewContaineDateTextFields: UIView!
        {
        didSet {
            viewContaineDateTextFields.applyDimmviewBorderProperties()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addTapToDismissKeyboard()
        NumOfSteps = 3
        lblServiceTotalPrice.text = "\(TotalCost as Int) \(NSLocalizedString("SR", comment: "") as String)"
        self.title = NSLocalizedString("LetterData", comment: "")
        lblLetterMsg.text = NSLocalizedString("letterDataMsg", comment: "")
        ConfirmButton.setTitle(NSLocalizedString("nextStep", comment: ""), for: .normal)
        txtLetterNumber.placeholder = NSLocalizedString("letterNumber", comment: "")
        txtLetterDate.placeholder = NSLocalizedString("letterDate", comment: "")
        if OrderDataDic != nil
        {
            txtLetterNumber.text = OrderDataDic.value(forKey: "letterNumber") as? String
            txtLetterDate.text = OrderDataDic.value(forKey: "letterDate") as? String
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        //To Avoid Drawing moving progress bar every time loads view
        if IsMovingPrgressBarDrawn == false {
            viewMovingProgressBar.alpha = 0
            viewMovingProgressBar.width = viewTotalProgressBar.frame.size.width / CGFloat(NumOfSteps)
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

    
     @IBAction func openDatePicker(_ sender: Any)     {
        self.view.endEditing(true)
        if dateViewPicker == nil
        {
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        self.dateViewPicker = MainStoryBoard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        self.dateViewPicker.delegate = self
        self.dateViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height-(self.tabBarController?.tabBar.frame.size.height)!, width: self.view.width, height: self.view.frame.size.height * 0.3)
        self.view.addSubview(dateViewPicker.view)
        
        UIView.transition(
            with:self.dateViewPicker.view,
            duration: 0.20,
            options: [
                .curveEaseIn,
                ],
            animations: {
                self.dateViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height-(self.tabBarController?.tabBar.frame.size.height)! - self.view.frame.size.height * 0.3, width: self.view.width, height: self.view.frame.size.height * 0.3)
                
        },
            completion: {_ in
                UIView.animate(withDuration: 0.20) {
                    self.setNeedsStatusBarAppearanceUpdate()
                }
        })
        }
    }
    
    func RemovedatePickerView()
    {
        UIView.transition(
            with:self.dateViewPicker.view,
            duration: 0.20,
            options: [
                .curveEaseIn,
                ],
            animations: {
                self.dateViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height , width: self.view.width, height: self.view.frame.size.height * 0.3)
                
        },
            completion: {_ in
                UIView.animate(withDuration: 0.20) {
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.dateViewPicker.view.removeFromSuperview()
                    self.dateViewPicker = nil
                }
        })
    }
    
    @IBAction func addLetterDataToOrder(_ sender: Any) {
        view.endEditing(true)
        
        if txtLetterNumber.text?.isEmpty == true || txtLetterDate.text?.isEmpty == true {
            self.showToastMessage(title: NSLocalizedString(("FillAllFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            return
        }
        
        let letterNumber =  txtLetterNumber.text!
        let letterDate =  txtLetterDate.text!
        
        
        
        OrderDataDic.setValue(letterNumber, forKey: "letterNumber")
        OrderDataDic.setValue(letterDate, forKey: "letterDate")
        
        self.performSegue(withIdentifier: "S_Letter_DeliveryLocation", sender: OrderDataDic)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Letter_DeliveryLocation"  {
            let OrderDic = sender as!  NSMutableDictionary
            let DeliveryLocationView = segue.destination as! DeliveryLocationViewController
            DeliveryLocationView.title = NSLocalizedString("Receiving the POA", comment: "")
            DeliveryLocationView.OrderDataDic = OrderDic
            DeliveryLocationView.NumOfSteps = NumOfSteps - 1
            DeliveryLocationView.TotalCost = self.TotalCost
        }
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

extension LetterViewController: PickerDateDelegate {
    
    func DidUserCancelChoosingDate() {
        
        self.RemovedatePickerView()
        
    }
    
    
    func DidUserChoosedDate(_ ChoosedDate : String){
        
        txtLetterDate.text = ChoosedDate
        OrderDataDic.setValue(ChoosedDate, forKey: "letterDate")
        self.RemovedatePickerView()
    }
}
