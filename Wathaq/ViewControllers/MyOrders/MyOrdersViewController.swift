//
//  MyOrdersViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import BetterSegmentedControl


class MyOrdersViewController: UIViewController,ToastAlertProtocol {

  
    @IBOutlet weak var SegmentControl: BetterSegmentedControl!
    var viewModel: OrderViewModel!
    var newPageNum : Int!
    var PendingPageNum : Int!
    var ClosedPageNum : Int!



    override func viewDidLoad() {
        super.viewDidLoad()
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
       // self.getNewOrdersWithPageNum(newPageNum)
        }
    
    
    func adjustSegmentControl ()
    {
        SegmentControl.titles = [NSLocalizedString("new", comment: ""), NSLocalizedString("opened", comment: ""), NSLocalizedString("finished", comment: "")]
        SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
        SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
        SegmentControl.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NWConnectivityDidChangeCalled) , name: .NWConnectivityDidChange, object: nil)
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.getNewOrdersWithPageNum(newPageNum)
        }
        else if sender.index == 1  {
            self.getPendingOrdersWithPageNum(PendingPageNum)
        }
        else
        {
            self.getClosedOrdersWithPageNum(ClosedPageNum)
        }
    }
    
    
    func getNewOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getNewOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                
                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    func getPendingOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getPendingOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                
                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    func getClosedOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getClosedOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                
                
            } else{
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyOrdersViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
//        let cellLoader:MyOrderPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderPlaceHolderTableViewCell") as UITableViewCell! as! MyOrderPlaceHolderTableViewCell
//
//        cellLoader.gradientLayers.forEach { gradientLayer in
//            let baseColor = cellLoader.lblLawerName.backgroundColor!
//            gradientLayer.colors = [baseColor.cgColor,
//                                    baseColor.brightened(by: 0.93).cgColor,
//                                    baseColor.cgColor]
//            gradientLayer.slide(to: .right)
//        }
//        return cellLoader
     
            let cellOrderCell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderTableViewCell") as UITableViewCell! as! MyOrderTableViewCell

            return cellOrderCell
    }
    
}

extension MyOrdersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.24
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    
}

