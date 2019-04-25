//
//  MobileVerificationVC.swift
//  Taqseem
//
//  Created by apple on 2/7/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class MobileVerificationVC: UIViewController {
    var http = HttpHelper()
    @IBOutlet weak var txtPhone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       http.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnVerify(_ sender: Any) {
        if validation(){
            sendCode()
        }
    }
    func validation () -> Bool {
        var isValid = true
        
        if (txtPhone.text?.count)! != 11  {
            Loader.showError(message: AppCommon.sharedInstance.localization("Phone number must be between 7 and 17 characters long"))
            isValid = false
        }
        
        if txtPhone.text! == "" {
            Loader.showError(message: AppCommon.sharedInstance.localization("Phone field cannot be left blank"))
            isValid = false
        }
        
        
        return isValid
    }
    
    func sendCode(){
        let params = ["phone":txtPhone.text!] as [String: Any]
        let headers = ["Accept-Type": "application/json" ,   "lang":SharedData.SharedInstans.getLanguage() , "Content-Type": "application/json"]
      //  AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.ResentCode, method: .post, parameters: params, tag: 1, header: headers)
    }
}
extension MobileVerificationVC : HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        
        if Tag == 1 {
            
            let status =  json["status"]
            let code = json["code"]
            print(status)
            print(code)
            if status.stringValue  == "2" {
                    let sb = UIStoryboard(name: "Profile", bundle: nil)
                    let controller = sb.instantiateViewController(withIdentifier: "EnterVerificationCodeVC") as! EnterVerificationCodeVC
                
                print(txtPhone.text!)
                print(code.stringValue)
                controller.vereficationCode = code.stringValue
                controller.Phone = txtPhone.text!
                    self.show(controller, sender: true)
                
            } else if status.stringValue  == "3" {
                
                let message = json["message"]
                Loader.showError(message: message.stringValue )
                
            } else {
                
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
