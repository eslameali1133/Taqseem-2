//
//  TermsVC.swift
//  Taqseem
//
//  Created by apple on 2/8/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class TermsVC: UIViewController {
    var http = HttpHelper()
    
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var terms: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
   http.delegate = self
        GetTerms()
        
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func GetTerms(){
      AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let headers = [
          "lang":SharedData.SharedInstans.getLanguage()
        ]
        
        http.Get(url: APIConstants.GetTerms, parameters:[:], Tag: 2, headers: headers)
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  

}

extension TermsVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        
        let json = JSON(dictResponse)
        if Tag == 1 {
            
            let status =  json["status"]
            let message = json["message"]
            
            print(json["status"])
            if status.stringValue  == "1" {
                SharedData.SharedInstans.SetIsLogin(false)
                Loader.showSuccess(message: message.stringValue)
            }
            else {
                Loader.showError(message: message.stringValue)
            }
            
        }else if Tag == 2 {
            
            let status =  json["status"]
            let data = json["data"]
            
            print(json["status"])
            if status.stringValue  == "1" {
               print(data["terms"].stringValue)
            print(data["conditions"].stringValue)
                
                terms.text = "\(data["terms"].stringValue) - \(data["conditions"].stringValue)"
               
            }
            else {
                print("error Not Seen Notification")
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
