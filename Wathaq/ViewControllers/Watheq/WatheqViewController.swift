//
//  WatheqViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class WatheqViewController: AbstractViewController,ToastAlertProtocol {
    var catViewModel: CategoriesViewModel!
    var ArrCat :[Category]!
    var ErrorStr : String!

    @IBOutlet weak var tbl_Categories: UITableView!



    override func viewDidLoad() {
        super.viewDidLoad()
        ArrCat = [Category]()
        catViewModel = CategoriesViewModel()
        getWkalataCategories()
        tbl_Categories.estimatedRowHeight = self.view.frame.size.height * 0.42
        tbl_Categories.rowHeight = UITableViewAutomaticDimension
        self.title = NSLocalizedString("watheq", comment: "")
        self.tabBarItem.title = NSLocalizedString("watheq", comment: "")
        self.ErrorStr = ""

       // AbstractViewController.showMessage(title: "No Internet Connection", body: "", isWindowNeeded: false, BackgroundColor: UIColor.black, foregroundColor: UIColor.white)

        // Do any additional setup after loading the view.
    }
    override  func viewDidLayoutSubviews() {
       self.customizeTabBarLocal()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }

    }
    
    func getWkalataCategories()
    {
        catViewModel.GetCategories { (wkalatTypeObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""
                self.ArrCat = wkalatTypeObj?.categories
                self.tbl_Categories.reloadData()
                
            } else{
                self.ErrorStr = errorMsg

                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                self.tbl_Categories.reloadData()

             
            }
        }
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

extension WatheqViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return ArrCat.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellWatheqCat:WatheqTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WatheqTableViewCell") as UITableViewCell! as! WatheqTableViewCell
        let CatObj =  self.ArrCat[indexPath.row]
        cellWatheqCat.lblCatName.text = CatObj.name
        cellWatheqCat.lblCatDesc.text = CatObj.discription
        return cellWatheqCat
    }
    
}

extension WatheqViewController: UITableViewDelegate {
    
    
  
    
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
        return myMutableString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        if ErrorStr == NSLocalizedString("No_Internet", comment: "") || ErrorStr == NSLocalizedString("SERVER_ERROR", comment: "")
        {
            return UIImage(named:"EmptyData_NoInternet")
            
        }
        else
        {
            return UIImage(named:"empty_home")
            
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
        getWkalataCategories()
    }
}



