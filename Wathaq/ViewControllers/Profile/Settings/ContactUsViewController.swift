//
//  ContactUsViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 2/10/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class ContactUsViewController: UIViewController,ToastAlertProtocol {
    @IBOutlet weak var tblContactUs: UITableView!
    var Contactustitle : String!
    var content : String!
      var viewModel: OrderViewModel!


    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderViewModel()

        tblContactUs.rowHeight = UITableViewAutomaticDimension
        self.title = NSLocalizedString("Contact Us", comment: "")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CreatContactUsRequestOrder (_ sender : Any)
    {
        self.view.endEditing(true)
        if let content = content, let titledata = Contactustitle
        {
        if (Contactustitle.length > 0 && content.length > 0)
        {
        let TranstBtn:TransitionButton =  sender as! TransitionButton

        TranstBtn.startAnimation()

        viewModel.ContactUs(title:Contactustitle , content:content,  completion: { (ResponseDic, errorMsg) in
            if errorMsg == nil {
                
                TranstBtn.stopAnimation()
                self.showToastMessage(title:NSLocalizedString("Your Request Recieved, you Will Be Contacted Shortly", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                self.content = nil
                self.Contactustitle = nil
            } else{
                TranstBtn.stopAnimation()

                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
            self.tblContactUs.reloadData()

        })
        }
        else
        {
            self.showToastMessage(title:NSLocalizedString("FillAllFields", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
        }
        }
        else
        {
            self.showToastMessage(title:NSLocalizedString("FillAllFields", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

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

extension ContactUsViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            if indexPath.row == 0
            {
                let cellAddressLocation:AddressLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier:"AddressLocationTableViewCell") as UITableViewCell! as! AddressLocationTableViewCell
                cellAddressLocation.txtAddressLocation.placeholder = NSLocalizedString("LetterAddress", comment: "")
                cellAddressLocation.txtAddressLocation.tag = indexPath.row
                cellAddressLocation.txtAddressLocation.delegate = self
                
                if let txtAddress : String = Contactustitle
                {
                    cellAddressLocation.txtAddressLocation.text = txtAddress
                }else
                {
                    cellAddressLocation.txtAddressLocation.text = ""
                    cellAddressLocation.txtAddressLocation.applyDGrayBorderProperties()

                }
                
                return cellAddressLocation
            }
            else if indexPath.row == 1
            {
                
                let cellContactUsDetails:ContactusDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ContactusDetailsTableViewCell") as UITableViewCell! as! ContactusDetailsTableViewCell
                cellContactUsDetails.txtContent.text = NSLocalizedString("Lettercontent", comment: "")
                cellContactUsDetails.txtContent.tag = indexPath.row
                cellContactUsDetails.txtContent.delegate = self
                if let txtcontent : String = content
                {
                    cellContactUsDetails.txtContent.text = content
                }else
                {
                    cellContactUsDetails.txtContent.text = NSLocalizedString("Lettercontent", comment: "")
                    cellContactUsDetails.txtContent.applytextViewDGrayBorderProperties()
                    
                }
                
                return cellContactUsDetails
            }
            else
            {
                let cellCreatOrder:CreateOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"CreateOrderTableViewCell") as UITableViewCell! as! CreateOrderTableViewCell
                cellCreatOrder.btnCreatOrder.setTitle(NSLocalizedString("SendData", comment: ""), for: .normal)
                cellCreatOrder.btnCreatOrder.removeTarget(nil, action: nil, for: .allEvents)
                cellCreatOrder.btnCreatOrder.addTarget(self, action: #selector(CreatContactUsRequestOrder), for: .touchUpInside)
                return cellCreatOrder
            }
            
        }
    
}

extension ContactUsViewController: UITableViewDelegate {
    
}

extension ContactUsViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.applyGreenviewBorderProperties()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let  row = textField.tag
        textField.applyDGrayBorderProperties()

        self.tblContactUs.setContentOffset(CGPoint(x: self.tblContactUs.contentOffset.x, y: 0), animated: true)
        if textField.text?.length == 0
        {
            textField.applyDGrayBorderProperties()

        }
        if row == 0
        {
            Contactustitle = textField.text
         }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}

extension ContactUsViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.applyGreentextviewBorderProperties()
        if textView.text == NSLocalizedString("Lettercontent", comment: "")
        {
            textView.text = ""
        }

    }
    
  
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let  row = textView.tag
        textView.applytextViewDGrayBorderProperties()
        
        self.tblContactUs.setContentOffset(CGPoint(x: self.tblContactUs.contentOffset.x, y: 0), animated: true)
        if textView.text?.length == 0
        {
            textView.applytextViewDGrayBorderProperties()
            content = nil
            
        }
        else if  textView.text?.length as! Int > 0
        {
            content = textView.text

        }

        self.tblContactUs.reloadData()
    }
   
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            self.view.endEditing(true)
        }
        return true
    }}


extension UITextView {
    func applyGreentextviewBorderProperties() {
        layer.borderWidth = 1
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 6.0
    }
    
    func applytextViewDGrayBorderProperties() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.manatee1.cgColor
        layer.cornerRadius = 6.0
    }
}
