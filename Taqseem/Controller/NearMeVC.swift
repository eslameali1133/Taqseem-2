//
//  NearMeVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 2/24/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON

var comedromneartoplay = "false"
class NearMeVC: UIViewController  , UIPickerViewDataSource , UIPickerViewDelegate{
    let date = Date()
    let calendar = Calendar.current
    var NearItems = [NearPlayGroundModelClass]()
    //var MatchDetails : MatchDetailsModelClass!
    var http = HttpHelper()
    
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBOutlet weak var lblDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self

        DefaultValues()
        pickerDate.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Search_Reaseult(_ sender: Any) {
        comedromneartoplay = "NearME"
        
        Filter()
        
    }
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged (datePicker: UIDatePicker) {
        
        let dateformatter = DateFormatter()
        
            dateformatter.dateStyle = DateFormatter.Style.medium
            dateformatter.timeStyle = DateFormatter.Style.none
            let dateValue = dateformatter.string(from: datePicker.date)
            let datee = dateformatter.date(from: dateValue)
            dateformatter.dateFormat = "YYYY-MM-dd"
            let Date24 = dateformatter.string(from: datee!)
            
            lblDate.text = Date24
            
            
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
    
    }
    
    
func Filter(){
    NearItems.removeAll()
    let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
    let token_type = UserDefaults.standard.string(forKey: "token_type")!
    
    
    let headers = [
        
        "Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage() 
       
    ]
    
    AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
    
    http.Get(url: "\(APIConstants.NearMe)?date=\(lblDate.text!)", parameters:[:], Tag: 1, headers: headers)
    
}

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }

    
}
extension NearMeVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        if Tag == 1 {
            
            let status =  json["status"]
            let message = json["message"]
            
            if status.stringValue == "1" {
                let result =  json["data"].arrayValue
                for json in result{
                    let obj = NearPlayGroundModelClass(
                        owner_id: json["owner_id"].stringValue,
                        updated_at: json["updated_at"].stringValue,
                        name: json["name"].stringValue,
                        lng: json["lng"].stringValue,
                        hour_to: json["hour_to"].stringValue,
                        phone: json["phone"].stringValue,
                        image: json["image"].stringValue,
                        note: json["note"].stringValue,
                        lat: json["lat"].stringValue,
                        capacity: json["capacity"].stringValue,
                        address: json["address"].stringValue,
                        name_en: json["name_en"].stringValue,
                        city_id: json["city_id"].stringValue,
                        id: json["id"].stringValue,
                        name_ar: json["name_ar"].stringValue,
                        created_at: json["created_at"].stringValue,
                        hour_from: json["hour_from"].stringValue,
                        cancel_fee: json["cancel_fee"].stringValue,
                        price: json["price"].stringValue,
                        cancelation_time: json["cancelation_time"].stringValue,
                        member: json["member"].stringValue,
                        reservation_no: json["reservation_no"].stringValue,
                        duration: json["duration"].stringValue,
                        time: json["time"].stringValue,
                        date: json["date"].stringValue
                        
                    )
                    NearItems.append(obj)
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "ChoosePlaygroundVC")as! ChoosePlaygroundVC
                //cont.MatchDetais = MatchDetails
                cont.NearItems = NearItems
                self.present(cont, animated: true, completion: nil)
                
            } else {
                Loader.showError(message: message.stringValue)
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
