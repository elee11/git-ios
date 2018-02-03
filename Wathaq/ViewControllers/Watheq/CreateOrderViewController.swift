//
//  CreateOrderViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/31/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import Firebase
import DAKeychain
import TransitionButton



class CreateOrderViewController: UIViewController,ToastAlertProtocol {
    @IBOutlet weak var SegmentControl: BetterSegmentedControl!
    @IBOutlet weak var tblOrder: UITableView!
    var viewModel: UserViewModel!
    var orderModel: OrderViewModel!

    var CatId = 1
    var SubCatid = 2
    var TawkeelOrderDataDic : NSMutableDictionary!
    var dataViewPicker : PickerViewController!
    var timeViewPicker : TimePickerViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        TawkeelOrderDataDic = NSMutableDictionary ()
        TawkeelOrderDataDic.setValue("office", forKey: "delivery")
        TawkeelOrderDataDic.setValue("1 hours", forKey: "time")


        viewModel = UserViewModel()
        orderModel = OrderViewModel()

        self.checktoRegisterDeviceToken()
        self.adjustSegmentControl()
        tblOrder.rowHeight = UITableViewAutomaticDimension
       // self.tblOrder.estimatedRowHeight = 100
        self.title = NSLocalizedString("new order", comment: "")

    }
    
    override  func viewDidLayoutSubviews() {
        self.customizeTabBarLocal()
        
        
    }
    
    func checktoRegisterDeviceToken()
    {
        if  UserDefaults.standard.string(forKey: "TokenDevice") != nil
        {
            let UuidData : String!
            if let uuidvalue = DAKeychain.shared["uuid"]
            {
                UuidData = uuidvalue
            }
            else
            {
                let uuid = UUID().uuidString
                DAKeychain.shared["uuid"] = uuid // Store
                UuidData = uuid
            }
            
            let NotificationData =  NSMutableDictionary()
            NotificationData.setValue(UserDefaults.standard.string(forKey: "TokenDevice"), forKey: "token")
            NotificationData.setValue(UuidData, forKey: "identifier")
            NotificationData.setValue(NSLocale.preferredLanguages[0], forKey: "locale")
            
            
            self.RegisterDeviceToken(ident: UuidData, FBToken: UserDefaults.standard.string(forKey: "TokenDevice")!)
        }
    }
    
    func RegisterDeviceToken(ident :String , FBToken : String)
    {
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User
        
        let values = ["displayName": userObj?.name, "email": userObj?.email, "instanceId": FBToken, "uid" :"\(userObj!.userID as! Int)"]
        Database.database().reference().child("users").child("\(userObj!.userID as! Int)").updateChildValues(values, withCompletionBlock: { (errr, _) in
            if errr == nil {
                
            }
        })
        
        viewModel.RegisterDeviceToken(identifier:ident , firebaseToken:FBToken,  completion: { (ResponseDic, errorMsg) in
            if errorMsg == nil {
                
                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
        
    }
    

    
    func customizeTabBarLocal ()
    {
        
        let TabBarView = UIApplication.shared.delegate?.window??.rootViewController as! UITabBarController
        let tabBar1 :UITabBarItem  = TabBarView.tabBar.items![0]
        tabBar1.title = NSLocalizedString("watheq", comment: "")
        
        let tabBar2:UITabBarItem = TabBarView.tabBar.items![1]
        tabBar2.title = NSLocalizedString("myOrders", comment: "")
        
        let tabBar3:UITabBarItem = TabBarView.tabBar.items![2] as UITabBarItem
        tabBar3.title = NSLocalizedString("notifications", comment: "")
        
        let tabBar4:UITabBarItem = TabBarView.tabBar.items![3] as UITabBarItem
        tabBar4.title = NSLocalizedString("profile", comment: "")
    }

    
    func adjustSegmentControl ()
    {
        SegmentControl.titles = [NSLocalizedString("wekala", comment: ""), NSLocalizedString("contract", comment: ""), NSLocalizedString("marriage", comment: "")]
        SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
        SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
        SegmentControl.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NWConnectivityDidChangeCalled) , name: .NWConnectivityDidChange, object: nil)
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
          CatId = 1
        self.tblOrder.reloadData()

        }
        else if sender.index == 1  {
          CatId = 10
            self.tblOrder.reloadData()
        }
        else
        {
            CatId = 13
            self.tblOrder.reloadData()

        }
    }
    
    @objc func WekalaSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
           //Create Wekala
            SubCatid = 2
        }
        else if sender.index == 1  {
           //Cancel Wekala
            SubCatid = 6
        }
    }
    
    @objc func WekalaLocationSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            TawkeelOrderDataDic.setValue("office", forKey: "delivery")

        }
        else if sender.index == 1  {
            
            TawkeelOrderDataDic.setValue("home", forKey: "delivery")

        }
    }
    
    @objc func WekalaMeetingTimeSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            
            TawkeelOrderDataDic.setValue("1 hours", forKey: "time")

        }
        else if sender.index == 1  {
            TawkeelOrderDataDic.setValue("2 hours", forKey: "time")

        }
        else
        {
            TawkeelOrderDataDic.setValue("3 hours", forKey: "time")

        }
        
       // self.tblOrder.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Home_Location"  {
            let OrderDic = sender as!  NSMutableDictionary
            let CurrentLocationView = segue.destination as! CurrentLocationViewController
            CurrentLocationView.OrderDataDic = OrderDic
            CurrentLocationView.ParentView = self
         
        }
        else  if segue.identifier == "S_Request_SearchingLawyer"  {
            let searchingView = segue.destination as! SearchingForAlawyerViewController
            searchingView.OrderObj = sender as! OrderRootClass
        }
    }
    
    
    @objc func NWConnectivityDidChangeCalled() {
        print("=========================")
        print("network connectivity changed")
        print("=========================")
        
        if NWConnectivity.sharedInstance.isConnectedToInternet() {
            print("========================= Connected ")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Wekala Methods
    
    @objc func OpenSefaMowklDDL()
    {
        if SubCatid == 2
        {
            self.openDatePicker(readPlistCreateSefaMowakl())

        }
        else
        {
            self.openDatePicker(readPlistCancelSefaMowakl())

        }
    }
    @objc func OpenlocationDDL()
    {
        self.performSegue(withIdentifier: "S_Home_Location", sender: TawkeelOrderDataDic)

    }
    
    @objc func OpenlaterTimeDDL()
    {
        self.openTimePicker()
    }
    @IBAction func CreatOrder(_ sender : Any)
    {
       
        if (TawkeelOrderDataDic.object(forKey: "categoryId") != nil && TawkeelOrderDataDic.object(forKey: "clientName") != nil && TawkeelOrderDataDic.object(forKey: "representativeName") != nil && TawkeelOrderDataDic.object(forKey: "clientNationalID") != nil && TawkeelOrderDataDic.object(forKey: "representativeNationalID") != nil && TawkeelOrderDataDic.object(forKey: "delivery") != nil && TawkeelOrderDataDic.object(forKey: "latitude") != nil && TawkeelOrderDataDic.object(forKey: "longitude") != nil && TawkeelOrderDataDic.object(forKey: "time") != nil && TawkeelOrderDataDic.object(forKey: "address") != nil)
        {
        
        let TranstBtn:TransitionButton =  sender as! TransitionButton

        TranstBtn.startAnimation()
        self.view.isUserInteractionEnabled = false
        orderModel.CreateOrder(OrderDic: TawkeelOrderDataDic, completion: { (OrderObj, errorMsg) in
                if errorMsg == nil {
                    
                    TranstBtn.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    
                    self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.performSegue(withIdentifier: "S_Request_SearchingLawyer", sender:OrderObj)
                    self.resetTawkeelTbl()
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    TranstBtn.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })
            
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("FillAllFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

        }
        
        
        
    }
    
    func resetTawkeelTbl ()
    {
        SubCatid = 2
        TawkeelOrderDataDic = NSMutableDictionary ()
        TawkeelOrderDataDic.setValue("office", forKey: "delivery")
        TawkeelOrderDataDic.setValue("1 hours", forKey: "time")
        TawkeelOrderDataDic.removeObject(forKey: "address")
        TawkeelOrderDataDic.removeObject(forKey: "latitude")
        TawkeelOrderDataDic.removeObject(forKey: "longitude")
        TawkeelOrderDataDic.removeObject(forKey: "clientNationalID")
        TawkeelOrderDataDic.removeObject(forKey: "representativeNationalID")
        TawkeelOrderDataDic.removeObject(forKey: "clientName")
        TawkeelOrderDataDic.removeObject(forKey: "representativeName")
        TawkeelOrderDataDic.removeObject(forKey: "SefaCategoryName")
        self.tblOrder.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        let indexpath = IndexPath(row: 0, section: 1)
        let cellTawkeelOwner = self.tblOrder.cellForRow(at:indexpath ) as! WakellDataTableViewCell
        

        cellTawkeelOwner.txtName.text = ""
        cellTawkeelOwner.txtCivilRegistry.text = ""
        
        let cellTawkeel = self.tblOrder.cellForRow(at: IndexPath(row: 0, section: 2)) as! WakellDataTableViewCell
        
        cellTawkeel.txtName.text = ""
        cellTawkeel.txtCivilRegistry.text = ""

        let cellAddress = self.tblOrder.cellForRow(at: IndexPath(row: 2, section: 3) ) as! AddressLocationTableViewCell
        cellAddress.txtAddressLocation.text = ""
        
        self.tblOrder.reloadData()
    }
    
     func openDatePicker(_ ArrData: NSArray)     {
        self.view.endEditing(true)
        if dataViewPicker == nil
        {
            let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            self.dataViewPicker = MainStoryBoard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
            self.dataViewPicker.delegate = self
            self.dataViewPicker.Arr_Data = ArrData
            self.dataViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height-(self.tabBarController?.tabBar.frame.size.height)!, width: self.view.width, height: self.view.frame.size.height * 0.3)
            self.view.addSubview(dataViewPicker.view)
            
            UIView.transition(
                with:self.dataViewPicker.view,
                duration: 0.20,
                options: [
                    .curveEaseIn,
                    ],
                animations: {
                    self.dataViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height-(self.tabBarController?.tabBar.frame.size.height)! - self.view.frame.size.height * 0.3, width: self.view.width, height: self.view.frame.size.height * 0.3)
                    
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
            with:self.dataViewPicker.view,
            duration: 0.20,
            options: [
                .curveEaseIn,
                ],
            animations: {
                self.dataViewPicker.view.frame = CGRect(x: 0, y: self.view.frame.height , width: self.view.width, height: self.view.frame.size.height * 0.3)
                
        },
            completion: {_ in
                UIView.animate(withDuration: 0.20) {
                    self.setNeedsStatusBarAppearanceUpdate()
                    self.dataViewPicker.view.removeFromSuperview()
                    self.dataViewPicker = nil
                }
        })
    }

    
     func openTimePicker()     {
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
    
    



}

extension CreateOrderViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //wkalat
      if CatId == 1
      {
        //wakala type
         if section == 0
        {
            return 2
        }//wakeel data
        else if section == 1 || section == 2 || section == 5
        {
            return 1
        }//location
        else if section == 3
        {
            return 3
        }
            //time
        else
         {
            return 2
          }
      }
     //contacrts
     else if CatId == 10
     {
         return 0
     }//marriage
     else
     {
            return 0
     }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if CatId == 1
        {
          return 6
        }
        else if CatId == 10
        {
            return 0
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if CatId == 1
        {
        if indexPath.section == 0
           {
            if indexPath.row == 0
            {
                let cellWakalaCat:WkalaCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WkalaCategoryTableViewCell") as UITableViewCell! as! WkalaCategoryTableViewCell
                cellWakalaCat.SegmentControl.titles = [NSLocalizedString("Creatwekala", comment: ""), NSLocalizedString("Cancelwekala", comment: "")]
                cellWakalaCat.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellWakalaCat.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellWakalaCat.SegmentControl.addTarget(self, action: #selector(WekalaSegmentedValueChanged(_:)), for: .valueChanged)

                return cellWakalaCat
            }
            else
            {
    
                let cellSefaMowkl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                cellSefaMowkl.btn_OpenDDl.setTitle(NSLocalizedString("SefaWakeel", comment: ""), for: .normal)
                cellSefaMowkl.img_icon.image = UIImage.init(named: "user")
                cellSefaMowkl.btn_OpenDDl.addTarget(self, action: #selector(OpenSefaMowklDDL), for: .touchUpInside)
                
                if let SefaMowkl : String =  TawkeelOrderDataDic.value(forKey: "SefaCategoryName") as? String
                {
                    cellSefaMowkl.btn_OpenDDl.setTitle(SefaMowkl, for: .normal)
                }
                
                return cellSefaMowkl
            }
            
            
        }
        else if indexPath.section == 1 || indexPath.section == 2
        {
            
            let cellMowakelData:WakellDataTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WakellDataTableViewCell") as UITableViewCell! as! WakellDataTableViewCell
            
            if indexPath.section == 1
            {
                cellMowakelData.txtName.placeholder = NSLocalizedString("name", comment: "")
                cellMowakelData.txtCivilRegistry.placeholder = NSLocalizedString("civilReg", comment: "")
                cellMowakelData.txtName.tag = (indexPath.section * 1000) + indexPath.row
                cellMowakelData.txtCivilRegistry.tag = (indexPath.section * 1000) + indexPath.row+1
                cellMowakelData.txtName.delegate = self
                cellMowakelData.txtCivilRegistry.delegate = self


            }
            else
            {
                cellMowakelData.txtName.placeholder = NSLocalizedString("name", comment: "")
                cellMowakelData.txtCivilRegistry.placeholder = NSLocalizedString("civilReg", comment: "")
                cellMowakelData.txtName.tag = (indexPath.section * 1000) + indexPath.row
                cellMowakelData.txtCivilRegistry.tag = (indexPath.section * 1000) + indexPath.row+1
                cellMowakelData.txtName.delegate = self
                cellMowakelData.txtCivilRegistry.delegate = self
            }
            return cellMowakelData
        }
        else if indexPath.section == 3
        {
            if indexPath.row == 0
            {
             
                let cellWakalaCat:WkalaCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WkalaCategoryTableViewCell") as UITableViewCell! as! WkalaCategoryTableViewCell
                cellWakalaCat.SegmentControl.titles = [NSLocalizedString("office", comment: ""), NSLocalizedString("home", comment: "")]
                cellWakalaCat.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellWakalaCat.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellWakalaCat.SegmentControl.addTarget(self, action: #selector(WekalaLocationSegmentedValueChanged(_:)), for: .valueChanged)

                
                return cellWakalaCat
            }
            else if indexPath.row == 1
            {
              
                let cellChooseLocation:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                cellChooseLocation.btn_OpenDDl.setTitle(NSLocalizedString("ChooseAdreess", comment: ""), for: .normal)
                cellChooseLocation.img_icon.image = UIImage.init(named: "gps-check")
                cellChooseLocation.btn_OpenDDl.addTarget(self, action: #selector(OpenlocationDDL), for: .touchUpInside)
                return cellChooseLocation

            }
            else
            {
                let cellAddressLocation:AddressLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier:"AddressLocationTableViewCell") as UITableViewCell! as! AddressLocationTableViewCell
                cellAddressLocation.txtAddressLocation.placeholder = NSLocalizedString("AddressDetails", comment: "")
                cellAddressLocation.txtAddressLocation.tag = (indexPath.section * 1000) + indexPath.row
                cellAddressLocation.txtAddressLocation.delegate = self
                return cellAddressLocation
            }
        }
        else if indexPath.section == 4
        {
            if indexPath.row == 0
            {
              
                let cellMeetingTime:TawkeelMeetingTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier:"TawkeelMeetingTimeTableViewCell") as UITableViewCell! as! TawkeelMeetingTimeTableViewCell
                cellMeetingTime.SegmentControl.titles = [NSLocalizedString("1Hour", comment: ""), NSLocalizedString("2Hours", comment: ""),NSLocalizedString("3Hours", comment: "")]
                cellMeetingTime.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellMeetingTime.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellMeetingTime.SegmentControl.addTarget(self, action: #selector(WekalaMeetingTimeSegmentedValueChanged(_:)), for: .valueChanged)
                
                return cellMeetingTime
                
            }
            else
            {
                
                let cellChooseTimeDdl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                cellChooseTimeDdl.btn_OpenDDl.setTitle(NSLocalizedString("LaterTime", comment: ""), for: .normal)
                cellChooseTimeDdl.img_icon.image = UIImage.init(named: "time")
                cellChooseTimeDdl.btn_OpenDDl.addTarget(self, action: #selector(OpenlaterTimeDDL), for: .touchUpInside)
                if let TimeMowkl : String =  TawkeelOrderDataDic.value(forKey: "time") as? String
                {
                    cellChooseTimeDdl.btn_OpenDDl.setTitle(TimeMowkl, for: .normal)
                }
                
                return cellChooseTimeDdl
                
            }
         }
        else
        {
            let cellCreatOrder:CreateOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"CreateOrderTableViewCell") as UITableViewCell! as! CreateOrderTableViewCell
            cellCreatOrder.btnCreatOrder.setTitle(NSLocalizedString("CreatOrder", comment: ""), for: .normal)
            cellCreatOrder.btnCreatOrder.addTarget(self, action: #selector(CreatOrder), for: .touchUpInside)
            return cellCreatOrder
        }
        }
        else if CatId == 10
        {
                let cellChooseTimeDdl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                
                return cellChooseTimeDdl
        }
        else
        {
                let cellChooseTimeDdl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                
                return cellChooseTimeDdl
        }
    }
    
}

extension CreateOrderViewController: UITableViewDelegate {
    
  
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if CatId == 1
        {
        if section == 0
        {
        let cellOrderHeader:OrderHeader = tableView.dequeueReusableCell(withIdentifier:"OrderHeader") as UITableViewCell! as! OrderHeader
            cellOrderHeader.lbl_Header.text = NSLocalizedString("CreateOrCancelWekala", comment: "")
        return cellOrderHeader
        }
            else if section == 5
        {
            let cellOrderHeader:OrderHeader = tableView.dequeueReusableCell(withIdentifier:"OrderHeader") as UITableViewCell! as! OrderHeader
            cellOrderHeader.lbl_Header.isHidden = true
            return cellOrderHeader

        }
        else
        {
            
            let cellOrderHeader:OrderSectionHeader = tableView.dequeueReusableCell(withIdentifier:"OrderSectionHeader") as UITableViewCell! as! OrderSectionHeader
            if section == 1
            {
                cellOrderHeader.lbl_Header.text = NSLocalizedString("client", comment: "")
            }
            else if section == 2
            {
                cellOrderHeader.lbl_Header.text = NSLocalizedString("clientOwner", comment: "")

            }
            else if section == 3
            {
                cellOrderHeader.lbl_Header.text = NSLocalizedString("WekalaDelivery", comment: "")
            }
            else if section == 4
            {
                cellOrderHeader.lbl_Header.text = NSLocalizedString("datingTime", comment: "")

            }
            
            return cellOrderHeader
        }
        }
        else if CatId == 10
        {
            let cellOrderHeader:OrderHeader = tableView.dequeueReusableCell(withIdentifier:"OrderHeader") as UITableViewCell! as! OrderHeader
            return cellOrderHeader
        }
        else
        {
            let cellOrderHeader:OrderHeader = tableView.dequeueReusableCell(withIdentifier:"OrderHeader") as UITableViewCell! as! OrderHeader
            return cellOrderHeader
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
    }
}

extension CreateOrderViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
      let  row = textField.tag % 1000
      let  section = textField.tag / 1000
        textField.applyGreenviewBorderProperties()

        if section == 1
        {
            self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 90), animated: true)
       
        }
        else if section == 2
        {
            self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 120), animated: true)
           
        }
        else
        {
            self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 250), animated: true)

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 0), animated: true)
        textField.applyDGrayBorderProperties()
        let  row = textField.tag % 1000
        let  section = textField.tag / 1000
        
        if section == 1
        {
            if row == 0
            {
                TawkeelOrderDataDic.setValue(textField.text, forKey: "clientName")
            }
            else
            {
                TawkeelOrderDataDic.setValue(textField.text, forKey: "clientNationalID")
            }
        }
        else if section == 2
        {
            if row == 0
            {
                TawkeelOrderDataDic.setValue(textField.text, forKey: "representativeName")
            }
            else
            {
                TawkeelOrderDataDic.setValue(textField.text, forKey: "representativeNationalID")
                
            }
        }
        else
        {
            TawkeelOrderDataDic.setValue(textField.text, forKey: "address")

        }
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}

