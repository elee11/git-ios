//
//  ChooseLawyerViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/15/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import Kingfisher
import TransitionButton
import DZNEmptyDataSet



class ChooseLawyerViewController: UIViewController,ToastAlertProtocol {


    var OrderObj : OrderRootClass!
    var viewModel: OrderViewModel!
    var ArrLawyers :[MowatheqData]!
    @IBOutlet weak var tbl_Lawyers: UITableView!
    var IsDataFirstLoading : Bool!

    var ErrorStr : String!



    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ErrorStr = ""

        //Remove back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.title = NSLocalizedString("ChooseMowtheq", comment: "")
        IsDataFirstLoading = true
        viewModel = OrderViewModel()
        ArrLawyers = [MowatheqData]()

        self.getlawyerList()

        // Do any additional setup after loading the view.
    }
    
    func getlawyerList ()
    {
        viewModel.getLawyerList(OrderId: OrderObj.Orderdata?.id as! Int, completion: { (lawerRootClass, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""

                self.ArrLawyers = lawerRootClass?.mowatheqData
                self.IsDataFirstLoading = false
                self.tbl_Lawyers.reloadData()

                
            } else{
                self.ErrorStr = errorMsg
                self.IsDataFirstLoading = false

                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                self.IsDataFirstLoading = false

            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authorizeMoawtheq (_ sender :Any)
    {
        let Tag = (sender as AnyObject).tag

        let ObjLawyer =  self.ArrLawyers[Tag!] as MowatheqData

        let TranstBtn:TransitionButton =  sender as! TransitionButton
        TranstBtn.startAnimation()
        viewModel.selectLawyer(OrderId: OrderObj.Orderdata?.id as! Int, lawyerid: ObjLawyer.id as! Int, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                if OrderObj?.code == 200
                {
                TranstBtn.stopAnimation()
                self.view.isUserInteractionEnabled = true
                self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
                else
                {
                    self.showToastMessage(title:(OrderObj?.message!)! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    TranstBtn.stopAnimation()

                }
                
//                self.performSegue(withIdentifier: "S_Request_SearchingLawyer", sender:OrderObj)
                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                TranstBtn.stopAnimation()
                self.view.isUserInteractionEnabled = true
            }
        })
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

extension ChooseLawyerViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if IsDataFirstLoading == true
        {
            return 3
        }
        else
        {
            return ArrLawyers.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if IsDataFirstLoading == true
        {
            let cellLoader:lawyercellPlaceholder = tableView.dequeueReusableCell(withIdentifier:"lawyercellPlaceholder") as UITableViewCell! as! lawyercellPlaceholder
            
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
            let cellLawyer:LawyerTableViewCell = tableView.dequeueReusableCell(withIdentifier:"LawyerTableViewCell") as UITableViewCell! as! LawyerTableViewCell
            let ObjLawyer =  self.ArrLawyers[indexPath.row]
           
            cellLawyer.lbl_mowatheqName.text = ObjLawyer.name
            //cellLawyer.lbl_mowatheqRate.text = ObjLawyer
            
            if let url = ObjLawyer.image
            {
                let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
                cellLawyer.imgLawyer.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            else
            {
                cellLawyer.imgLawyer.kf.setImage(with: nil, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            cellLawyer.btnFawd.setTitle(NSLocalizedString("fawd", comment: ""), for: .normal)
            cellLawyer.btnFawd.tag = indexPath.row
            cellLawyer.btnFawd.addTarget(self, action: #selector(authorizeMoawtheq), for: .touchUpInside)
            
            return cellLawyer
        }
    }
    
}

extension ChooseLawyerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if IsDataFirstLoading == false
        {
            
        }
    }
    
    
}

extension ChooseLawyerViewController:DZNEmptyDataSetSource
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
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No moawtheq now", comment: ""))
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

extension ChooseLawyerViewController:DZNEmptyDataSetDelegate
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
        getlawyerList()
    }
}
