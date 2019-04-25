//
//  LoginVC.swift
//  Taqseem
//
//  Created by apple on 2/6/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
var memberType = ""
var FBID = ""
import SwiftyJSON
import FBSDKLoginKit
var ChatToken = ""
class LoginVC: UIViewController , FBSDKLoginButtonDelegate{
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var facebookloginview: UIView!
    let DeviceID = UIDevice.current.identifierForVendor!.uuidString
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //let loginManager = FBSDKLoginManager()
        //loginManager.logIn(readPermissions: [.publicProfile, .email, .userFriends], viewController: self)
        if error != nil {
            print(error)
            return
        }
        if let token = FBSDKAccessToken.current(){
            fetchProfile()
        }
        print("Successfully logged in with facebook...")
    }
    

    @IBOutlet weak var lblFB: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var TXT_UserName: UITextField!
    var http = HttpHelper()
    @IBOutlet weak var Btn_Eng: UIButton!
        {
        didSet{
            Btn_Eng.layer.cornerRadius = Btn_Eng.frame.width / 2
        }
    }
    @IBOutlet weak var Btn_Ar: UIButton!
        {
        didSet{
            Btn_Ar.layer.cornerRadius = Btn_Ar.frame.width / 2
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        facebookloginview.addSubview(loginButton)
        facebookloginview.backgroundColor = UIColor.blue

        loginButton.layoutMargins.left = 0
        loginButton.layoutMargins.top = 0
        loginButton.frame = CGRect(x: -1, y: -1, width:0.86 * (mainView.frame.width), height: 0.07 * (mainView.frame.height))
        loginButton.delegate = self
        loginButton.readPermissions = ["email" , "public_profile"]
      
        http.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func fetchProfile(){
    print("fetchProfile")
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
            }
            else
            {
                print("Print entire fetched result: \(String(describing: result))")
                
                if let resultInfo = result as? [String: Any] {
                    let id = resultInfo["id"] as? String
                    print("User ID is: \(String(describing: id))")
                    FBID = id ?? ""
                    print(FBID)
                    self.FBLogin()
                }
                
                
               
        
//                let id : NSString = result.valueForKey("id") as! String
//                print("User ID is: \(id)")
                
            }
        
    })
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func LoginBtn(_ sender: Any) {
        print(DeviceID)
        if validation(){
            Login()
        }
        
    }
    func validation () -> Bool {
        var isValid = true
        
        if txtPassword.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Password field cannot be left blank"))
            isValid = false
        }
        
        
        if TXT_UserName.text! == "" {
            Loader.showError(message: AppCommon.sharedInstance.localization("User Name field cannot be left blank"))
            isValid = false
        }
        
        return isValid
    }
    
    func Login() {
        let params = ["user_name":TXT_UserName.text!,
                      "password":txtPassword.text!,
                      "device_id":DeviceID
            ] as [String: Any]
        let headers = ["Accept": "application/json" ,   "lang":SharedData.SharedInstans.getLanguage() , "Content-Type": "application/json"]
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.Login, method: .post, parameters: params, tag: 1, header: headers)
    }
    func FBLogin() {
        let params = ["facebook_id":FBID,"device_id":DeviceID] as [String: Any]
        let headers = ["Accept": "application/json" ,    "lang":SharedData.SharedInstans.getLanguage() ,"Content-Type": "application/json"]
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.facebookLogin, method: .post, parameters: params, tag: 2, header: headers)
    }
}
    
