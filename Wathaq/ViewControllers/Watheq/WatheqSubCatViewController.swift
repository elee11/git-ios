//
//  WatheqSubCatViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/7/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class WatheqSubCatViewController: UIViewController {
    var ArrSubCat :[Sub]!
    var DeliveryLocationTitle : String!
    @IBOutlet weak var tbl_SubCategories: UITableView!
    @IBOutlet weak var viewContainerProgressBar: UIView!
    var horizontalProgressView : HorizontalProgressView!



    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTitleView()
    }
    
    func configureTitleView() {
        
        horizontalProgressView = HorizontalProgressView.init()
        horizontalProgressView.frame = CGRect(x: 0, y: 0, width: self.viewContainerProgressBar.frame.size.width, height: self.viewContainerProgressBar.frame.size.height)
        horizontalProgressView.progressLevelArray = [" ", " ", " ", " ", " "," "];
        horizontalProgressView.lineMaxHeight = 20;
        horizontalProgressView.pointMaxRadius = 0;
        horizontalProgressView.currentLevel = 1;
        horizontalProgressView.achievedColor = UIColor.LightGreen
        horizontalProgressView.unachievedColor = UIColor.ashGrey
        horizontalProgressView.animationDuration = 1;
        horizontalProgressView.textPosition = .topPostion
        viewContainerProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
        self.viewContainerProgressBar.addSubview(horizontalProgressView)

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        horizontalProgressView.startAnimation()
    }
    
    override func viewDidLayoutSubviews() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_SubCat_Mawkl"  {
            let OrderDic = sender as!  NSMutableDictionary
            let MawklView = segue.destination as! MawklViewController
            MawklView.OrderDataDic = OrderDic
        }
        else if segue.identifier == "S_Sub_Letter"  {
            let OrderDic = sender as!  NSMutableDictionary
            let letterView = segue.destination as! LetterViewController
            letterView.OrderDataDic = OrderDic
        }
        else if segue.identifier == "S_SubCat_DeliveryLocation"
        {
            let OrderDic = sender as!  NSMutableDictionary
            let DeliveryLocationView = segue.destination as! DeliveryLocationViewController
            DeliveryLocationView.title = DeliveryLocationTitle
            DeliveryLocationView.OrderDataDic = OrderDic
        }
    }

}

extension WatheqSubCatViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ArrSubCat.count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            let cellWatheqCat:WatheqTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WatheqTableViewCell") as UITableViewCell! as! WatheqTableViewCell
            let subCatObj =  self.ArrSubCat[indexPath.row]
            cellWatheqCat.lblCatName.text = subCatObj.name
            cellWatheqCat.lblCatDesc.text = subCatObj.discription
            return cellWatheqCat
        }
    
}

extension WatheqSubCatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SubObj =  self.ArrSubCat[indexPath.row]
        if SubObj.hasSubs == true{
            let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let WatheqSubCatViewController = MainStoryBoard.instantiateViewController(withIdentifier: "WatheqSubCatViewController")   as! WatheqSubCatViewController
            WatheqSubCatViewController.title = SubObj.name
            WatheqSubCatViewController.ArrSubCat = SubObj.subs
            self.navigationController?.pushViewController(WatheqSubCatViewController)
        }
        else
        {
            let OrderDataDic = NSMutableDictionary ()
            OrderDataDic.setValue(SubObj.id, forKey: "categoryId")
            
            if ( SubObj.id == 3 || SubObj.id == 4 || SubObj.id == 5 || SubObj.id == 7 || SubObj.id == 8 || SubObj.id == 9 )
            {
            self.performSegue(withIdentifier: "S_SubCat_Mawkl", sender: OrderDataDic)
            }else if  ( SubObj.id == 11 || SubObj.id == 12 )
            {
                self.performSegue(withIdentifier: "S_Sub_Letter", sender: OrderDataDic)

            }
            else
            {
                DeliveryLocationTitle = NSLocalizedString("Recieving", comment: "") + " " + SubObj.name!
                self.performSegue(withIdentifier: "S_SubCat_DeliveryLocation", sender: OrderDataDic)

            }
        }
    }
    
    
}
