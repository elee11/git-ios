//
//  WatheqViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class WatheqViewController: AbstractViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("watheq", comment: "")

       // AbstractViewController.showMessage(title: "No Internet Connection", body: "", isWindowNeeded: false, BackgroundColor: UIColor.black, foregroundColor: UIColor.white)

        // Do any additional setup after loading the view.
    }
    override  func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
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
