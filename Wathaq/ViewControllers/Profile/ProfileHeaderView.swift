//
//  ProfileHeaderView.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/5/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIViewController {
   
    var viewModel: UserViewModel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNumOfServices: UILabel!
    @IBOutlet weak var lblNumOfConsultation: UILabel!
    @IBOutlet weak var lblTitleNumOfServices: UILabel!
    @IBOutlet weak var lblTitleNumOfConsultation: UILabel!
    @IBOutlet weak var imgUserImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        let UserModel = viewModel.getUser()
        if let name = UserModel?.name
        {
            lblUserName.text = name
            
        }
        if let url = UserModel?.image
        {
            let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
            imgUserImg.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        else
        {
            imgUserImg.kf.setImage(with: nil, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        // Do any additional setup after loading the view.
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
