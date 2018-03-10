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
     var SegmentControl: BetterSegmentedControl!
    @IBOutlet weak var tblOrder: UITableView!
    var viewModel: UserViewModel!
    var orderModel: OrderViewModel!
    var catViewModel: CategoriesViewModel!
    var homeDeliveryFee = 150

    var ArrCat :[CatObject]!


    var CatId = 1
    var SubCatid = 2
    var TawkeelOrderDataDic : NSMutableDictionary!
    var ContractOrderDataDic : NSMutableDictionary!
    var NekahOrderDataDic : NSMutableDictionary!


    var dataViewPicker : PickerViewController!
    var timeViewPicker : TimePickerViewController!
    var dateViewPicker : DatePickerViewController!



    override func viewDidLoad() {
        super.viewDidLoad()
        TawkeelOrderDataDic = NSMutableDictionary ()
        ContractOrderDataDic = NSMutableDictionary ()
        NekahOrderDataDic = NSMutableDictionary ()

        ArrCat = [CatObject]()
        catViewModel = CategoriesViewModel()
        
        getWkalataCategories()


        TawkeelOrderDataDic.setValue("office", forKey: "delivery")
        TawkeelOrderDataDic.setValue("1 hours", forKey: "time")
        TawkeelOrderDataDic.setValue(1, forKey: "MainCatId")

        ContractOrderDataDic.setValue("office", forKey: "delivery")
        ContractOrderDataDic.setValue("1 hours", forKey: "time")
        ContractOrderDataDic.setValue(10, forKey: "MainCatId")
        ContractOrderDataDic.setValue(10, forKey: "categoryId")

        
        NekahOrderDataDic.setValue("office", forKey: "delivery")
        NekahOrderDataDic.setValue("1 hours", forKey: "time")
        NekahOrderDataDic.setValue(13, forKey: "MainCatId")
        NekahOrderDataDic.setValue(13, forKey: "categoryId")


        viewModel = UserViewModel()
        orderModel = OrderViewModel()

        self.checktoRegisterDeviceToken()
        self.adjustSegmentControl()
        tblOrder.rowHeight = UITableViewAutomaticDimension
       // self.tblOrder.estimatedRowHeight = 100
       // self.title = NSLocalizedString("new order", comment: "")

    }
    
    override  func viewDidLayoutSubviews() {
        self.customizeTabBarLocal()
        
        
    }
    
    func getWkalataCategories()
    {
        catViewModel.GetCategories { (wkalatTypeObj, errorMsg) in
            if errorMsg == nil {
               
                self.homeDeliveryFee = (wkalatTypeObj?.wkalatTypes?.deliverToHomeFees)!
                if let arrCatData = wkalatTypeObj?.wkalatTypes?.categories
                {
                    self.ArrCat = arrCatData as [CatObject]
                }
                else
                {
                    self.ArrCat = [CatObject]()
                }
                
                self.tblOrder.reloadData()

                
            } else{
               
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

            }
        }
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
        SegmentControl = BetterSegmentedControl(
            frame: CGRect(x: (self.navigationController?.navigationBar.center.x)! - ((self.navigationController?.navigationBar.width)! - 30)/2 , y: 2, width: (self.navigationController?.navigationBar.width)! - 30 , height: 41),
            titles: [NSLocalizedString("marriage", comment: ""), NSLocalizedString("contract", comment: ""), NSLocalizedString("wekala", comment: "")],
            index: 2,
            options: [.backgroundColor(UIColor.clear),
                      .titleColor(UIColor.ashGrey),
                      .indicatorViewBackgroundColor(UIColor.YellowSEGMENT),
                      .selectedTitleColor(.white),
                      .titleFont(UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!),
                      .selectedTitleFont(UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!)]
        )
       
        SegmentControl.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NWConnectivityDidChangeCalled) , name: .NWConnectivityDidChange, object: nil)
        SegmentControl.semanticContentAttribute = .forceRightToLeft
        SegmentControl.tintColor = UIColor.ashGrey
        SegmentControl.cornerRadius = 10.0
        SegmentControl.backgroundColor = UIColor.clear
       navigationItem.titleView = SegmentControl
        


        
    }
    
    @IBAction func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            CatId = 13
            self.tblOrder.reloadData()
        }
        else if sender.index == 1  {
          CatId = 10
            self.tblOrder.reloadData()
        }
        else
        {
            CatId = 1
            self.tblOrder.reloadData()
          

        }
    }
    
    @IBAction func WekalaSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
           //Create Wekala
            SubCatid = 2
        }
        else if sender.index == 1  {
           //Cancel Wekala
            SubCatid = 6
        }
        
        TawkeelOrderDataDic.removeObject(forKey: "SefaCategoryName")
        TawkeelOrderDataDic.removeObject(forKey: "categoryId")
        self.tblOrder.reloadData()

    }
    
    @IBAction func WekalaLocationSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            TawkeelOrderDataDic.setValue("office", forKey: "delivery")

        }
        else if sender.index == 1  {
            
            TawkeelOrderDataDic.setValue("home", forKey: "delivery")

        }
        
        self.tblOrder.reloadData()
    }
    
    @IBAction func WekalaMeetingTimeSegmentedValueChanged(_ sender: BetterSegmentedControl) {
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
        
        self.tblOrder.reloadData()
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
    
    @IBAction func OpenSefaMowklDDL(_ sender : Any)
    {
        if SubCatid == 2
        {
            self.openDataPicker(readPlistCreateSefaMowakl())

        }
        else
        {
            self.openDataPicker(readPlistCancelSefaMowakl())

        }
    }
    @IBAction func OpenlocationDDL(_ sender : Any)
    {
        if CatId == 1
        {
            self.performSegue(withIdentifier: "S_Home_Location", sender: TawkeelOrderDataDic)

        }
        else if CatId == 10
        {
            self.performSegue(withIdentifier: "S_Home_Location", sender: ContractOrderDataDic)

        }
        else
        {
            self.performSegue(withIdentifier: "S_Home_Location", sender: NekahOrderDataDic)

        }

    }
    
    @IBAction func OpenlaterTimeDDL(_ sender : Any)
    {
        self.openTimePicker()
    }
    @IBAction func CreatOrder(_ sender : Any)
    {
       
        if (TawkeelOrderDataDic.object(forKey: "categoryId") != nil  && TawkeelOrderDataDic.object(forKey: "delivery") != nil && TawkeelOrderDataDic.object(forKey: "latitude") != nil && TawkeelOrderDataDic.object(forKey: "longitude") != nil && TawkeelOrderDataDic.object(forKey: "time") != nil)
        {
        
            if  TawkeelOrderDataDic.object(forKey: "address") == nil
            {
                TawkeelOrderDataDic.setValue(" ", forKey: "address")
            }
            
            
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
            self.showToastMessage(title: NSLocalizedString(("FillMandatoryFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

        }
        
        
        
    }
    
    func resetTawkeelTbl ()
    {
        SubCatid = 2
        TawkeelOrderDataDic = NSMutableDictionary ()
        TawkeelOrderDataDic.setValue(1, forKey: "MainCatId")
        TawkeelOrderDataDic.setValue("office", forKey: "delivery")
        TawkeelOrderDataDic.setValue("1 hours", forKey: "time")
        TawkeelOrderDataDic.removeObject(forKey: "address")
        TawkeelOrderDataDic.removeObject(forKey: "latitude")
        TawkeelOrderDataDic.removeObject(forKey: "longitude")
   
        TawkeelOrderDataDic.removeObject(forKey: "SefaCategoryName")
        self.tblOrder.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
      
        


    
        
        self.tblOrder.reloadData()
    }
    
     func openDataPicker(_ ArrData: NSArray)     {
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
    
    func RemovedataPickerView()
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
    
    // MARK: Contracts Methods
    @IBAction func openContractSubCat(_ sender : Any)
    {
        self.openDataPicker(readPlistSubContractsCategories())

    }

    @IBAction func OpenletterTimeDDL(_ sender : Any)
    {
        self.openDatePicker()
    }
    
    
     func openDatePicker()     {
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
    
    @IBAction func ContractLocationSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            ContractOrderDataDic.setValue("office", forKey: "delivery")
        }
        else if sender.index == 1  {
            ContractOrderDataDic.setValue("home", forKey: "delivery")
        }
        self.tblOrder.reloadData()
    }
    
    @IBAction func ContractMeetingTimeSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            
            ContractOrderDataDic.setValue("1 hours", forKey: "time")
            
        }
        else if sender.index == 1  {
            ContractOrderDataDic.setValue("2 hours", forKey: "time")
            
        }
        else
        {
            ContractOrderDataDic.setValue("3 hours", forKey: "time")
            
        }
        
         self.tblOrder.reloadData()
    }
    
    
    @IBAction func CreatContractOrder(_ sender : Any)
    {
        
        if (ContractOrderDataDic.object(forKey: "categoryId") != nil && ContractOrderDataDic.object(forKey: "delivery") != nil && ContractOrderDataDic.object(forKey: "latitude") != nil && ContractOrderDataDic.object(forKey: "longitude") != nil &&  ContractOrderDataDic.object(forKey: "time") != nil)
        {
            if  ContractOrderDataDic.object(forKey: "address") == nil
            {
                ContractOrderDataDic.setValue(" ", forKey: "address")
            }
            
            let TranstBtn:TransitionButton =  sender as! TransitionButton
            
            TranstBtn.startAnimation()
            
            orderModel.CreateContractOrder(OrderDic: ContractOrderDataDic, completion: { (OrderObj, errorMsg) in
                if errorMsg == nil {
                    
                    TranstBtn.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    
                    self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    self.resetContractTbl()

                    self.performSegue(withIdentifier: "S_Request_SearchingLawyer", sender:OrderObj)
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    TranstBtn.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("FillMandatoryFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            
        }
        
        
        
    }
    
    func resetContractTbl ()
    {
        ContractOrderDataDic = NSMutableDictionary ()
        ContractOrderDataDic.setValue(10, forKey: "MainCatId")

        ContractOrderDataDic.setValue("office", forKey: "delivery")
        ContractOrderDataDic.setValue("1 hours", forKey: "time")
        ContractOrderDataDic.removeObject(forKey: "address")
        ContractOrderDataDic.removeObject(forKey: "latitude")
        ContractOrderDataDic.removeObject(forKey: "longitude")

     
        
  
        
      
        
        self.tblOrder.reloadData()
    }
    
     // MARK: Contracts Methods
    @IBAction func NekahLocationSegmentedValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            NekahOrderDataDic.setValue("office", forKey: "delivery")
            
        }
        else if sender.index == 1  {
            
            NekahOrderDataDic.setValue("home", forKey: "delivery")
            
        }
        
        self.tblOrder.reloadData()
    }
    
    @IBAction func CreatNekahOrder(_ sender : Any)
    {
        
        if (NekahOrderDataDic.object(forKey: "categoryId") != nil && NekahOrderDataDic.object(forKey: "delivery") != nil && NekahOrderDataDic.object(forKey: "latitude") != nil && NekahOrderDataDic.object(forKey: "longitude") != nil && NekahOrderDataDic.object(forKey: "marriageDate") != nil && NekahOrderDataDic.object(forKey: "marriageTime") != nil)
        {
            if  NekahOrderDataDic.object(forKey: "address") == nil
            {
                NekahOrderDataDic.setValue(" ", forKey: "address")
            }
            
            let TranstBtn:TransitionButton =  sender as! TransitionButton
            TranstBtn.startAnimation()
            orderModel.CreateNekahOrder(OrderDic: NekahOrderDataDic, completion: { (OrderObj, errorMsg) in
                if errorMsg == nil {
                    
                    TranstBtn.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    self.resetNekahtTbl()
                    self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.performSegue(withIdentifier: "S_Request_SearchingLawyer", sender:OrderObj)
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    TranstBtn.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })
    
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("FillMandatoryFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            
        }
    }
    
    func resetNekahtTbl ()
    {
   
        NekahOrderDataDic = NSMutableDictionary ()
        NekahOrderDataDic.setValue(13, forKey: "MainCatId")
        NekahOrderDataDic.setValue(13, forKey: "categoryId")
        NekahOrderDataDic.setValue("office", forKey: "delivery")
        NekahOrderDataDic.removeObject(forKey: "address")
        NekahOrderDataDic.removeObject(forKey: "latitude")
        NekahOrderDataDic.removeObject(forKey: "longitude")
        NekahOrderDataDic.removeObject(forKey: "marriageDate")
        NekahOrderDataDic.removeObject(forKey: "marriageTime")

        
        self.tblOrder.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
     
        
        
        
      
        
        self.tblOrder.reloadData()
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
        else if  section == 3
        {
            return 1
        }//location
        else if section == 1
        {
            return 2
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
         if section == 0 || section == 1
         {
            return 2
         }
        else if section == 1
         {
            return 2
        }
        else
         {
            return 1
        }
     }//marriage
     else
     {
            if section == 0
            {
                return 2
             }
        else if section == 1
            {
                 return 2
            }
        else
            {
                 return 1
            }
     }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if CatId == 1
        {
          return 4
        }
        else if CatId == 10
        {
            return 3
        }
        else
        {
            return 3
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
                cellWakalaCat.SegmentControl.removeTarget(nil, action: nil, for: .allEvents)
                cellWakalaCat.SegmentControl.addTarget(self, action: #selector(WekalaSegmentedValueChanged(_:)), for: .valueChanged)

                return cellWakalaCat
            }
            else
            {
    
                let cellSefaMowkl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                cellSefaMowkl.btn_OpenDDl.setTitle(NSLocalizedString("SefaWakeel", comment: ""), for: .normal)
                cellSefaMowkl.img_icon.image = UIImage.init(named: "user")
                cellSefaMowkl.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                cellSefaMowkl.btn_OpenDDl.addTarget(self, action: #selector(OpenSefaMowklDDL), for: .touchUpInside)
                
                if let SefaMowkl : String =  TawkeelOrderDataDic.value(forKey: "SefaCategoryName") as? String
                {
                    cellSefaMowkl.btn_OpenDDl.setTitle(SefaMowkl, for: .normal)
                    cellSefaMowkl.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                    
                }
                else
                {
                    cellSefaMowkl.btn_OpenDDl.applybuttonDGrayBorderProperties()

                }
                
                return cellSefaMowkl
            }
            
            
        }
        
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
             
                let cellWakalaCat:WkalaCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WkalaCategoryTableViewCell") as UITableViewCell! as! WkalaCategoryTableViewCell
                

                if let deliveryLocation:String = TawkeelOrderDataDic.value(forKey: "delivery") as! String
                {
                    if deliveryLocation == "home"
                    {
                           cellWakalaCat.SegmentControl.titles = [NSLocalizedString("office", comment: ""),"\(NSLocalizedString("home" , comment: "")) + \(homeDeliveryFee as Int) \(NSLocalizedString("SR" , comment: ""))" ]
                    }
                    else
                    {
                           cellWakalaCat.SegmentControl.titles = [NSLocalizedString("office", comment: ""), NSLocalizedString("home", comment: "")]
                    }
                }
                else
                {
                    cellWakalaCat.SegmentControl.titles = [NSLocalizedString("office", comment: ""), NSLocalizedString("home", comment: "")]

                }
                
                                cellWakalaCat.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellWakalaCat.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellWakalaCat.SegmentControl.removeTarget(nil, action: nil, for: .allEvents)
                cellWakalaCat.SegmentControl.addTarget(self, action: #selector(WekalaLocationSegmentedValueChanged(_:)), for: .valueChanged)

                
                return cellWakalaCat
            }
            else
            {
              
                let cellChooseLocation:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                cellChooseLocation.btn_OpenDDl.setTitle(NSLocalizedString("ChooseAdreess", comment: ""), for: .normal)
                cellChooseLocation.img_icon.image = UIImage.init(named: "gps-check")
                cellChooseLocation.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                cellChooseLocation.btn_OpenDDl.addTarget(self, action: #selector(OpenlocationDDL), for: .touchUpInside)
                if let Location : Double =  TawkeelOrderDataDic.value(forKey: "latitude") as? Double
                {
                    cellChooseLocation.btn_OpenDDl.setTitle(NSLocalizedString(NSLocalizedString("LocationChoosed", comment: ""), comment: ""), for: .normal)
                    cellChooseLocation.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                    
                }
                else
                {
                    cellChooseLocation.btn_OpenDDl.applybuttonDGrayBorderProperties()
                    
                }
                
                
                return cellChooseLocation

            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
              
                let cellMeetingTime:TawkeelMeetingTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier:"TawkeelMeetingTimeTableViewCell") as UITableViewCell! as! TawkeelMeetingTimeTableViewCell
                cellMeetingTime.SegmentControl.titles = [NSLocalizedString("1Hour", comment: ""), NSLocalizedString("2Hours", comment: ""),NSLocalizedString("3Hours", comment: "")]
                cellMeetingTime.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellMeetingTime.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                cellMeetingTime.SegmentControl.removeTarget(nil, action: nil, for: .allEvents)
                cellMeetingTime.SegmentControl.addTarget(self, action: #selector(WekalaMeetingTimeSegmentedValueChanged(_:)), for: .valueChanged)
                
                return cellMeetingTime
                
            }
            else
            {
                
                let cellChooseTimeDdl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                
                cellChooseTimeDdl.btn_OpenDDl.setTitle(NSLocalizedString("LaterTime", comment: ""), for: .normal)
                cellChooseTimeDdl.img_icon.image = UIImage.init(named: "time")
                cellChooseTimeDdl.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                cellChooseTimeDdl.btn_OpenDDl.addTarget(self, action: #selector(OpenlaterTimeDDL), for: .touchUpInside)
                if let TimeMowkl : String =  TawkeelOrderDataDic.value(forKey: "time") as? String
                {
                    if TimeMowkl == "1 hours" || TimeMowkl == "2 hours" || TimeMowkl == "3 hours"
                    {
                        cellChooseTimeDdl.btn_OpenDDl.setTitle(NSLocalizedString("LaterTime", comment: ""), for: .normal)
                    }
                    else
                    {
                        cellChooseTimeDdl.btn_OpenDDl.setTitle(TimeMowkl, for: .normal)
                    }
                    cellChooseTimeDdl.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                    
                }
                else
                {
                    cellChooseTimeDdl.btn_OpenDDl.applybuttonDGrayBorderProperties()
                    
                }
                return cellChooseTimeDdl
                
            }
         }
        else
        {
            let cellCreatOrder:CreateOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"CreateOrderTableViewCell") as UITableViewCell! as! CreateOrderTableViewCell
            
            if  self.ArrCat.count > 0
            {
                var index = 0
                if SubCatid == 2
                {
                    index = 0
                }
                else
                {
                    index = 1
                }
                let CatObj =  self.ArrCat[0].subs![index] as Sub
                
                if let categoryId = TawkeelOrderDataDic.value(forKey: "categoryId")
                {
                    if categoryId as! Int  != 1
                    {
                        for var subCat  in CatObj.subs!  {
                            if (subCat as Sub).id  == categoryId as! Int {
                                cellCreatOrder.btnCreatOrder.setTitle("\(NSLocalizedString("CreatOrder", comment: "")) (\(subCat.cost as! Int) \(NSLocalizedString("SR", comment:"")))", for: .normal)

                            }
                        }
                    }
                    else
                    {
                        cellCreatOrder.btnCreatOrder.setTitle("\(NSLocalizedString("CreatOrder", comment: "")) (\(CatObj.cost as! Int) \(NSLocalizedString("SR", comment:"")))", for: .normal)

                    }
                }
                else
                {
                    cellCreatOrder.btnCreatOrder.setTitle((NSLocalizedString("CreatOrder", comment: "")), for: .normal)
                }
                

            }
            else
            {
                cellCreatOrder.btnCreatOrder.setTitle(NSLocalizedString("CreatOrder", comment: ""), for: .normal)

            }

            cellCreatOrder.btnCreatOrder.removeTarget(nil, action: nil, for: .allEvents)
            cellCreatOrder.btnCreatOrder.addTarget(self, action: #selector(CreatOrder), for: .touchUpInside)
            return cellCreatOrder
        }
        }
        else if CatId == 10
        {
            
            
            
             if indexPath.section == 0
            {
                if indexPath.row == 0
                {
                    
                    let cellWakalaCat:WkalaCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WkalaCategoryTableViewCell") as UITableViewCell! as! WkalaCategoryTableViewCell
                   
                    
                    if let deliveryLocation:String = ContractOrderDataDic.value(forKey: "delivery") as! String
                    {
                        if deliveryLocation == "home"
                        {
                            cellWakalaCat.SegmentControl.titles = [NSLocalizedString("office", comment: ""),"\(NSLocalizedString("home" , comment: "")) + \(homeDeliveryFee as Int) \(NSLocalizedString("SR" , comment: ""))" ]
                        }
                        else
                        {
                            cellWakalaCat.SegmentControl.titles = [NSLocalizedString("office", comment: ""), NSLocalizedString("home", comment: "")]
                        }
                    }
                    else
                    {
                        cellWakalaCat.SegmentControl.titles = [NSLocalizedString("office", comment: ""), NSLocalizedString("home", comment: "")]
                        
                    }
                    
                    cellWakalaCat.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                    cellWakalaCat.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                    cellWakalaCat.SegmentControl.removeTarget(nil, action: nil, for: .allEvents)
                    cellWakalaCat.SegmentControl.addTarget(self, action: #selector(ContractLocationSegmentedValueChanged(_:)), for: .valueChanged)
                    
                    
                    return cellWakalaCat
                }
                else
                {
                    
                    let cellChooseLocation:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                    cellChooseLocation.btn_OpenDDl.setTitle(NSLocalizedString("ChooseAdreess", comment: ""), for: .normal)
                    cellChooseLocation.img_icon.image = UIImage.init(named: "gps-check")
                    cellChooseLocation.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                    cellChooseLocation.btn_OpenDDl.addTarget(self, action: #selector(OpenlocationDDL), for: .touchUpInside)
                    if let Location : Double =  ContractOrderDataDic.value(forKey: "latitude") as? Double
                    {
                        cellChooseLocation.btn_OpenDDl.setTitle(NSLocalizedString("LocationChoosed", comment: ""), for: .normal)
                        cellChooseLocation.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                        
                    }
                    else
                    {
                        cellChooseLocation.btn_OpenDDl.applybuttonDGrayBorderProperties()
                        
                    }
                    
                    return cellChooseLocation
                    
                }
               
            }
            else if indexPath.section == 1
            {
                    if indexPath.row == 0
                    {
                        
                        let cellMeetingTime:TawkeelMeetingTimeTableViewCell = tableView.dequeueReusableCell(withIdentifier:"TawkeelMeetingTimeTableViewCell") as UITableViewCell! as! TawkeelMeetingTimeTableViewCell
                        cellMeetingTime.SegmentControl.titles = [NSLocalizedString("1Hour", comment: ""), NSLocalizedString("2Hours", comment: ""),NSLocalizedString("3Hours", comment: "")]
                        cellMeetingTime.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                        cellMeetingTime.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                        cellMeetingTime.SegmentControl.removeTarget(nil, action: nil, for: .allEvents)
                        cellMeetingTime.SegmentControl.addTarget(self, action: #selector(ContractMeetingTimeSegmentedValueChanged(_:)), for: .valueChanged)
                        
                        return cellMeetingTime
                        
                    }
                    else
                    {
                        
                        let cellChooseTimeDdl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                        cellChooseTimeDdl.btn_OpenDDl.setTitle(NSLocalizedString("LaterTime", comment: ""), for: .normal)
                        cellChooseTimeDdl.img_icon.image = UIImage.init(named: "time")
                        cellChooseTimeDdl.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                        cellChooseTimeDdl.btn_OpenDDl.addTarget(self, action: #selector(OpenlaterTimeDDL), for: .touchUpInside)
                        if let TimeMowkl : String =  ContractOrderDataDic.value(forKey: "time") as? String
                        {
                            if TimeMowkl == "1 hours" || TimeMowkl == "2 hours" || TimeMowkl == "3 hours"
                            {
                                cellChooseTimeDdl.btn_OpenDDl.setTitle(NSLocalizedString("LaterTime", comment: ""), for: .normal)
                            }
                            else
                            {
                                cellChooseTimeDdl.btn_OpenDDl.setTitle(TimeMowkl, for: .normal)
                            }
                            
                            cellChooseTimeDdl.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                            
                        }
                        else
                        {
                            cellChooseTimeDdl.btn_OpenDDl.applybuttonDGrayBorderProperties()
                            
                        }
                        return cellChooseTimeDdl
                        
                    }
            }
            else
            {
                let cellCreatOrder:CreateOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"CreateOrderTableViewCell") as UITableViewCell! as! CreateOrderTableViewCell
                
                if  self.ArrCat.count > 0
                {
                  
                    let CatObj =  self.ArrCat[1]
                    
                    if let categoryId = ContractOrderDataDic.value(forKey: "categoryId")
                    {
                        if categoryId as! Int  != 1
                        {
                            for var subCat  in CatObj.subs!  {
                                if (subCat as Sub).id  == categoryId as! Int {
                                    cellCreatOrder.btnCreatOrder.setTitle("\(NSLocalizedString("CreatOrder", comment: "")) (\(subCat.cost as! Int) \(NSLocalizedString("SR", comment:"")))", for: .normal)
                                    
                                }
                            }
                        }
                        else
                        {
                            cellCreatOrder.btnCreatOrder.setTitle("\(NSLocalizedString("CreatOrder", comment: "")) (\(CatObj.cost as! Int) \(NSLocalizedString("SR", comment:"")))", for: .normal)
                            
                        }
                    }
                    else
                    {
                        cellCreatOrder.btnCreatOrder.setTitle((NSLocalizedString("CreatOrder", comment: "")), for: .normal)
                    }
                    
                    
                }
                else
                {
                    cellCreatOrder.btnCreatOrder.setTitle(NSLocalizedString("CreatOrder", comment: ""), for: .normal)
                    
                }
                
                cellCreatOrder.btnCreatOrder.removeTarget(nil, action: nil, for: .allEvents)
                cellCreatOrder.btnCreatOrder.addTarget(self, action: #selector(CreatContractOrder), for: .touchUpInside)
                return cellCreatOrder
            }
            
        }
        else
        {
               if indexPath.section == 0
               {
                if indexPath.row == 0
                {
                    
                    let cellWakalaCat:WkalaCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WkalaCategoryTableViewCell") as UITableViewCell! as! WkalaCategoryTableViewCell
                 
                    
                    if let deliveryLocation:String = NekahOrderDataDic.value(forKey: "delivery") as! String
                    {
                        if deliveryLocation == "home"
                        {
                            cellWakalaCat.SegmentControl.titles = [NSLocalizedString("MaazonLocation", comment: ""),"\(NSLocalizedString("ClientLocation" , comment: "")) + \(homeDeliveryFee as Int) \(NSLocalizedString("SR" , comment: ""))" ]
                        }
                        else
                        {
                            cellWakalaCat.SegmentControl.titles = [NSLocalizedString("MaazonLocation", comment: ""), NSLocalizedString("ClientLocation", comment: "")]
                        }
                    }
                    else
                    {
                        cellWakalaCat.SegmentControl.titles = [NSLocalizedString("MaazonLocation", comment: ""), NSLocalizedString("ClientLocation", comment: "")]
                        
                    }
                    
                    
                    
                    cellWakalaCat.SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                    cellWakalaCat.SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
                    cellWakalaCat.SegmentControl.removeTarget(nil, action: nil, for: .allEvents)
                    cellWakalaCat.SegmentControl.addTarget(self, action: #selector(NekahLocationSegmentedValueChanged(_:)), for: .valueChanged)
                    
                    
                    return cellWakalaCat
                }
                else
                {
                    
                    let cellChooseLocation:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                    cellChooseLocation.btn_OpenDDl.setTitle(NSLocalizedString("ChooseAdreess", comment: ""), for: .normal)
                    cellChooseLocation.img_icon.image = UIImage.init(named: "gps-check")
                    cellChooseLocation.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                    cellChooseLocation.btn_OpenDDl.addTarget(self, action: #selector(OpenlocationDDL), for: .touchUpInside)
                    if let Location : Double =  NekahOrderDataDic.value(forKey: "latitude") as? Double
                    {
                        cellChooseLocation.btn_OpenDDl.setTitle(NSLocalizedString("LocationChoosed", comment: ""), for: .normal)
                        cellChooseLocation.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                        
                    }
                    else
                    {
                        cellChooseLocation.btn_OpenDDl.applybuttonDGrayBorderProperties()
                        
                    }
                    
                    return cellChooseLocation
                    
                }
                
            }
            else if indexPath.section == 1
               {
                if indexPath.row == 0
                {
                    let cellChooseTimeDdl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                    cellChooseTimeDdl.btn_OpenDDl.setTitle(NSLocalizedString("Time", comment: ""), for: .normal)
                    cellChooseTimeDdl.img_icon.image = UIImage.init(named: "time")
                    cellChooseTimeDdl.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                    cellChooseTimeDdl.btn_OpenDDl.addTarget(self, action: #selector(OpenlaterTimeDDL), for: .touchUpInside)
                    if let TimeMowkl : String =  NekahOrderDataDic.value(forKey: "marriageTime") as? String
                    {
                        cellChooseTimeDdl.btn_OpenDDl.setTitle(TimeMowkl, for: .normal)
                        cellChooseTimeDdl.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                        
                    }
                    else
                    {
                        cellChooseTimeDdl.btn_OpenDDl.applybuttonDGrayBorderProperties()
                        
                    }
                    return cellChooseTimeDdl
                }
                else
                {
                    let cellChooseTimeDdl:ChooseLocationDropDownTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ChooseLocationDropDownTableViewCell") as UITableViewCell! as! ChooseLocationDropDownTableViewCell
                    cellChooseTimeDdl.btn_OpenDDl.setTitle(NSLocalizedString("Date", comment: ""), for: .normal)
                    cellChooseTimeDdl.img_icon.image = UIImage.init(named: "time")
                    cellChooseTimeDdl.btn_OpenDDl.removeTarget(nil, action: nil, for: .allEvents)
                    cellChooseTimeDdl.btn_OpenDDl.addTarget(self, action: #selector(OpenletterTimeDDL), for: .touchUpInside)
                    if let TimeMowkl : String =  NekahOrderDataDic.value(forKey: "marriageDate") as? String
                    {
                        cellChooseTimeDdl.btn_OpenDDl.setTitle(TimeMowkl, for: .normal)
                        cellChooseTimeDdl.btn_OpenDDl.applybuttonGreenviewBorderProperties()
                        
                    }
                    else
                    {
                        cellChooseTimeDdl.btn_OpenDDl.applybuttonDGrayBorderProperties()
                        
                    }
                    
                    return cellChooseTimeDdl
                }
               }
            else
               {
                let cellCreatOrder:CreateOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"CreateOrderTableViewCell") as UITableViewCell! as! CreateOrderTableViewCell
                if  self.ArrCat.count > 0
                {
                    let CatObj =  self.ArrCat[2]
                    cellCreatOrder.btnCreatOrder.setTitle("\(NSLocalizedString("CreatOrder", comment: "")) (\(CatObj.cost as! Int) \(NSLocalizedString("SR", comment:"")))", for: .normal)
                    
                }
                else
                {
                    cellCreatOrder.btnCreatOrder.setTitle(NSLocalizedString("CreatOrder", comment: ""), for: .normal)
                    
                }
                cellCreatOrder.btnCreatOrder.removeTarget(nil, action: nil, for: .allEvents)
                cellCreatOrder.btnCreatOrder.addTarget(self, action: #selector(CreatNekahOrder), for: .touchUpInside)
                return cellCreatOrder
            }
        }
    }
    
}

extension CreateOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if CatId == 1
        {
           if section == 3
            {
               
                return 5
                
            }
            else
            {
                
               
              return 25
                
            }
        }
        else if CatId == 10
        {
            if section == 2
            {
               
                return 5
                
            }
            else
            {
               
                return 25
                
            }
        }
        else
        {
            if section == 2
            {
                
                return 5
                
            }
            else
            {
                
                return 25
                
            }
        }
        
        
    }
    
  
    
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
            else if section == 3
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
                cellOrderHeader.lbl_Header.text = NSLocalizedString("WekalaDelivery", comment: "")
            }
            else if section == 2
            {
                cellOrderHeader.lbl_Header.text = NSLocalizedString("datingTime", comment: "")

            }
            
            return cellOrderHeader
        }
        }
        else if CatId == 10
        {
            if section == 0
            {
                let cellOrderHeader:OrderHeader = tableView.dequeueReusableCell(withIdentifier:"OrderHeader") as UITableViewCell! as! OrderHeader
                cellOrderHeader.lbl_Header.text = NSLocalizedString("ContractDelivery", comment: "")
                return cellOrderHeader
            }
            else if section == 2
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
                    cellOrderHeader.lbl_Header.text = NSLocalizedString("datingTime", comment: "")
                }
                
                return cellOrderHeader

            }
        }
        else
        {
            if section == 0
            {
                let cellOrderHeader:OrderHeader = tableView.dequeueReusableCell(withIdentifier:"OrderHeader") as UITableViewCell! as! OrderHeader
                cellOrderHeader.lbl_Header.text = NSLocalizedString("ContractDelivery", comment: "")
                return cellOrderHeader
            }
            else if section == 2
            {
                let cellOrderHeader:OrderHeader = tableView.dequeueReusableCell(withIdentifier:"OrderHeader") as UITableViewCell! as! OrderHeader
                cellOrderHeader.lbl_Header.isHidden = true
                return cellOrderHeader
                
            }
            else
            {
                
                let cellOrderHeader:OrderSectionHeader = tableView.dequeueReusableCell(withIdentifier:"OrderSectionHeader") as UITableViewCell! as! OrderSectionHeader
                    cellOrderHeader.lbl_Header.text = NSLocalizedString("DocumentMarriageMessage", comment: "")
                return cellOrderHeader
            }
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
        
        if CatId == 1
        {
        if section == 1
        {
            self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 90), animated: true)
       
        }
        else
        {
            self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 150), animated: true)

        }
        }
        else
        {
            self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 120), animated: true)

        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        self.tblOrder.setContentOffset(CGPoint(x: self.tblOrder.contentOffset.x, y: 0), animated: true)
        if textField.text?.length == 0
        {
            textField.applyDGrayBorderProperties()

        }
        let  row = textField.tag % 1000
        let  section = textField.tag / 1000
        if CatId == 1
        {
        
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
        
        self.RemovedataPickerView()
        
    }
    
    
    func DidUserChoosedItem(_ ChoosedItem : NSDictionary){
        
        if CatId == 1
            {
        TawkeelOrderDataDic.setValue(ChoosedItem.value(forKey: "id"), forKey: "categoryId")
        var key = "Name_EN"
        if Language.getCurrentLanguage() == Constants.Language.ARABIC {
            key = "Name"
        }
        
        TawkeelOrderDataDic.setValue(ChoosedItem.value(forKey: key), forKey: "SefaCategoryName")
        }
        else if CatId == 10
        {
            ContractOrderDataDic.setValue(ChoosedItem.value(forKey: "id"), forKey: "categoryId")
            
            var key = "Name_EN"
            if Language.getCurrentLanguage() == Constants.Language.ARABIC {
                key = "Name"
            }
            
            ContractOrderDataDic.setValue(ChoosedItem.value(forKey: key), forKey: "SubCategoryName")
        }
        
        self.tblOrder.reloadData()
        self.RemovedataPickerView()
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

    func readPlistSubContractsCategories() -> NSArray{
        let fileName = "ContractsSubCategories"
        let data =  (self as PlistReaderProtocol).readPlist(fileName: fileName)
        return data as! NSArray
    }

}

extension CreateOrderViewController: PickerTimeDelegate {
    
    func DidUserCancelChoosingTime() {
        
        self.RemoveTimePickerView()
        
    }
    
    func DidUserChoosedTime(_ ChoosedDate : String){
        if CatId == 1
        {
        TawkeelOrderDataDic.setValue(ChoosedDate, forKey: "time")
        }
        else if CatId == 10
        {
            ContractOrderDataDic.setValue(ChoosedDate, forKey: "time")

        }
        else
        {
            NekahOrderDataDic.setValue(ChoosedDate, forKey: "marriageTime")

        }
        self.RemoveTimePickerView()
        self.tblOrder.reloadData()
    }
}

extension CreateOrderViewController: PickerDateDelegate {
    
    func DidUserCancelChoosingDate() {
        
        self.RemovedatePickerView()
        
    }
    
    
    func DidUserChoosedDate(_ ChoosedDate : String){
        
        if CatId == 10
        {
            ContractOrderDataDic.setValue(ChoosedDate, forKey: "letterDate")

        }
        else
        {
            NekahOrderDataDic.setValue(ChoosedDate, forKey: "marriageDate")

        }
        self.RemovedatePickerView()
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

extension UIButton {
    func applybuttonGreenviewBorderProperties() {
        layer.borderWidth = 1
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 6.0
    }
    
    func applybuttonDGrayBorderProperties() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.manatee1.cgColor
        layer.cornerRadius = 6.0
    }
}


