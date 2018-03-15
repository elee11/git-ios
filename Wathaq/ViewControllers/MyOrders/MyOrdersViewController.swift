//
//  MyOrdersViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import SwifterSwift
import Kingfisher
import DZNEmptyDataSet
import ESPullToRefresh





class MyOrdersViewController: UIViewController,ToastAlertProtocol {

  
    var SegmentControl: BetterSegmentedControl!
    @IBOutlet weak var SegmentControlContainer: UIView!

    var viewModel: OrderViewModel!
    var newPageNum : Int!
    var PendingPageNum : Int!
    var ClosedPageNum : Int!
    
    var IsNewOrderDataFirstLoading : Bool!
    var IsPendingOrderDataFirstLoading : Bool!
    var IsClosedOrderDataFirstLoading : Bool!

    var ArrNewOrdersCat :[Orderdata]!
    var ArrPendingOrdersCat :[Orderdata]!
    var ArrClosedOrdersCat :[Orderdata]!

    
    var isNewData : Bool!
    var isPendingData : Bool!
    var IsClosedData : Bool!
    
    var PendingStopLoadMore = false
    var closedStopLoadMore = false
    var NewStopLoadMore = false
    
    var ErrorStr : String!

    
    @IBOutlet weak var tbl_Orders: UITableView!







