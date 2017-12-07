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
    @IBOutlet weak var tbl_SubCategories: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTitleView()
    }
    
    func configureTitleView() {
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }

    }
    
    override func viewDidLayoutSubviews() {
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
            
        }
    }
    
    
}
