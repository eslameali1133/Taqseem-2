//
//  EnterVerificationCodeVC.swift
//  Taqseem
//
//  Created by apple on 2/6/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import KKPinCodeTextField
class EnterVerificationCodeVC: UIViewController {

    var http = HttpHelper()
    var vereficationCode = ""
    var Phone = ""
    @IBOutlet weak var Text1: KKPinCodeTextField!
//        {
//        didSet{
//            Text1.layer.cornerRadius = Text1.frame.width / 2
//            Text1.clipsToBounds = true
//        }
//    }
    
    @IBOutlet weak var Text2: UITextField!
        {
        didSet{
            Text2.layer.cornerRadius = Text2.frame.width / 2
              Text2.clipsToBounds = true
        }
    }
    @IBOutlet weak var Text3: UITextField!
        {
        didSet{
            Text3.layer.cornerRadius = Text3.frame.width / 2
              Text3.clipsToBounds = true
        }
    }
    @IBOutlet weak var Text4: UITextField!
        {
        didSet{
            Text4.layer.cornerRadius = Text4.frame.width / 2
              Text4.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
http.delegate = self
        print(vereficationCode,Phone)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReset(_ sender: Any) {
        if validation(){
            ResetCode()
        }
    }
    func validation () -> Bool {
        var isValid = true
        if Text1.text! == "" {
            Loader.showError(message: AppCommon.sharedInstance.localization("Phone field cannot be left blank"))
            isValid = false
        }
        if Text1.text! != vereficationCode {
            Loader.showError(message: AppCommon.sharedInstance.localization("please enter code you received"))
            isValid = false
        }
        
        return isValid
    }
    
    func ResetCode(){
        let params = ["code": Text1.text!] as [String: Any]
        let headers = ["Accept-Type": "application/json" ,   "lang":SharedData.SharedInstans.getLanguage() , "Content-Type": "application/json"]
        print(Text1.text!)
        print(vereficationCode)
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.SendCode, method: .post, parameters: params, tag: 1, header: headers)
    }
}
extension EnterVerificationCodeVC : HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        let json = JSON(dictResponse)
          if Tag == 1 {
            let status =  json["status"]
            let token = json["token"]
            let message = json["message"]
        print(status)
            print(token)
        
                //print(json["status"])
                if status.stringValue == "2" {
                   // let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                    let sb = UIStoryboard(name: "Profile", bundle: nil)
                    let controller = sb.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                    print(json["token"].stringValue,Phone)
                    controller.Token = json["token"].stringValue
                    controller.Phone = Phone
                    self.show(controller, sender: true)

                    
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
