//
//  XFZDatePicker.swift
//  XFZDatePicker
//
//  Created by 黄勇 on 15/12/23.
//  Copyright © 2015年 xfz. All rights reserved.
//

import UIKit
import SnapKit

enum XFZDatePickerModel: Int{
    case YearMonth
    case YearMonthDay
}

@objc protocol XFZDatePickerDelegate :NSObjectProtocol{
    optional func datePicker(didSelected row: Int, inComponent component: Int)
    optional func datePicker(didSelected year: Int, Month month: Int, Day day: Int)
}


class XFZDatePicker: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    let dayNumberArray = [31,28,31,30,31,30,31,31,30,31,30,31]
    var firstComponentNumber :Int!
    var secondComponentNumber :Int!
    var thirdComponentNumber: Int!
    var delegate: XFZDatePickerDelegate?
    var maxYear :Int!
    var minYear :Int!
    var pickerView: UIPickerView!
    //是否需要至今
    var needUpToNow: Bool!
    
    var defaultSelectedRows: (Int,Int,Int)?{
//        set{
//            let first = self.defaultSelectedRows!.0
//            let second = self.defaultSelectedRows!.1
//            let third = self.defaultSelectedRows!.2
//            self.pickerView.selectRow(first, inComponent: 0, animated: false)
//            self.pickerView.selectRow(second, inComponent: 1, animated: false)
//            self.pickerView(self.pickerView, didSelectRow: first, inComponent: 0)
//            self.pickerView(self.pickerView, didSelectRow: second, inComponent: 1)
//            if self.datePickerModel == .YearMonthDay{
//                self.pickerView.selectRow(third, inComponent: 2, animated: false)
//                self.pickerView(self.pickerView, didSelectRow: third, inComponent: 2)
//            }
//        }
//        get{
//            return self.defaultSelectedRows
//        }
        willSet(newDefaultRows){
            self.defaultSelectedRows = newDefaultRows
        }
        didSet{
            let first = self.defaultSelectedRows!.0
            let second = self.defaultSelectedRows!.1
            let third = self.defaultSelectedRows!.2
            self.pickerView.selectRow(first, inComponent: 0, animated: false)
            self.pickerView.selectRow(second, inComponent: 1, animated: false)
            self.pickerView(self.pickerView, didSelectRow: first, inComponent: 0)
            self.pickerView(self.pickerView, didSelectRow: second, inComponent: 1)
            if self.datePickerModel == .YearMonthDay{
                self.pickerView.selectRow(third, inComponent: 2, animated: false)
                self.pickerView(self.pickerView, didSelectRow: third, inComponent: 2)
            }
        }
    }
    
    
    var datePickerModel :XFZDatePickerModel? {
        willSet{self.datePickerModel = newValue}
        didSet{}
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //默认展示的是年和月
        self.datePickerModel = XFZDatePickerModel.YearMonth
        //默认最大的年是当前日期的年
        self.maxYear = NSDate().year()
        //默认最小的年是提前一百年
        self.minYear = NSDate().dateByAddingYears(-100).year()
        //默认有至今
        self.needUpToNow = true
        //默认三个的否为0
        self.firstComponentNumber = 0
        self.secondComponentNumber = 0
        self.thirdComponentNumber = 0
        
        self.pickerView = UIPickerView.init()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.showsSelectionIndicator = true
        self.addSubview(self.pickerView)
        self.pickerView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaultRowValue(){
        self.defaultSelectedRows = (self.maxYear-self.minYear,0,0)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            let totalYear = self.maxYear! - self.minYear! + 1;
            if self.needUpToNow == true {
                self.firstComponentNumber = totalYear + 1
                return self.firstComponentNumber
            }else{
                self.firstComponentNumber = totalYear
                return self.firstComponentNumber
            }
        }else if component == 1{
            let row = self.pickerView.selectedRowInComponent(0)
            //最后一个代表至今，如果是至今就不需要
            if self.needUpToNow == true && row == self.firstComponentNumber-1 {
                self.secondComponentNumber = 0
                return self.secondComponentNumber
            }else{
                self.secondComponentNumber = 12
                return self.secondComponentNumber
            }
        }else{
            //获得当前选择的是第几个年第几个月
            let selectedYear = self.pickerView.selectedRowInComponent(0) + self.minYear!
            if self.needUpToNow == true && self.pickerView.selectedRowInComponent(0) == self.firstComponentNumber-1 {
                self.thirdComponentNumber = 0
                return self.thirdComponentNumber
            }else{
                let selectedMonth = self.pickerView.selectedRowInComponent(1) + 1;
                if (selectedYear%4==0 && selectedYear%100 != 0) || (selectedYear%400==0){
                    if selectedMonth == 2 {
                        self.thirdComponentNumber = 29
                        return self.thirdComponentNumber
                    }else{
                        self.thirdComponentNumber = self.dayNumberArray[selectedMonth-1]
                        return self.thirdComponentNumber
                    }
                }else{
                    self.thirdComponentNumber = self.dayNumberArray[selectedMonth-1]
                    return self.thirdComponentNumber
                }
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if self.datePickerModel == XFZDatePickerModel.YearMonth{
            return 2
        }else{
            return 3
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if self.needUpToNow == true && row == self.pickerView .numberOfRowsInComponent(0)-1 {
                return "至今"
            }
            return String(row + self.minYear)
        }else if component == 1{
            return String(row + 1)
        }else{
            return String(row + 1)
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component != 2 && self.datePickerModel == .YearMonthDay {
            self.pickerView.reloadComponent(2)
        }
        if component == 0 {
            self.pickerView .reloadComponent(1)
        }
        //代理选中的row和component出去
        self.delegate?.datePicker!(didSelected: row, inComponent: component)
        //代理年、月、日出去
        let year = self.pickerView .selectedRowInComponent(0)
        let month = self.pickerView.selectedRowInComponent(1)
        var day = 0
        if self.datePickerModel == .YearMonthDay {
            day = self.pickerView.selectedRowInComponent(2)
        }
        self.delegate?.datePicker!(didSelected: year, Month: month, Day: day)
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}
