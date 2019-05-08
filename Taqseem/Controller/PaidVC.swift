//
//  PaidVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 2/22/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
var bookingplayground = false
class PaidVC: AllignLocalizerVC {

    var Pground_id = ""
    var Pdate = ""
    var Ptime = ""
    var Pduration = ""
    var http = HttpHelper()
    @IBOutlet weak var VisaView: UIView!
    @IBOutlet weak var cashView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        http.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btn_join(_ sender: Any) {
        
//        if bookingplayground == true
//        {
//            bookingplayground = false
//            let delegate = UIApplication.shared.delegate as! AppDelegate
//            let storyboard = UIStoryboard.init(name: "Player", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
//        }else
//        {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
//        let cont = storyBoard.instantiateViewController(withIdentifier: "AddMatchSegmVC")as! AddMatchSegmVC
//        self.present(cont, animated: true, completion: nil)
//        }
        
        AddMatch()
        
        
    }
    
    @IBAction func Btn_cash(_ sender: Any) {
        cashView.backgroundColor = UIColor(red: 37, green: 159, blue: 161, alpha: 1)
         VisaView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    }
    

    @IBAction func btn_visa(_ sender: Any) {
           VisaView.backgroundColor = UIColor(red: 37, green: 159, blue: 161, alpha: 1)
        
        cashView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "AddNewVisaVC")as! AddNewVisaVC
        self.present(cont, animated: true, completion: nil)
        
    }
    
    func AddMatch(){
        
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        if comedromneartoplay == "NearME" {
             Pground_id = GNearItems._id
             Pdate = GNearItems._date
             Ptime = GNearItems._time
             Pduration = GNearItems._duration
        }else {
             Pground_id = Gitem._id
             Pdate = GMatchDetails._Date
             Ptime = GMatchDetails._Time
             Pduration = GMatchDetails._Duration
        }
        let params = [
            "ground_id": Pground_id ,
            "date" : Pdate ,
            "time" : Ptime ,
            "duration" : Pduration ,
            "type = all if you want reserve all ground if not remove this row" : "all"
            ] as [String: Any]
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization" : "\(token_type) \(AccessToken)"
        ]
        
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.AddMatch, method: .post, parameters: params, tag: 1, header: headers)
    
    }
    
}
extension PaidVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        
        
        if Tag == 1 {
            
            let status =  json["status"]
            let message = json["message"]
            
            if status.stringValue == "1" {
                Loader.showSuccess(message: message.stringValue)
                comedromneartoplay = ""
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    //  let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                    let storyboard = UIStoryboard.init(name: "Player", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            }else {
                
                let message = json["message"]
                Loader.showError(message: message.stringValue )
                  self.dismiss(animated: true, completion: nil)
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
