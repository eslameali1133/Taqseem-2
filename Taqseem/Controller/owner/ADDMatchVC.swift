//
//  ADDMatchVC.swift
//  Taqseem
//
//  Created by apple on 3/5/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON

class OwnerADDMatchVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let date = Date()
    let calendar = Calendar.current
    var PlaygroundArray: [OwnerPlaygroundModelClass] = [OwnerPlaygroundModelClass]()
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    var http = HttpHelper()
    var PickerFlag = ""
    var PickerFlag1 = ""
    var DateIs = ""
    var Playground_id = ""
    var Duration = [0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10]
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    @IBOutlet weak var lblDate: UILabel!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self
        loadPlayground()
        DefaultValues()
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    
    func loadPlayground(){
        PlaygroundArray.removeAll()
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print(token_type , AccessToken)
        print(AccessToken)
        let headers: HTTPHeaders = ["Authorization" : "\(token_type) \(AccessToken)",
           "lang":SharedData.SharedInstans.getLanguage()
        ]
        http.Get(url: "\(APIConstants.GetGround)", Tag: 1, headers: headers)
    }
    
    @IBAction func btnDate(_ sender: Any) {
        PickerFlag1 = "Date"
        onDoneButtonTapped()
        showDatePicker(isDate: true)
        datePicker.addTarget(self, action: #selector(OwnerADDMatchVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    @IBAction func btnFrom(_ sender: Any) {
        DateIs = "From"
        PickerFlag1 = "Time"
        onDoneButtonTapped()
        showDatePicker(isDate: false)
        datePicker.addTarget(self, action: #selector(OwnerADDMatchVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
//    @IBAction func btnTo(_ sender: Any) {
//        DateIs = "To"
//        showDatePicker(isDate: false)
//        datePicker.addTarget(self, action: #selector(OwnerADDMatchVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
//    }
    @IBAction func btnDuration(_ sender: Any) {
        PickerFlag = "Playground"
        onDoneButtonTapped()
        configurePicker()
    }
    
    @IBAction func btnDur(_ sender: Any) {
        PickerFlag = "Duration"
        onDoneButtonTapped()
        configurePicker()
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func AddMatch(_ sender: Any) {
       AddMatch()
    }
    
    func DefaultValues(){
        let Year = calendar.component(.year, from: date)
        var Month = String(calendar.component(.month, from: date))
        if Month.count == 1{
            Month = "0\(Month)"
        }
        var Day = String(calendar.component(.day, from: date))
        if Day.count == 1{
            Day = "0\(Day)"
        }
        var hour = String(calendar.component(.hour, from: date))
        if hour.count == 1{
            hour = "0\(hour)"
        }
        var minutes = String(calendar.component(.minute, from: date))
        if minutes.count == 1{
            minutes = "0\(minutes)"
        }
        let defaultDate = "\(Year)-\(Month)-\(Day)"
        let defaultTime = "\(hour):\(minutes):00"
        print(defaultDate,defaultTime)
        lblDate.text = defaultDate
        lblFrom.text = defaultTime
        lblTo.text = "1"
        
    }
    
    func AddMatch(){
        
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        let params = [
            "ground_id": Playground_id ,
            "date" : lblDate.text! ,
            "time" : lblFrom.text! ,
            "duration" : lblTo.text!,
            "type" : "all"
            ] as [String: Any]
        
        print(params)
        
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization" : "\(token_type) \(AccessToken)"
        ]
        
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.AddMatch, method: .post, parameters: params, tag: 2, header: headers)
        
    }
    
    
    func showDatePicker(isDate: Bool){
        //Formate Date //Formate Date
        if isDate == true{
            datePicker.datePickerMode = .date
            
        }else{
            datePicker.datePickerMode = .time
        }
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(onDoneButtonTapped));
        self.view.addSubview(toolbar)
        
        let tempInput = UITextField( frame:CGRect.zero )
        tempInput.inputView = self.datePicker       // Your picker
        self.view.addSubview( tempInput )
        tempInput.becomeFirstResponder()
    }
    @objc func datePickerValueChanged (datePicker: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        if PickerFlag1 == "Date" {
            dateformatter.dateStyle = DateFormatter.Style.medium
            dateformatter.timeStyle = DateFormatter.Style.none
            let dateValue = dateformatter.string(from: datePicker.date)
            let datee = dateformatter.date(from: dateValue)
            dateformatter.dateFormat = "YYYY-MM-dd"
            let Date24 = dateformatter.string(from: datee!)
            lblDate.text = Date24
        } else {
           
            dateformatter.dateStyle = DateFormatter.Style.none
            dateformatter.timeStyle = DateFormatter.Style.long
            let dateValue = dateformatter.string(from: datePicker.date)
            let datee = dateformatter.date(from: dateValue)
            dateformatter.dateFormat = "a"
            let hpm = dateformatter.string(from: datee!)
            if hpm == "PM" {
                dateformatter.dateFormat = "HH"
                let hou = dateformatter.string(from: datee!)
                dateformatter.dateFormat = "mm"
                let Min = dateformatter.string(from: datee!)
                dateformatter.dateFormat = "ss"
                //  let Sec = dateformatter.string(from: datee!)
                let Time24 = "\(hou):\(Min):00"
                if DateIs == "From" {
                    lblFrom.text = Time24
                }else{
                    lblTo.text = Time24
                }
            }else {
                
                dateformatter.dateFormat = "HH:mm:00"
                let Time24 = dateformatter.string(from : datee!)
                
                if DateIs == "From" {
                    lblFrom.text = Time24
                }else{
                    lblTo.text = Time24
                }
               
            }
            
            
            
            
        }
    }
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        lblDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    func configurePicker (){
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 255)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if PickerFlag == "Duration" {
            lblTo.text = String(Duration[row])
        }
        else{
        if PlaygroundArray.count != 0 {
            if row == 0 {
                lblDuration.text = nil
                
            }else {
                if SharedData.SharedInstans.getLanguage() == "en"
                {
                    lblDuration.text = PlaygroundArray[row-1].name_en
                }else
                {
                    lblDuration.text = PlaygroundArray[row-1].name_ar
                }
                Playground_id = PlaygroundArray[row-1].id
                
            }
        }
        }
        
     
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if PickerFlag ==  "Playground"
        {
        if row == 0{
            return "Select playground"
        }
        else{
            if SharedData.SharedInstans.getLanguage() == "en"
            {
                return PlaygroundArray[row-1].name_en
            }else
            {
                return PlaygroundArray[row-1].name_ar
            }
            
        }
        }
        else{
         
                if row == 0{
                    return "Select The Duration ( Per Hours ) "
                }
                return String(Duration[row])
                
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if PickerFlag == "Duration"{
            return Duration.count
        }else{
              return PlaygroundArray.count + 1
        }
      
        
        
    }
   
}
extension OwnerADDMatchVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        if Tag == 1 {
            let status =  json["status"]
            let message = json["message"]
            if status.stringValue == "1" {
                PlaygroundArray.removeAll()
                let result =  json["data"].arrayValue
                for json in result{
                    let obj = OwnerPlaygroundModelClass(id: json["id"].stringValue, name_en:  json["name_en"].stringValue, name_ar:  json["name_ar"].stringValue)
                    PlaygroundArray.append(obj)
                }
            } else {
                Loader.showError(message: message.stringValue)
            }
        }
        else if Tag == 2{
            let status =  json["status"]
            let message = json["message"]
            
            if status.stringValue == "1" {
                Loader.showSuccess(message: message.stringValue)
                 self.dismiss(animated: true, completion: nil)
               
            }else {
                
                let message = json["message"]
                Loader.showError(message: message.stringValue )
            }
        }
        
    }
    func receivedErrorWithStatusCode(statusCode: Int) {
        print(statusCode)
        AppCommon.sharedInstance.alert(title: "Error", message: "\(statusCode)", controller: self, actionTitle: AppCommon.sharedInstance.localization("ok"), actionStyle: .default)
        
        AppCommon.sharedInstance.dismissLoader(self.view)
    }
    func retryResponse(numberOfrequest: Int) {
        
    }
}
