//
//  WatheqViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase
import DAKeychain



class WatheqViewController: AbstractViewController,ToastAlertProtocol {
    var catViewModel: CategoriesViewModel!
    var ArrCat :[CatObject]!
    var ErrorStr : String!
    var IsDataFirstLoading : Bool!
    var viewModel: UserViewModel!


    @IBOutlet weak var tbl_Categories: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        self.checktoRegisterDeviceToken()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            self.tbl_Categories.rowHeight = UITableViewAutomaticDimension
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
        ArrCat = [CatObject]()
        catViewModel = CategoriesViewModel()
        IsDataFirstLoading = true
//        getWkalataCategories()

        
        self.title = NSLocalizedString("watheq", comment: "")
        self.tabBarItem.title = NSLocalizedString("watheq", comment: "")
        self.ErrorStr = ""

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
        
        let values = ["displayName": userObj?.name, "email": userObj?.email, "instanceId": FBToken, "uid" :"\(userObj!.userID as! Int)","device":"ios"]
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
    
//    func getWkalataCategories()
//    {
//        catViewModel.GetCategories { (wkalatTypeObj, errorMsg) in
//            if errorMsg == nil {
//                self.ErrorStr = ""
//                self.IsDataFirstLoading = false
//                if let arrCatData = wkalatTypeObj?.categories
//                {
//                    self.ArrCat = arrCatData as [CatObject]
//                }
//                else
//                {
//                     self.ArrCat = [CatObject]()
//                }
//
//                self.tbl_Categories.reloadData()
//
//            } else{
//                self.ErrorStr = errorMsg
//                self.IsDataFirstLoading = false
//
//                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
//                self.tbl_Categories.reloadData()
//
//
//
//            }
//        }
//    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "WatheqCat_SubCat"  {
                    let CatObj = sender as!  CatObject
                    let SubCatDetails = segue.destination as! WatheqSubCatViewController
                    SubCatDetails.title = CatObj.name
                    SubCatDetails.ArrSubCat = CatObj.subs
              }
                else if segue.identifier == "S_Watheq_MaazonLocation"  {
                    let CatObj = sender as!  CatObject
                    let maazonLocation = segue.destination as! ChooseMaazonLocationViewController
                    maazonLocation.CatObj = CatObj
        }
    }

}

extension WatheqViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if IsDataFirstLoading == true
        {
            return 3
        }
        else
        {
            return ArrCat.count
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if IsDataFirstLoading == true
        {
            let cellLoader:WatheqPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WatheqPlaceHolderTableViewCell") as UITableViewCell! as! WatheqPlaceHolderTableViewCell
            
            cellLoader.gradientLayers.forEach { gradientLayer in
                let baseColor = cellLoader.lbl_CatPlaceholderView.backgroundColor!
                gradientLayer.colors = [baseColor.cgColor,
                                        baseColor.brightened(by: 0.93).cgColor,
                                        baseColor.cgColor]
                gradientLayer.slide(to: .right)
            }
            return cellLoader
        }
        else
        {
        let cellWatheqCat:WatheqTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WatheqTableViewCell") as UITableViewCell! as! WatheqTableViewCell
        let CatObj =  self.ArrCat[indexPath.row]
        cellWatheqCat.lblCatName.text = CatObj.name
        cellWatheqCat.lblCatDesc.text = CatObj.discription
        return cellWatheqCat
        }
    }
    
}

extension WatheqViewController: UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IsDataFirstLoading == true
        {
            return self.view.frame.size.height * 0.24
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if IsDataFirstLoading == false
        {
            let CatObj =  self.ArrCat[indexPath.row]
            if CatObj.hasSubs == true{
                self.performSegue(withIdentifier: "WatheqCat_SubCat", sender: CatObj)
            }
            else
            {
                self.performSegue(withIdentifier: "S_Watheq_MaazonLocation", sender: CatObj)
  
            }
        }
    }
  
    
}

extension WatheqViewController:DZNEmptyDataSetSource
{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let myMutableString = NSMutableAttributedString()
        
        if ErrorStr == NSLocalizedString("No_Internet", comment: "")
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("NoInternetConnection", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            var myMutableString2 = NSMutableAttributedString()
            myMutableString2 = NSMutableAttributedString(string: NSLocalizedString("ReconnectToInternet", comment: ""))
            myMutableString2.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor(red: 16 / 255.0, green: 16 / 255.0, blue: 16 / 255.0, alpha: 1.0)], range: NSRange(location:0,length:myMutableString2.length)) // What ever range you want to give
            
            
            myMutableString.append(myMutableString1)
            myMutableString.append(NSAttributedString(string: "\n"))
            myMutableString.append(myMutableString2)
            
            
        }
        else if ErrorStr == NSLocalizedString("SERVER_ERROR", comment: "")
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("SERVER_ERROR", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font :UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            var myMutableString2 = NSMutableAttributedString()
            
            myMutableString2 = NSMutableAttributedString(string: NSLocalizedString("TryAgainLater", comment: ""))
            myMutableString2.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor(red: 16 / 255.0, green: 16 / 255.0, blue: 16 / 255.0, alpha: 1.0)], range: NSRange(location:0,length:myMutableString2.length)) // What ever range you want to give
            
            myMutableString.append(myMutableString1)
            myMutableString.append(NSAttributedString(string: "\n"))
            myMutableString.append(myMutableString2)
            
            
        }
        else
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No Categiories", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font :UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            myMutableString.append(myMutableString1)
            
        }
        return myMutableString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        if ErrorStr == NSLocalizedString("No_Internet", comment: "") || ErrorStr == NSLocalizedString("SERVER_ERROR", comment: "")
        {
            return UIImage(named:"EmptyData_NoInternet")
        }
        else
        {
            return UIImage(named:"EmptyData_OrdersEmpty")
        }
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation!
    {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = NSValue(caTransform3D:CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1))
        animation.duration = 5
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.clear
    }
    
}

extension WatheqViewController:DZNEmptyDataSetDelegate
{
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool
    {
        return true
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool
    {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool
    {
        return false
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!)
    {
       // getWkalataCategories()
    }
}

extension UIColor {
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}


