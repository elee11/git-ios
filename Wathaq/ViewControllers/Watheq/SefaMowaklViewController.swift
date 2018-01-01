
//
//  SefaMowaklViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/30/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class SefaMowaklViewController: UIViewController,ToastAlertProtocol {
    var OrderDataDic : NSMutableDictionary!
    @IBOutlet weak var Collection_SefaMowkl: UICollectionView!
    var Arr_SefaMowkl: NSMutableArray?
    fileprivate let reuseIdentifier = "SefaMowaklCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 2
    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("clientDesc", comment: "")
        ConfirmButton.setTitle(NSLocalizedString("nextStep", comment: ""), for: .normal)

        Arr_SefaMowkl = readPlistSefaMowakl()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func NextStepAction(_ sender: Any) {
        view.endEditing(true)
        
        if let ClientDesc : String =  OrderDataDic.value(forKey: "ClientDesc") as? String
        {
           

            
            self.performSegue(withIdentifier: "S_Mawkl_MawkelOwner", sender: OrderDataDic)
          
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("Please choose Client Describtion"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            return
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Mawkl_MawkelOwner"  {
            let OrderDic = sender as!  NSMutableDictionary
            let TawkeelownerView = segue.destination as! TawkeelOwnerViewController
            TawkeelownerView.OrderDataDic = OrderDic
        }
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

extension SefaMowaklViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (Arr_SefaMowkl?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! SefaMowklCollectionViewCell
       
        if let DicData: NSDictionary = Arr_SefaMowkl?.object(at: indexPath.row) as? NSDictionary
        {
            var key = "Name_EN"
            if Language.getCurrentLanguage() == Constants.Language.ARABIC {
                key = "Name"
            }
            cell.lblCatName.text = DicData.object(forKey: key) as! String
            
            if let ClientDesc : String =  OrderDataDic.value(forKey: "ClientDesc") as? String
            {
            if ClientDesc == DicData.object(forKey: key) as! String
            {
                cell.viewContainer.backgroundColor = UIColor.deepBlue
                cell.lblCatName.textColor = UIColor.white
            }
            else
            {
                cell.viewContainer.backgroundColor = UIColor.white
                cell.lblCatName.textColor = UIColor.deepBlue
            }
        }
        }
        
        
        return cell
    }
}

extension SefaMowaklViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension SefaMowaklViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let DicData: NSDictionary = Arr_SefaMowkl?.object(at: indexPath.row) as? NSDictionary
        {
            var key = "Name_EN"
            if Language.getCurrentLanguage() == Constants.Language.ARABIC {
                key = "Name"
            }
            OrderDataDic.setValue(DicData.object(forKey: key) as! String, forKey: "ClientDesc")
            collectionView.reloadData()
        }
    }
}

extension SefaMowaklViewController: PlistReaderProtocol {
    func readPlistSefaMowakl() -> NSMutableArray{
        let fileName = "SefaMowaklList"
        let data =  (self as PlistReaderProtocol).readPlist(fileName: fileName)
        return data as! NSMutableArray
    }
}


