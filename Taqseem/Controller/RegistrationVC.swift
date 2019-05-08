//
//  RegistrationVC.swift
//  Taqseem
//
//  Created by apple on 2/7/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class RegistrationVC: UIViewController {
    var http = HttpHelper()
    var type = ""
    var facebook_id = ""
    var ComeFromFaceBook = false
    let DeviceID = UIDevice.current.identifierForVendor!.uuidString
    @IBOutlet weak var passWordView: UIView!
    @IBOutlet weak var passConfirmWordView: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnOwner: UIButton!
    @IBOutlet weak var btnTeam: UIButton!
    @IBOutlet weak var btnPlayer: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self
        type = "user"
        if ComeFromFaceBook == true
        {
            passWordView.isHidden = true
             passConfirmWordView.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPlayer(_ sender: Any) {
        type = "user"
        btnPlayer.setTitleColor(.white, for: .normal)
        btnTeam.setTitleColor(.darkGray, for: .normal)
        btnOwner.setTitleColor(.darkGray, for: .normal)
    }
    
    @IBAction func btnTeam(_ sender: Any) {
        type = "team"
        btnPlayer.setTitleColor(.darkGray, for: .normal)
        btnTeam.setTitleColor(.white, for: .normal)
        btnOwner.setTitleColor(.darkGray, for: .normal)
    }
    
    @IBAction func btnOwner(_ sender: Any) {
        type = "ground_owner"
        btnPlayer.setTitleColor(.darkGray, for: .normal)
        btnTeam.setTitleColor(.darkGray, for: .normal)
        btnOwner.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        
        if validation(){
            print("valid")
            signup ()
        }
    }

    
    
    func validation () -> Bool {
        var isValid = true
        
        if ComeFromFaceBook == true
        {

        }else{
            print(txtPassword.text, txtConfirmPassword.text)
            if txtPassword.text! != txtConfirmPassword.text { Loader.showError(message: AppCommon.sharedInstance.localization("Password and Confirm password is not match!"))
                isValid = false
            }
            
            if (txtPassword.text?.count)! < 6 { Loader.showError(message: AppCommon.sharedInstance.localization("Password must be at least 6 characters long"))
                isValid = false
            }
            if txtPassword.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Password field cannot be left blank"))
                isValid = false
            }
            
        }
        
      
        
//        if (txtPhoneNumber.text?.count)! != 11  {
//            Loader.showError(message: AppCommon.sharedInstance.localization("Phone number must be between 7 and 17 characters long"))
//            isValid = false
//        }
        
        if txtPhoneNumber.text! == "" {
            Loader.showError(message: AppCommon.sharedInstance.localization("Phone field cannot be left blank"))
            isValid = false
        }
        if txtName.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Name field cannot be left blank"))
            isValid = false
        }
        if txtUserName.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Name field cannot be left blank"))
            isValid = false
        }
        if txtEmail.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Name field cannot be left blank"))
            isValid = false
        }
        
        
        return isValid
    }
    
    
    func signup () {
        
        if ComeFromFaceBook == true
        {
            
            let params = ["name":txtName.text!, "email":txtEmail.text!,"user_name":txtUserName.text!,"facebook_id": facebook_id,"phone": txtPhoneNumber.text! , "type": type,"device_id":DeviceID] as [String: Any]
            let headers = ["Accept-Type": "application/json" ,   "lang":SharedData.SharedInstans.getLanguage() , "Content-Type": "application/json"]
            AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
            http.requestWithBody(url: APIConstants.facebookregister, method: .post, parameters: params, tag: 1, header: headers)
            
            
        }else{
            let params = ["name":txtName.text!,
                          "email":txtEmail.text!,
                          "user_name":txtUserName.text!,
                          "password": txtPassword.text!,
                          "phone": txtPhoneNumber.text! ,
                          "type": type,"device_id":DeviceID] as [String: Any]
            let headers = ["Accept-Type": "application/json" ,   "lang":SharedData.SharedInstans.getLanguage() , "Content-Type": "application/json"]
            AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
            http.requestWithBody(url: APIConstants.Register, method: .post, parameters: params, tag: 1, header: headers)
        }
       
    }
}
extension RegistrationVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
        
        if Tag == 1 {
        
            let status =  json["status"]
            let message = json["message"]
            let access_token = json["access_token"]
            let token_type = json["token_type"]
            let chat_token = json["chat_token"]
            // let data = json["data"]
            let data =  JSON(json["data"])
            let expires_at = json["expires_at"]
            let code = json["code"]
            print(data)
            print(code)
            //print(json["status"])
            if status.stringValue == "2" {
                
                UserDefaults.standard.set(access_token.stringValue, forKey: "access_token")
                UserDefaults.standard.set(token_type.stringValue, forKey: "token_type")
                UserDefaults.standard.set(chat_token.stringValue, forKey: "chat_token")
                // UserDefaults.standard.set(data.array, forKey: "Profiledata")
                UserDefaults.standard.set(expires_at.stringValue, forKey: "expires_at")
                UserDefaults.standard.set(code.stringValue, forKey: "code")
                //   UserDefaults.standard.array(forKey: "Profiledata")
                AppCommon.sharedInstance.saveJSON(json: data, key: "Profiledata")
                // UserDefaults.standard.array(forKey: "Profiledata")
                // print(data["email"])
                print(AppCommon.sharedInstance.getJSON("Profiledata")["phone"].stringValue)
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "EnterVerificationCodeVC")as! EnterVerificationCodeVC
                print(UserDefaults.standard.string(forKey: "code"))
                cont.vereficationCode = UserDefaults.standard.string(forKey: "code")!
                cont.isRegister = true
                self.present(cont, animated: true, completion: nil)
                
                
               
            }else if status.stringValue == "5"{
                //let message = json["message"]
                Loader.showError(message: message.stringValue )
            } else {
                
                //let message = json["message"]
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