//        if TXT_UserName.text == "player"
//        {
//            memberType = "player"
//            let delegate = UIApplication.shared.delegate as! AppDelegate
//            //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let storyboard = UIStoryboard.init(name: "Player", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
//        } else if TXT_UserName.text == "team" {
//            memberType = "team"
//            let delegate = UIApplication.shared.delegate as! AppDelegate
//            //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let storyboard = UIStoryboard.init(name: "Player", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
//        }else{
//            
//            let delegate = UIApplication.shared.delegate as! AppDelegate
//            //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let storyboard = UIStoryboard.init(name: "Owner", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
//        }
    
    extension LoginVC: HttpHelperDelegate {
        func receivedResponse(dictResponse: Any, Tag: Int) {
            print(dictResponse)
            AppCommon.sharedInstance.dismissLoader(self.view)
            
            let json = JSON(dictResponse)
            if Tag == 1 {
                
                let status =  json["status"]
                let access_token = json["access_token"]
                let token_type = json["token_type"]
                let chat_token = json["chat_token"]
                let data = json["data"]
                //let data =  JSON(json["data"])
                print(status)
                print(access_token)
                print(token_type)
                print(data)
                
                print(json["status"])
                if status.stringValue  == "1" {
                    UserDefaults.standard.set(access_token.stringValue, forKey: "access_token")
                    UserDefaults.standard.set(token_type.stringValue, forKey: "token_type")
                    UserDefaults.standard.set(chat_token.stringValue, forKey: "chat_token")
                    ChatToken = UserDefaults.standard.string(forKey: "chat_token")!
                     AppCommon.sharedInstance.saveJSON(json: data, key: "Profiledata")
                   // UserDefaults.standard.array(forKey: "Profiledata")
                   // print(data["email"])
                    print(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)
                    SharedData.SharedInstans.SetIsLogin(true)
                    if data["type"] == "ground_owner"{
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        // let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                        let storyboard = UIStoryboard.init(name: "Owner", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                    }
                    else {
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        //  let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                        let storyboard = UIStoryboard.init(name: "Player", bundle: nil);
                        memberType = data["type"].stringValue
                        print(memberType)
//                        let storyboard = UIStoryboard.init(name: "Chat", bundle: nil);
//                        memberType = data["type"].stringValue
//                        print(memberType)
                        delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                    }
                    
                }else if status.stringValue  == "4" {
                    let message = json["message"]
                    Loader.showError(message: message.stringValue )
                }
                else {
                    let message = json["message"]
                    Loader.showError(message: message.stringValue)
                }
                
            }
            else if  Tag == 2 {
                let status =  json["status"]
                let access_token = json["access_token"]
                let token_type = json["token_type"]
                let data =  JSON(json["data"])
                let expires_at = json["expires_at"]
                let chat_token = json["chat_token"]
                if status.stringValue  == "4" {
                    let message = json["message"]
                    Loader.showError(message: message.stringValue )
                    let sb = UIStoryboard(name: "Profile", bundle: nil)
                    let controller = sb.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
                    controller.ComeFromFaceBook = true
                    controller.facebook_id = FBID
                    self.show(controller, sender: true)
                }
                
                else if status.stringValue  == "1" {
                    UserDefaults.standard.set(access_token.stringValue, forKey: "access_token")
                    UserDefaults.standard.set(token_type.stringValue, forKey: "token_type")
                    UserDefaults.standard.set(chat_token.stringValue, forKey: "chat_token")
//                    UserDefaults.standard.set(data.array, forKey: "Profiledata")
                    UserDefaults.standard.set(expires_at.stringValue, forKey: "expires_at")
//                    UserDefaults.standard.array(forKey: "Profiledata")
                    
                    AppCommon.sharedInstance.saveJSON(json: data, key: "Profiledata")
                
                    print(AppCommon.sharedInstance.getJSON("Profiledata")["phone"].stringValue)
                    
                    SharedData.SharedInstans.SetIsLogin(true)
                    
                    if data["type"] == "ground_owner"{
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        // let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                        let storyboard = UIStoryboard.init(name: "Owner", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                    }
                    else {
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        //  let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
                        let storyboard = UIStoryboard.init(name: "Player", bundle: nil);
                        memberType = data["type"].stringValue
                        print(memberType)
                        delegate.window?.rootViewController =
                        storyboard.instantiateInitialViewController()
                    }
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