extension CreateOrderViewController: PickerDelegate {
    
    func DidUserCancelChoosingItem() {
        
        self.RemovedatePickerView()
        
    }
    
    
    func DidUserChoosedItem(_ ChoosedItem : NSDictionary){
        
        TawkeelOrderDataDic.setValue(ChoosedItem.value(forKey: "id"), forKey: "categoryId")
        
        var key = "Name_EN"
        if Language.getCurrentLanguage() == Constants.Language.ARABIC {
            key = "Name"
        }
        
        TawkeelOrderDataDic.setValue(ChoosedItem.value(forKey: key), forKey: "SefaCategoryName")

        self.tblOrder.reloadData()
        self.RemovedatePickerView()
    }
}


extension CreateOrderViewController: PlistReaderProtocol {
    func readPlistCancelSefaMowakl() -> NSArray{
        let fileName = "CancelSefaMowaklList"
        let data =  (self as PlistReaderProtocol).readPlist(fileName: fileName)
        return data as! NSArray
    }
    
    func readPlistCreateSefaMowakl() -> NSArray{
        let fileName = "CreateSefaMowaklList"
        let data =  (self as PlistReaderProtocol).readPlist(fileName: fileName)
        return data as! NSArray
    }

}

extension CreateOrderViewController: PickerTimeDelegate {
    
    func DidUserCancelChoosingTime() {
        
        self.RemoveTimePickerView()
        
    }
    
    func DidUserChoosedTime(_ ChoosedDate : String){
        
        TawkeelOrderDataDic.setValue(ChoosedDate, forKey: "time")
        self.RemoveTimePickerView()
        self.tblOrder.reloadData()
    }
}


extension UITextField {
    func applyGreenviewBorderProperties() {
        layer.borderWidth = 1
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 6.0
    }
    
    func applyDGrayBorderProperties() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.manatee1.cgColor
        layer.cornerRadius = 6.0
    }
}

