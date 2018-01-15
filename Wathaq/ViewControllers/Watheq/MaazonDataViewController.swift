//
//  MaazonDataViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/1/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class MaazonDataViewController: UIViewController,ToastAlertProtocol {
    var OrderDataDic : NSMutableDictionary!
    
    var IsMovingPrgressBarDrawn = false
    
    var TotalCost : Int!
    var NumOfSteps : Int!
    
    @IBOutlet weak var lblServiceTotalPrice: UILabel!
    @IBOutlet weak var viewTotalProgressBar: UIView!
    @IBOutlet weak var viewMovingProgressBar: UIView!
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtrDate: UITextField!
    @IBOutlet weak var txtDateBtn: UIButton!
    @IBOutlet weak var txtTimeBtn: UIButton!
    
    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }
    @IBOutlet weak var viewContainerTimeTextFields: UIView!
        {
        didSet {
            viewContainerTimeTextFields.applyDimmviewBorderProperties()
        }
    }
    @IBOutlet weak var viewContaineDateTextFields: UIView!
        {
        didSet {
            viewContaineDateTextFields.applyDimmviewBorderProperties()
        }
    }

    var dateViewPicker : DatePickerViewController!
    var timeViewPicker : TimePickerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblServiceTotalPrice.text = "\(TotalCost as Int) \(NSLocalizedString("SR", comment: "") as String)"
        view.addTapToDismissKeyboard()
        self.title = NSLocalizedString("DocumentDate", comment: "")
        
        
        if OrderDataDic.value(forKey: "delivery") as! String == "office"
        {
            lblMsg.text = NSLocalizedString("DocumentMarriageMessagetoOffice", comment: "")

        }
        else
        {
            lblMsg.text = NSLocalizedString("DocumentMarriageMessage", comment: "")

        }
        
        
        
        ConfirmButton.setTitle(NSLocalizedString("nextStep", comment: ""), for: .normal)
        txtTime.placeholder = NSLocalizedString("Time", comment: "")
        txtrDate.placeholder = NSLocalizedString("Date", comment: "")
        if OrderDataDic != nil
        {
            txtTime.text = OrderDataDic.value(forKey: "marriageTime") as? String
            txtrDate.text = OrderDataDic.value(forKey: "marriageDate") as? String
        }

        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        
        //To Avoid Drawing moving progress bar every time loads view
        if IsMovingPrgressBarDrawn == false {
            viewMovingProgressBar.alpha = 0
            viewMovingProgressBar.width = viewTotalProgressBar.frame.size.width
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
    
    @IBAction func openDatePicker(_ sender: Any)     {
        self.view.endEditing(true)
       
        if (timeViewPicker != nil)  {
            self.RemoveTimePickerView()
        }
        
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
    
    
    @IBAction func openTimePicker(_ sender: Any)     {
        self.view.endEditing(true)
        
        if (dateViewPicker != nil)  {
            self.RemovedatePickerView()
        }
        
        if timeViewPicker == nil
        {
            let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            self.timeViewPicker = MainStoryBoard.instantiateViewController(withIdentifier: "TimePickerViewController") as! TimePickerViewController
            self.timeViewPicker.delegate = self
            self.timeViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height-(self.tabBarController?.tabBar.frame.size.height)!, width: self.view.width, height: self.view.frame.size.height * 0.3)
            self.view.addSubview(timeViewPicker.view)
            
            UIView.transition(
                with:self.timeViewPicker.view,
                duration: 0.20,
                options: [
                    .curveEaseIn,
                    ],
                animations: {
                    self.timeViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height-(self.tabBarController?.tabBar.frame.size.height)! - self.view.frame.size.height * 0.3, width: self.view.width, height: self.view.frame.size.height * 0.3)
                    
            },
                completion: {_ in
                    UIView.animate(withDuration: 0.20) {
                        self.setNeedsStatusBarAppearanceUpdate()
                    }
            })
        }
    }
    
    func RemoveTimePickerView()
    {
        UIView.transition(
            with:self.timeViewPicker.view,
            duration: 0.20,
            options: [
                .curveEaseIn,
                ],
            animations: {
                self.timeViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height , width: self.view.width, height: self.view.frame.size.height * 0.3)
                
        },
            completion: {_ in
                UIView.animate(withDuration: 0.20) {
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.timeViewPicker.view.removeFromSuperview()
                    self.timeViewPicker = nil
                }
        })
    }
    
    
    @IBAction func NextStep(_ sender: Any) {
        view.endEditing(true)
        
        if self.txtrDate.text?.isEmpty == true || self.txtTime.text?.isEmpty == true {
            self.showToastMessage(title: NSLocalizedString(("FillAllFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            return
        }
        
        let txtDate =  self.txtrDate.text!
        let txtTime =  self.txtTime.text!
        
        
        
        OrderDataDic.setValue(txtDate, forKey: "marriageDate")
        OrderDataDic.setValue(txtTime, forKey: "marriageTime")
        
        self.performSegue(withIdentifier: "S_MaazonData_ContractLocation", sender: OrderDataDic)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_MaazonData_ContractLocation"  {
            let OrderDic = sender as!  NSMutableDictionary
            let DeliveryLocationView = segue.destination as! MarriageContractLocationViewController
            DeliveryLocationView.title = NSLocalizedString("Receiving the POA", comment: "")
            DeliveryLocationView.OrderDataDic = OrderDic
        }
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

extension MaazonDataViewController: PickerDateDelegate {
    
    func DidUserCancelChoosingDate() {
        
        self.RemovedatePickerView()
        
    }
    
    
    func DidUserChoosedDate(_ ChoosedDate : String){
        
        txtrDate.text = ChoosedDate
        OrderDataDic.setValue(ChoosedDate, forKey: "marriageDate")
        self.RemovedatePickerView()
    }
}

extension MaazonDataViewController: PickerTimeDelegate {
    
    func DidUserCancelChoosingTime() {
        
        self.RemoveTimePickerView()
        
    }
    
    func DidUserChoosedTime(_ ChoosedDate : String){
        
        txtTime.text = ChoosedDate
        OrderDataDic.setValue(ChoosedDate, forKey: "marriageTime")
        self.RemoveTimePickerView()
    }
}


