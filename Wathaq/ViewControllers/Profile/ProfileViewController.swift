//
//  ProfileViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import Kingfisher



class ProfileViewController: UIViewController {
    @IBOutlet weak var tbl_Orders: UITableView!
    var viewModel: UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()

        self.title = NSLocalizedString("profile", comment: "")
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
                ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
    }
    
    override  func viewDidLayoutSubviews() {
       
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

extension ProfileViewController: UITableViewDataSource {
    // table view data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellOrderCell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderTableViewCell") as UITableViewCell! as! MyOrderTableViewCell
        
        return cellOrderCell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
            return 300
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cellHeader:ProfileHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ProfileHeaderTableViewCell") as UITableViewCell! as! ProfileHeaderTableViewCell
        viewModel = UserViewModel()
        let UserModel = viewModel.getUser()
        if let name = UserModel?.name
        {
            cellHeader.lblUserName.text = name
        }
        if let url = UserModel?.image
        {
            let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
            cellHeader.imgUserImg.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        else
        {
            cellHeader.imgUserImg.kf.setImage(with: nil, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        return cellHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.24
    }
}

