//
//  PickerViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 2/2/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
protocol PickerDelegate {
    func DidUserChoosedItem(_ ChoosedItem : NSDictionary)
    func DidUserCancelChoosingItem()
    
}
class PickerViewController: UIViewController {
    var delegate:PickerDelegate?
    var Arr_Data : NSArray!
    var Dic_ChoosedData = NSDictionary()
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Choose: UIButton!
    @IBOutlet weak var PickerData: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Cancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        btn_Choose.setTitle(NSLocalizedString("ok", comment: ""), for: .normal)
        Dic_ChoosedData = (Arr_Data[0] as? NSDictionary)!

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    @IBAction func ChooseData(_ sender: Any)
    {
        delegate?.DidUserChoosedItem(Dic_ChoosedData)
    }
    
    @IBAction func CancelChoosingData(_ sender: Any)
    {
        delegate?.DidUserCancelChoosingItem()
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

extension PickerViewController : UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Arr_Data.count

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    
   
    
}

extension PickerViewController : UIPickerViewDelegate{

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        var RowData = ""
        
        if let DicData: NSDictionary = Arr_Data[row] as? NSDictionary
        {
            var key = "Name_EN"
            if Language.getCurrentLanguage() == Constants.Language.ARABIC {
                key = "Name"
            }
            RowData = DicData.object(forKey: key) as! String
        }
        
        return RowData
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        Dic_ChoosedData = (Arr_Data[row] as? NSDictionary)!
        self.view.endEditing(true)
    }
}
