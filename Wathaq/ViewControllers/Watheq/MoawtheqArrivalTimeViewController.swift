
//
//  MoawtheqArrivalTimeViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/3/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class MoawtheqArrivalTimeViewController: UIViewController,ToastAlertProtocol {

    var TotalCost : Int!
    var NumOfSteps : Int!

    var IsMovingPrgressBarDrawn = false
    @IBOutlet weak var lblServiceTotalPrice: UILabel!
    @IBOutlet weak var viewTotalProgressBar: UIView!
    @IBOutlet weak var viewMovingProgressBar: UIView!
    
    @IBOutlet weak var lblOneHour: UILabel!
    @IBOutlet weak var lblTwoHours: UILabel!
    @IBOutlet weak var lblThreehours: UILabel!
    @IBOutlet weak var btnOneHour: UIButton!
    @IBOutlet weak var btnTwoHours: UIButton!
    @IBOutlet weak var btnThreehours: UIButton!
    
    
    @IBOutlet weak var lblMsgTitle: UILabel!
    @IBOutlet weak var lblMsgTitle2: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDateBtn: UIButton!
    
    var viewModel: OrderViewModel!


    
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
    var OrderDataDic : NSMutableDictionary!
    var timeViewPicker : TimePickerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderViewModel()

        lblServiceTotalPrice.text = "\(TotalCost as Int) \(NSLocalizedString("SR", comment: "") as String)"

        view.addTapToDismissKeyboard()

    }
    
    override func viewDidLayoutSubviews() {
        
        lblOneHour.text = NSLocalizedString("1Hour", comment: "")
        lblTwoHours.text = NSLocalizedString("2Hours", comment: "")
        lblThreehours.text = NSLocalizedString("3Hours", comment: "")
        
        if OrderDataDic.value(forKey: "delivery") as! String == "office"
        {
            lblMsgTitle.text =  NSLocalizedString("MowatheqArrivaOfficelat", comment: "")
            lblMsgTitle2.text =  NSLocalizedString("MawtheqArrivalLater", comment: "")
        }
        else
        {
            lblMsgTitle.text =  NSLocalizedString("MowatheqArrivalat", comment: "")
            lblMsgTitle2.text =  NSLocalizedString("MawtheqArrivalLater", comment: "")
        }
        
        txtTime.placeholder = NSLocalizedString("Time", comment: "")
        
        ConfirmButton.setTitle(NSLocalizedString("CreatOrder", comment: ""), for: .normal)
        
        if IsMovingPrgressBarDrawn == false {
            viewMovingProgressBar.alpha = 0
            viewMovingProgressBar.width = viewTotalProgressBar.frame.size.width 
            viewMovingProgressBar.x = -viewMovingProgressBar.width
            viewMovingProgressBar.alpha = 1
            viewTotalProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
            viewMovingProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
            
            UIView.animate(withDuration: 2.0, animations: {
                // self.viewMovingProgressBar.layer.position.x = 0
                self.viewMovingProgressBar.x = 0
            }, completion: { (true) in
                self.IsMovingPrgressBarDrawn = true
            })
        }
    }
    
    @IBAction func ChooseTimeToArrive(_ sender: Any){
        
        let Tag = (sender as AnyObject).tag as Int

        txtTime.text = ""
        
        switch Tag {
        case 1:
            btnOneHour.setBackgroundImage(UIImage.init(named: "ic_radio_on"), for: .normal)
            btnTwoHours.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
            btnThreehours.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
            //OrderDataDic.setValue("1Hour", forKey: "arrivalTime")


            break
            
        case 2:
            btnOneHour.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
            btnTwoHours.setBackgroundImage(UIImage.init(named: "ic_radio_on"), for: .normal)
            btnThreehours.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
           // OrderDataDic.setValue("2Hour", forKey: "arrivalTime")

            break
            
        case 3:
            btnOneHour.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
            btnTwoHours.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
            btnThreehours.setBackgroundImage(UIImage.init(named: "ic_radio_on"), for: .normal)
          //  OrderDataDic.setValue("3Hour", forKey: "arrivalTime")

            break
        default:
            break
            
        }
        
    }

    
    @IBAction func openTimePicker(_ sender: Any)     {
        self.view.endEditing(true)
        
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
    
    
    @IBAction func CreateOrder (_ sender :Any)
    {
        
       // if OrderDataDic.value(forKey: "arrivalTime") != nil {
            ConfirmButton.startAnimation()
            self.view.isUserInteractionEnabled = false
            if OrderDataDic.value(forKey: "longitude") == nil && OrderDataDic.value(forKey: "latitude") == nil{
                OrderDataDic.setValue(0, forKey: "longitude")
                OrderDataDic.setValue(0, forKey: "latitude")
            }
            
            if OrderDataDic.value(forKey: "clientName") == nil
            {
                OrderDataDic.setValue("", forKey: "clientName")
                OrderDataDic.setValue("", forKey: "clientNationalID")
                
                OrderDataDic.setValue("", forKey: "representativeName")
                OrderDataDic.setValue("", forKey: "representativeNationalID")
            }
        
        
        if let letterNumber =  OrderDataDic.value(forKey: "letterNumber")
        {
            viewModel.CreateContractOrder(OrderDic: OrderDataDic, completion: { (OrderObj, errorMsg) in
                if errorMsg == nil {
                    
                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    
                    self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.performSegue(withIdentifier: "S_Request_SearchingLawyer", sender:OrderObj)
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })
        }
        else
        {
            viewModel.CreateOrder(OrderDic: OrderDataDic, completion: { (OrderObj, errorMsg) in
                if errorMsg == nil {
                    
                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    
                    self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.performSegue(withIdentifier: "S_Request_SearchingLawyer", sender:OrderObj)
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })
            
        }
            
            
//        }
//        else
//        {
//            self.showToastMessage(title: NSLocalizedString(("pleaseChooseArrivalTime"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
//            
//        }
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Request_SearchingLawyer"  {
            let searchingView = segue.destination as! SearchingForAlawyerViewController
            searchingView.OrderObj = sender as! OrderRootClass
        }
    }

}

extension MoawtheqArrivalTimeViewController: PickerTimeDelegate {
    
    func DidUserCancelChoosingTime() {
        
        self.RemoveTimePickerView()
        
    }
    
    func DidUserChoosedTime(_ ChoosedDate : String){
        
        txtTime.text = ChoosedDate
        //OrderDataDic.setValue(ChoosedDate, forKey: "arrivalTime")
        btnOneHour.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
        btnTwoHours.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
        btnThreehours.setBackgroundImage(UIImage.init(named: "ic_radio_off"), for: .normal)
        self.RemoveTimePickerView()
    }
}

