//
//  SearchingForAlawyerViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/19/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import EasyAnimation
import CountdownLabel


class SearchingForAlawyerViewController: UIViewController {

    @IBOutlet weak var ovalViewContainer: UIImageView!
    @IBOutlet weak var mainlawyer: UIImageView!
    @IBOutlet weak var lawyer1: UIImageView!
    @IBOutlet weak var lawyer2: UIImageView!
    @IBOutlet weak var lblSearching: UILabel!
    @IBOutlet weak var lblSearchingMsg: UILabel!
    @IBOutlet weak var lbl_Timer: CountdownLabel!
    @IBOutlet weak var btn_searchForMowatheq: UIButton!
    var OrderObj : OrderRootClass!



   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.title = NSLocalizedString("Searching", comment: "")
        lblSearching.text = NSLocalizedString("Searching", comment: "")
        lblSearchingMsg.text = NSLocalizedString("SearchingMsg", comment: "")
        btn_searchForMowatheq.setTitle(NSLocalizedString("ChooseMowtheq", comment: ""), for: .normal)
        self.addTimerLable()
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
    
    func addTimerLable()
    {
        UIView.animate(withDuration: 0.5, animations: {
            
            self.btn_searchForMowatheq.alpha = 0
            self.lbl_Timer.alpha = 1
            
            
        })
        
        lbl_Timer.setCountDownTime(minutes: 120)
        lbl_Timer.animationType = .Sparkle
        lbl_Timer.countdownDelegate = self
        lbl_Timer.start() { [unowned self] in
        }
    }
    
    @IBAction func chooseSpecficDocumenter (_ sender:Any)
    {
        self.performSegue(withIdentifier: "S_ChooseLawyer", sender: OrderObj.Orderdata)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_ChooseLawyer"  {
            let chooseLawyerView = segue.destination as! ChooseLawyerViewController
            chooseLawyerView.OrderObj = sender as! Orderdata
            chooseLawyerView.removeBackBtn = true
        }
    }


}

extension SearchingForAlawyerViewController: CountdownLabelDelegate {
    func countdownFinished() {
        debugPrint("countdownFinished at delegate.")
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.btn_searchForMowatheq.alpha = 1
            self.lbl_Timer.alpha = 0
            
            
        })
    }
    
    func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
        debugPrint("time counted at delegate=\(timeCounted)")
        debugPrint("time remaining at delegate=\(timeRemaining)")
    }
    
}
