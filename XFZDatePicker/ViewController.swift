//
//  ViewController.swift
//  XFZDatePicker
//
//  Created by 黄勇 on 15/12/23.
//  Copyright © 2015年 xfz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,XFZDatePickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datePicker: XFZDatePicker = XFZDatePicker()
        datePicker.datePickerModel = .YearMonthDay
        datePicker.delegate = self
        datePicker .setDefaultRowValue()
//        datePicker.defaultSelectedRows = (datePicker.maxYear-datePicker.minYear,0,0)
        self.view.addSubview(datePicker)
        datePicker.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(200)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func datePicker(didSelected row: Int, inComponent component: Int) {
        print("row:\(row)---component;\(component)")
    }
    
    func datePicker(didSelected year: Int, Month month: Int, Day day: Int) {
        print("year:\(year)---month:\(month)---day:\(day)")
    }
}

