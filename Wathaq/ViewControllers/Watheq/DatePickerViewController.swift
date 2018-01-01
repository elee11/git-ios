//
//  DatePickerViewController.swift
//  Coujami-Trainining
//
//  Created by Zak on 7/31/17.
//  Copyright © 2017 ibtikar. All rights reserved.
//

import UIKit
protocol PickerDateDelegate {
    func DidUserChoosedDate(_ ChoosedDate : String)
    func DidUserCancelChoosingDate()
    
}
class DatePickerViewController: UIViewController {
    var delegate:PickerDateDelegate?
    var Arr_Data = NSArray()
    var Dic_ChoosedData = NSDictionary()
    var ChoosedDate = String()
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Choose: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())

        btn_Cancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        btn_Choose.setTitle(NSLocalizedString("ok", comment: ""), for: .normal)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = NSDate()
        
        ChoosedDate = dateFormatter.string(from:currentDate as Date)
        
        
        datePicker.addTarget(self, action: #selector(GetDateValue), for: .valueChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GetDateValue (_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        ChoosedDate = dateFormatter.string(from:datePicker.date as Date)

    }
    
    @IBAction func ChooseData(_ sender: Any)
    {
        delegate?.DidUserChoosedDate(ChoosedDate)
    }
    
    @IBAction func CancelChoosingData(_ sender: Any)
    {
        delegate?.DidUserCancelChoosingDate()
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
