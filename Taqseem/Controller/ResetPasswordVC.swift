//
//  ResetPasswordVC.swift
//  Taqseem
//
//  Created by apple on 2/7/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class ResetPasswordVC: AllignLocalizerVC {
var http = HttpHelper()
var Token = ""
var Phone = ""
let DeviceID = UIDevice.current.identifierForVendor!.uuidString
    
    
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self
        
        print(Phone)
        print(Token)
        
        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReset(_ sender: Any) {
        if validation(){
            ResetPassword()
        }
    }
    
    
    func validation () -> Bool {
        var isValid = true
        if txtConfirmPassword.text! != txtNewPassword.text { Loader.showError(message: AppCommon.sharedInstance.localization("Password and Confirm password is not match!"))
            isValid = false
        }
        
        if (txtNewPassword.text?.count)! < 6 { Loader.showError(message: AppCommon.sharedInstance.localization("Password must be at least 6 characters long"))
            isValid = false
        }
        if txtNewPassword.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Password field cannot be left blank"))
            isValid = false
        }
        
        
        return isValid
    }
    
    func ResetPassword(){
        let params = ["token": Token , "password":txtNewPassword.text! , "phone":Phone,
            "device_id":DeviceID] as [String: Any]
        print(Phone)
        print(Token)
        let headers = ["Accept-Type": "application/json" ,   "lang":SharedData.SharedInstans.getLanguage() , "Content-Type": "application/json"]
        
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.ResetPassword, method: .post, parameters: params, tag: 1, header: headers)
    }
}
extension ResetPasswordVC : HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        print(json)
        
        if Tag == 1 {
            let status =  json["status"]
            let access_token =  json["access_token"]
            let token_type =  json["token_type"]
            let data =  json["data"]
            let expires_at =  json["expires_at"]
            let message = json["message"]
            print(status)
            print(data)
            
            //print(json["status"])
            if status.stringValue == "1" {
                
                UserDefaults.standard.set(access_token.stringValue, forKey: "access_token")
                UserDefaults.standard.set(token_type.stringValue, forKey: "token_type")
              //  UserDefaults.standard.set(data.array, forKey: "Profiledata")
                UserDefaults.standard.set(expires_at.stringValue, forKey: "expires_at")
                AppCommon.sharedInstance.saveJSON(json: data, key: "Profiledata")
                // UserDefaults.standard.array(forKey: "Profiledata")
                // print(data["email"])
                print(AppCommon.sharedInstance.getJSON("Profiledata")["phone"].stringValue)
                // let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                
                let sb = UIStoryboard(name: "Profile", bundle: nil)
                let controller = sb.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                
                
                
                self.show(controller, sender: true)
                
                
            }else if  status.stringValue == "5"{
                let message = json["message"]
                Loader.showError(message: message.stringValue )
            }
            else {
                let message = json["message"]
                Loader.showError(message: message.stringValue )
            }
            
            
        } else {
            
    let message = json["message"]
            Loader.showError(message: message.stringValue )
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


