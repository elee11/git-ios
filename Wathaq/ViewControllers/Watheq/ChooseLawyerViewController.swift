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



class ChooseLawyerViewController: UIViewController,ToastAlertProtocol {


    var OrderObj : OrderRootClass!
    var viewModel: OrderViewModel!
    var ArrLawyers :[MowatheqData]!
    @IBOutlet weak var tbl_Lawyers: UITableView!
    var IsDataFirstLoading : Bool!




    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.ArrLawyers = lawerRootClass?.mowatheqData
                self.IsDataFirstLoading = false
                self.tbl_Lawyers.reloadData()

                
            } else{
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
