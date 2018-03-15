//
//  WebViewController.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 1/22/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

   @IBOutlet weak var webView : UIWebView!
    @IBOutlet weak var button_Close : UIButton!
    var isCompleteProfile = false

    var webPage :String!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: webPage)!))
        if isCompleteProfile == true
        {
            button_Close.isHidden = false
            button_Close.setTitle(NSLocalizedString("close", comment: ""), for: .normal)
        }
        else
        {
            button_Close.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeview (_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
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