    override func viewDidLoad() {
        super.viewDidLoad()
        self.addInfiniteScrolling()

        ArrNewOrdersCat = [Orderdata]()
        ArrPendingOrdersCat = [Orderdata]()
        ArrClosedOrdersCat = [Orderdata]()
        
        IsNewOrderDataFirstLoading = true
        IsPendingOrderDataFirstLoading = true
        IsClosedOrderDataFirstLoading = true
        
        self.ErrorStr = ""


        
        isNewData = true
        
        viewModel = OrderViewModel()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
       self.title = NSLocalizedString("myOrders", comment: "")
       self.adjustSegmentControl()
        newPageNum = 1
        PendingPageNum = 1
        ClosedPageNum = 1
        self.getNewOrdersWithPageNum(newPageNum)
        }
    
    
    func addInfiniteScrolling(){
        self.tbl_Orders.es.addInfiniteScrolling {
            [unowned self] in
            if self.isNewData == true
            {
                if self.NewStopLoadMore == false
                {
                    self.newPageNum = self.newPageNum + 1
                    self.getNewOrdersWithPageNum(self.newPageNum)
                }
                else
                {
                    self.tbl_Orders.es.stopLoadingMore()
                    
                }
                
            }
            else if self.isPendingData == true
            {
                if self.PendingStopLoadMore == false
                {
                    self.PendingPageNum = self.PendingPageNum + 1
                    self.getPendingOrdersWithPageNum(self.PendingPageNum)
                }
                else
                {
                    self.tbl_Orders.es.stopLoadingMore()
                    
                }
                
            }
            else
            {
                
                if self.closedStopLoadMore == false
                {
                    self.ClosedPageNum = self.ClosedPageNum + 1
                    self.getClosedOrdersWithPageNum(self.ClosedPageNum)
                }
                else
                {
                    self.tbl_Orders.es.stopLoadingMore()
                    
                }
                
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newPageNum = 1
        self.getNewOrdersWithPageNum(newPageNum)

    }
    
    
    func adjustSegmentControl ()
    {
        SegmentControl = BetterSegmentedControl(
            frame: CGRect(x: (self.navigationController?.navigationBar.center.x)! - ((self.navigationController?.navigationBar.width)! - 30)/2 , y: 5, width: (self.navigationController?.navigationBar.width)! - 30 , height: 41),
            titles: [NSLocalizedString("finished", comment: ""), NSLocalizedString("opened", comment: ""), NSLocalizedString("new", comment: "")],
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
        self.SegmentControlContainer.addSubview(SegmentControl)
        
       
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.getClosedOrdersWithPageNum(ClosedPageNum)
            isNewData = false
            isPendingData = false
            IsClosedData = true
        }
        else if sender.index == 1  {
            self.getPendingOrdersWithPageNum(PendingPageNum)
            isNewData = false
            isPendingData = true
            IsClosedData = false
        }
        else
        {
            isNewData = true
            isPendingData = false
            IsClosedData = false
            self.getNewOrdersWithPageNum(newPageNum)
            
        }
    }
    
    
    func getNewOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getNewOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""
                self.IsNewOrderDataFirstLoading = false
                
                if self.newPageNum == 1
                {
                    self.ArrNewOrdersCat = OrderObj?.data
                    if self.ArrNewOrdersCat == nil
                    {
                        self.ArrNewOrdersCat = [Orderdata]()
                    }
                }
                else
                {
                    if let  ArrMorenewRequests = OrderObj?.data
                    {
                        self.ArrNewOrdersCat = self.ArrNewOrdersCat + ArrMorenewRequests
                    }
                    else
                    {
                        self.tbl_Orders.es.stopLoadingMore()
                        self.NewStopLoadMore = true
                    }
                }
                
                
                self.tbl_Orders.reloadData()
                self.tbl_Orders.es.stopLoadingMore()

                
            } else{
                self.ErrorStr = errorMsg
                self.IsNewOrderDataFirstLoading = false
                self.tbl_Orders.reloadData()

                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    func getPendingOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getPendingOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""

                self.IsPendingOrderDataFirstLoading = false
                
                if self.PendingPageNum == 1
                {
                    self.ArrPendingOrdersCat = OrderObj?.data
                    if self.ArrPendingOrdersCat == nil
                    {
                        self.ArrPendingOrdersCat = [Orderdata]()
                    }
                }
                else
                {
                    if let  ArrMorependingRequests = OrderObj?.data
                    {
                        self.ArrPendingOrdersCat = self.ArrPendingOrdersCat + ArrMorependingRequests
                    }
                    else
                    {
                        self.tbl_Orders.es.stopLoadingMore()
                        self.PendingStopLoadMore = true
                    }
                }
                
                
                self.tbl_Orders.reloadData()
                self.tbl_Orders.es.stopLoadingMore()
                
            } else{
                self.ErrorStr = errorMsg
                self.IsPendingOrderDataFirstLoading = false
                self.tbl_Orders.reloadData()

                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    func getClosedOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getClosedOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""
                
                self.IsClosedOrderDataFirstLoading = false
                
                
                if self.ClosedPageNum == 1
                {
                    self.ArrClosedOrdersCat = OrderObj?.data
                    if self.ArrClosedOrdersCat == nil
                    {
                        self.ArrClosedOrdersCat = [Orderdata]()
                    }
                }
                else
                {
                    if let  ArrMoreClosedRequests = OrderObj?.data
                    {
                        self.ArrClosedOrdersCat = self.ArrClosedOrdersCat + ArrMoreClosedRequests
                    }
                    else
                    {
                        self.tbl_Orders.es.stopLoadingMore()
                        self.closedStopLoadMore = true
                    }
                }
                
                self.tbl_Orders.reloadData()
                self.tbl_Orders.es.stopLoadingMore()
                
                
            } else{
                self.ErrorStr = errorMsg
                self.IsClosedOrderDataFirstLoading = false
                self.tbl_Orders.reloadData()

                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    override  func viewDidLayoutSubviews() {
      

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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Orders_Lawyers"  {
            let chooseLawyerView = segue.destination as! ChooseLawyerViewController
            chooseLawyerView.OrderObj = sender as! Orderdata
        }
        else  if segue.identifier == "S_MyOrders_Chat"  {
            let OrderObj = sender as!  Orderdata
            let chatViewController = segue.destination as! ChatVC
            chatViewController.OrderObj = OrderObj
            chatViewController.MoawtheqObj = OrderObj.lawyer
        }
    }
}

extension MyOrdersViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isNewData == true
        {
            if IsNewOrderDataFirstLoading == true
            {
                return 5
            }
            else
            {
            return ArrNewOrdersCat.count
            }
        }
        else if isPendingData == true
        {
            if IsPendingOrderDataFirstLoading == true
            {
                return 5
            }
            else
            {
            return ArrPendingOrdersCat.count
            }
        }
        else
        {
            if IsClosedOrderDataFirstLoading == true
            {
                return 5
            }
            else
            {
            return  ArrClosedOrdersCat.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if isNewData == true
        {
            if IsNewOrderDataFirstLoading == true
            {
                        let cellLoader:MyOrderPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderPlaceHolderTableViewCell") as UITableViewCell! as! MyOrderPlaceHolderTableViewCell
                
                        cellLoader.gradientLayers.forEach { gradientLayer in
                            let baseColor = cellLoader.lblLawerName.backgroundColor!
                            gradientLayer.colors = [baseColor.cgColor,
                                                    baseColor.brightened(by: 0.93).cgColor,
                                                    baseColor.cgColor]
                            gradientLayer.slide(to: .right)
                        }
                        return cellLoader
                
            }
            else
            {
                
                
                let cellOrderCell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderTableViewCell") as UITableViewCell! as! MyOrderTableViewCell
                
                let ObjOrder =  self.ArrNewOrdersCat[indexPath.row]

                cellOrderCell.lblOrderStatus.text = " \(ObjOrder.category?.discription as! String) "
                cellOrderCell.lblLawerName.text = NSLocalizedString("new order", comment: "")

                cellOrderCell.lblServiceNum.text = "\(NSLocalizedString("OrderNumber", comment: "") as String) \(ObjOrder.id as! Int)"
                
                let date = Date(unixTimestamp: Double(ObjOrder.createdAt!))

                
                if Int(Date().daysSince(date)) == 0
                {
                    
                    cellOrderCell.LblOrderTime.text = "\(Int(Date().hoursSince (date))) \(NSLocalizedString("Hoursago", comment: ""))"
                    
                }
                else
                {
                    cellOrderCell.LblOrderTime.text = "\(Int(Date().daysSince(date))) \(NSLocalizedString("DaysAgo", comment: ""))"
                    
                }
                if let url = ObjOrder.lawyer?.image
                {
                    let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
                    cellOrderCell.imgLawyer.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "ic_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                else
                {
                    cellOrderCell.imgLawyer.kf.setImage(with: nil, placeholder: UIImage.init(named: "ic_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                
                
                return cellOrderCell
            }
        }
        else if isPendingData == true
        {
            if IsPendingOrderDataFirstLoading == true
            {
                let cellLoader:MyOrderPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderPlaceHolderTableViewCell") as UITableViewCell! as! MyOrderPlaceHolderTableViewCell
                
                cellLoader.gradientLayers.forEach { gradientLayer in
                    let baseColor = cellLoader.lblLawerName.backgroundColor!
                    gradientLayer.colors = [baseColor.cgColor,
                                            baseColor.brightened(by: 0.93).cgColor,
                                            baseColor.cgColor]
                    gradientLayer.slide(to: .right)
                }
                return cellLoader
                
            }
            else
            {
                
                let cellOrderCell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderTableViewCell") as UITableViewCell! as! MyOrderTableViewCell
                let ObjOrder =  self.ArrPendingOrdersCat[indexPath.row]

                cellOrderCell.lblLawerName.text = ObjOrder.lawyer?.name
                cellOrderCell.lblOrderStatus.text = " \(ObjOrder.category?.discription as! String) "
                cellOrderCell.lblServiceNum.text = "\(NSLocalizedString("OrderNumber", comment: "") as String) \(ObjOrder.id as! Int)"
                
                let date = Date(unixTimestamp: Double(ObjOrder.createdAt!))
                
                if Int(Date().daysSince(date)) == 0
                {
                    
                    cellOrderCell.LblOrderTime.text = "\(Int(Date().hoursSince (date))) \(NSLocalizedString("Hoursago", comment: ""))"
                    
                }
                else
                {
                    cellOrderCell.LblOrderTime.text = "\(Int(Date().daysSince(date))) \(NSLocalizedString("DaysAgo", comment: ""))"
                    
                }
                
                if let url = ObjOrder.lawyer?.image
                {
                    let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
                    cellOrderCell.imgLawyer.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "ic_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                else
                {
                    cellOrderCell.imgLawyer.kf.setImage(with: nil, placeholder: UIImage.init(named: "ic_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                return cellOrderCell
            }
        }
        else
        {
            if IsClosedOrderDataFirstLoading == true
            {
            let cellLoader:MyOrderPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderPlaceHolderTableViewCell") as UITableViewCell! as! MyOrderPlaceHolderTableViewCell
    
               cellLoader.gradientLayers.forEach { gradientLayer in
             let baseColor = cellLoader.lblLawerName.backgroundColor!
            gradientLayer.colors = [baseColor.cgColor,
           baseColor.brightened(by: 0.93).cgColor,
         baseColor.cgColor]
           gradientLayer.slide(to: .right)
           }
        return cellLoader
    
              }
         else
        {
    
    let cellOrderCell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderTableViewCell") as UITableViewCell! as! MyOrderTableViewCell
            
            let ObjOrder =  self.ArrClosedOrdersCat[indexPath.row]

            cellOrderCell.lblLawerName.text = ObjOrder.lawyer?.name
            cellOrderCell.lblOrderStatus.text = " \(ObjOrder.category?.discription as! String) "
            cellOrderCell.lblServiceNum.text = "\(NSLocalizedString("OrderNumber", comment: "") as String) \(ObjOrder.id as! Int)"
            
            let date = Date(unixTimestamp: Double(ObjOrder.createdAt!))
            
            if Int(Date().daysSince(date)) == 0
            {
                
                cellOrderCell.LblOrderTime.text = "\(Int(Date().hoursSince (date))) \(NSLocalizedString("Hoursago", comment: ""))"
                
            }
            else
            {
                cellOrderCell.LblOrderTime.text = "\(Int(Date().daysSince(date))) \(NSLocalizedString("DaysAgo", comment: ""))"
                
            }
            
            if let url = ObjOrder.lawyer?.image
            {
                let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
                cellOrderCell.imgLawyer.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "ic_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            else
            {
                cellOrderCell.imgLawyer.kf.setImage(with: nil, placeholder: UIImage.init(named: "ic_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
          return cellOrderCell
    
         }
     }
        
  }
    
}

extension MyOrdersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        if isNewData == true
        {
            let ObjOrder =  self.ArrNewOrdersCat[indexPath.row]
            self.performSegue(withIdentifier: "S_Orders_Lawyers", sender: ObjOrder)

        }
        else if isPendingData == true
        {
            let ObjOrder =  self.ArrPendingOrdersCat[indexPath.row]
            self.performSegue(withIdentifier: "S_MyOrders_Chat", sender: ObjOrder)

        }
        else
        {
            let ObjOrder =  self.ArrClosedOrdersCat[indexPath.row]
            self.performSegue(withIdentifier: "S_MyOrders_Chat", sender: ObjOrder)

        }
    }
}

extension MyOrdersViewController:DZNEmptyDataSetSource
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
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No Orders", comment: ""))
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

extension MyOrdersViewController:DZNEmptyDataSetDelegate
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
        if isNewData == true {
            newPageNum = 1
            isNewData = true
            isPendingData = false
            IsClosedData = false
            self.getNewOrdersWithPageNum(newPageNum)
        }
        else if isPendingData == true  {
            PendingPageNum = 1
            self.getPendingOrdersWithPageNum(PendingPageNum)
            isNewData = false
            isPendingData = true
            IsClosedData = false
        }
        else
        {
            ClosedPageNum = 1
            self.getClosedOrdersWithPageNum(ClosedPageNum)
            isNewData = false
            isPendingData = false
            IsClosedData = true
        }    }
}


