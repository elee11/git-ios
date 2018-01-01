//
//  SearchingForAlawyerViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/19/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import EasyAnimation

class SearchingForAlawyerViewController: UIViewController {

    @IBOutlet weak var ovalViewContainer: UIImageView!
    @IBOutlet weak var mainlawyer: UIImageView!
    @IBOutlet weak var lawyer1: UIImageView!
    @IBOutlet weak var lawyer2: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        UIView.animate(withDuration: 0.80, delay: 0.20,
                       usingSpringWithDamping: 22.0,
                       initialSpringVelocity: 0.0,
                       options: [.repeat, .autoreverse, .curveEaseOut],
                       animations: {
                        self.mainlawyer.layer.cornerRadius = 50.0
                        self.mainlawyer.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0)
                        if Language.getCurrentLanguage() == Constants.Language.ARABIC {
                        self.lawyer1.layer.position.x -= 167
                        self.lawyer2.layer.position.x += 167
                        }
                        else
                        {
                            self.lawyer2.layer.position.x -= 167
                            self.lawyer1.layer.position.x += 167
                        }
        }, completion: nil)
        
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
