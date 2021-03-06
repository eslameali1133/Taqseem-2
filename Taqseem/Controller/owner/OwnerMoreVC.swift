//
//  OwnerMoreVC.swift
//  Taqseem
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class OwnerMoreVC: UIViewController {
    var Counter = ""
    let DeviceID = UIDevice.current.identifierForVendor!.uuidString
    var http = HttpHelper()
    var arrylabelimag = ["Group 1607","Group 1609","Symbol 85 – 1","Symbol 42","terms","translate","ic_exit"]
    var arrylabel1 = [
        AppCommon.sharedInstance.localization("ADD"),
        AppCommon.sharedInstance.localization("ADD"),
        AppCommon.sharedInstance.localization("NOTIFICATIONS"),
        AppCommon.sharedInstance.localization("SHARE"),
        AppCommon.sharedInstance.localization("TERMS &"),
        AppCommon.sharedInstance.localization("change"),
        AppCommon.sharedInstance.localization("LOG")
            ]
    var arrylabel2 = [
        AppCommon.sharedInstance.localization("MATCH"),
        AppCommon.sharedInstance.localization("Playground"),
        "",
        AppCommon.sharedInstance.localization("APP"),
        AppCommon.sharedInstance.localization("COUNDITIONS"),
        AppCommon.sharedInstance.localization("language"),
        AppCommon.sharedInstance.localization("OUT")]
    
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: customImageView!{
        didSet{
            imgUser.layer.cornerRadius =  imgUser.frame.width / 2
            imgUser.layer.borderWidth = 1
            //            ProfileImageView.layer.borderColor =  UIColor(red: 0, green: 156, blue: 158, alpha: 1) as! CGColor
            
            imgUser.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var TBL_Menu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TBL_Menu.dataSource = self
        TBL_Menu.delegate = self
        TBL_Menu.changeView()
        
         http.delegate = self
        GetNotificationCount()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        lblName.text = AppCommon.sharedInstance.getJSON("Profiledata")["name"].stringValue
        print(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)
        imgUser.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)")
    }
    func GetNotificationCount(){
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print("\(token_type) \(AccessToken)")
        let headers = [
            
            "Authorization" : "\(token_type) \(AccessToken)",   "lang":SharedData.SharedInstans.getLanguage()
        ]
        
        http.Get(url: APIConstants.GetNotSeenNotification, parameters:[:], Tag: 2, headers: headers)
    }
    
    
    func Logout() {
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        let headers = [
            "Authorization" : "\(token_type) \(AccessToken)",
               "lang":SharedData.SharedInstans.getLanguage() 
        ]
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: "\(APIConstants.logout)?device_id=\(DeviceID)", method: .post, tag: 1, header: headers)
        
    }
    
    func changeLanguage() {
        AppCommon.sharedInstance.alertWith(title: AppCommon.sharedInstance.localization("changeLanguage"), message: AppCommon.sharedInstance.localization("changeLanguageMessage"), controller: self, actionTitle: AppCommon.sharedInstance.localization("change"), actionStyle: .default, withCancelAction: true) {
            
            if  SharedData.SharedInstans.getLanguage() == "en" {
                L102Language.setAppleLAnguageTo(lang: "ar")
                SharedData.SharedInstans.setLanguage("ar")
                
            } else if SharedData.SharedInstans.getLanguage() == "ar" {
                L102Language.setAppleLAnguageTo(lang: "en")
                SharedData.SharedInstans.setLanguage("en")
                
            }
            UIView.appearance().semanticContentAttribute = SharedData.SharedInstans.getLanguage() == "en" ? .forceLeftToRight : .forceRightToLeft
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
         
            let storyboard = UIStoryboard.init(name: "Owner", bundle: nil); delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            
        }
    }
    }

extension OwnerMoreVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arrylabelimag.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuCell
        
        if indexPath.row == 2{
            cell.lblCounter.isHidden = false
            cell.lblCounter.text = Counter
            }
        cell.lbl_1.text = arrylabel1[indexPath.row]
        cell.lbl_2.text = arrylabel2[indexPath.row]
        cell.iconImageView.image = UIImage(named: arrylabelimag[indexPath.row])
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if indexPath.row == 0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "OwnerADDMatchVC")as! OwnerADDMatchVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 2 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "NotificationVC")as! NotificationVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 1 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "AddPlayGroundVC")as! AddPlayGroundVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 3{
                UIGraphicsBeginImageContext(view.frame.size)
                view.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                let textToShare = "Check Taqseema app"
                
                if let myWebsite = URL(string: "http://itunes.apple.com/app/id1451620043") {//Enter link to your app here
                    let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "ic_launcher")] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    //Excluded Activities
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.addToReadingList]
                    //
                    
                    activityVC.popoverPresentationController?.sourceView = self.view
                    self.present(activityVC, animated: true, completion: nil)
                    
                    
                }
            }
            else if indexPath.row == 4{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "TermsVC")as! TermsVC
                self.present(cont, animated: true, completion: nil)
            }
        
            else if indexPath.row == 6{
                
                let dialogMessage = UIAlertController(title: AppCommon.sharedInstance.localization("CONFIRM"), message: AppCommon.sharedInstance.localization("Are you sure you want to logout?"), preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: AppCommon.sharedInstance.localization("OK"), style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                    self.Logout()
                    AppCommon.sharedInstance.showlogin(vc: self)
                })
                
                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: AppCommon.sharedInstance.localization("cancel"), style: .cancel) { (action) -> Void in
                    dialogMessage.dismiss(animated: false, completion: nil)
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
        
        }
        
            else if indexPath.row == 5{
                changeLanguage()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension OwnerMoreVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        print(dictResponse)
        AppCommon.sharedInstance.dismissLoader(self.view)
        
        let json = JSON(dictResponse)
        if Tag == 1 {
            
            let status =  json["status"]
            let message = json["message"]
            
            print(json["status"])
            if status.stringValue  == "1" {
                UserDefaults.standard.removeObject(forKey: "chat_token")
                UserDefaults.standard.removeObject(forKey: "Profiledata")
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
                let notSeenCount = data["not_seen"].stringValue
                print(notSeenCount)
                Counter = notSeenCount
                TBL_Menu.reloadData()
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
