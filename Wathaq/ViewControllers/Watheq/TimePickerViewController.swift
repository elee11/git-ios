//
//  TimePickerViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/1/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
protocol PickerTimeDelegate {
    func DidUserChoosedTime(_ ChoosedTime : String)
    func DidUserCancelChoosingTime()
    
}
class TimePickerViewController: UIViewController {
    var delegate:PickerTimeDelegate?
    var Arr_Data = NSArray()
    var Dic_ChoosedData = NSDictionary()
    var ChoosedDate = String()
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Choose: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        
        btn_Cancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        btn_Choose.setTitle(NSLocalizedString("ok", comment: ""), for: .normal)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm a"
        let currentDate = NSDate()
        
        ChoosedDate = dateFormatter.string(from:currentDate as Date)
        
        
        datePicker.addTarget(self, action: #selector(GetTimeValue), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func GetTimeValue (_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm a"
        ChoosedDate = dateFormatter.string(from:datePicker.date as Date)
        
    }
    
    @IBAction func ChooseData(_ sender: Any)
    {
        delegate?.DidUserChoosedTime(ChoosedDate)
    }
    
    @IBAction func CancelChoosingData(_ sender: Any)
    {
        delegate?.DidUserCancelChoosingTime()
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
