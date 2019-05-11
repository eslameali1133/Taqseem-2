//
//  MoreVC.swift
//  Taqseem
//
//  Created by apple on 2/17/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
class MoreVC: UIViewController {
    let DeviceID = UIDevice.current.identifierForVendor!.uuidString
    var Counter = ""
    var http = HttpHelper()
    var arrylabelimagplayer = ["Symbol 85 – 1","star-1","Symbol 83 – 1","terms","translate","ic_exit"]
    var arrylabel1player = [
        AppCommon.sharedInstance.localization("NOTIFICATIONS"),
        AppCommon.sharedInstance.localization("FAVOURITES"),
        AppCommon.sharedInstance.localization("SHARE"),
        AppCommon.sharedInstance.localization("TERMS &"),
        AppCommon.sharedInstance.localization("change"),
        AppCommon.sharedInstance.localization("LOG")]
    var arrylabel2player = [
        "",
        "",
        AppCommon.sharedInstance.localization("APP"),
        AppCommon.sharedInstance.localization("COUNDITIONS"),
        AppCommon.sharedInstance.localization("language"),
        AppCommon.sharedInstance.localization("OUT")]
    
    var arrylabelimagteam = ["Symbol 85 – 1","Group 1609","Group 170","star-1","Symbol 83 – 1","terms","translate","ic_exit"]
    var arrylabel1team = [
        
        AppCommon.sharedInstance.localization("NOTIFICATIONS"),
       
        AppCommon.sharedInstance.localization("BOOKING"),
          AppCommon.sharedInstance.localization("Team"),
        AppCommon.sharedInstance.localization("FAVOURITES"),
        AppCommon.sharedInstance.localization("SHARE"),
        AppCommon.sharedInstance.localization("TERMS &"),
        AppCommon.sharedInstance.localization("change"),
        AppCommon.sharedInstance.localization("LOG")]
    var arrylabel2team = [
        
        "",
        
        AppCommon.sharedInstance.localization("Playground"),
      "",
        "",
        AppCommon.sharedInstance.localization("APP"),
        AppCommon.sharedInstance.localization("COUNDITIONS"),
        AppCommon.sharedInstance.localization("language"),
        AppCommon.sharedInstance.localization("OUT")]
    
    
    @IBOutlet weak var lblUserName: UILabel!
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
        lblUserName.text = AppCommon.sharedInstance.getJSON("Profiledata")["name"].stringValue
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
            //  let storyboard = UIStoryboard(name: "StoryBord", bundle: nil)
            let storyboard = UIStoryboard.init(name: "Player", bundle: nil);
         
            
            delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
            
        }
        
    }
    
    func modelView(controller:UIViewController,storyboardName:String,controllerName:String = "" , object:UIViewController? = nil){
        var  viewController = UIViewController()
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        if object == nil {
            viewController = storyboard.instantiateViewController(withIdentifier: controllerName)
        }else{
            viewController = object!
        }
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = storyboard.instantiateInitialViewController()
        
        
    }
    
}

extension MoreVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  memberType == "user"
        {
            return arrylabelimagplayer.count
        }else{
            return arrylabelimagteam.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuCell
        if  memberType == "user"
        {
            if indexPath.row == 0{
                cell.lblCounter.isHidden = false
                cell.lblCounter.text = Counter
            }
            
            cell.lbl_1.text = arrylabel1player[indexPath.row]
            cell.lbl_2.text = arrylabel2player[indexPath.row]
            cell.iconImageView.image = UIImage(named: arrylabelimagplayer[indexPath.row])
            
        } else{
            if indexPath.row == 0{
                cell.lblCounter.isHidden = false
                cell.lblCounter.text = Counter
            }
            cell.lbl_1.text = arrylabel1team[indexPath.row]
            cell.lbl_2.text = arrylabel2team[indexPath.row]
            cell.iconImageView.image = UIImage(named: arrylabelimagteam[indexPath.row])
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  memberType == "user"
        {
            
            
            if indexPath.row == 0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "NotificationVC")as! NotificationVC
                self.present(cont, animated: true, completion: nil)
            }
                
            else if indexPath.row == 1{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "FavaVC")as! FavaVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 2{
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
            else if indexPath.row == 3{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "TermsVC")as! TermsVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 5{
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
            else if indexPath.row == 4{
                changeLanguage()
            }
        }else
            // team action
        {
            
            
                
            if indexPath.row == 0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "NotificationVC")as! NotificationVC
                self.present(cont, animated: true, completion: nil)
            }
            
            else if indexPath.row == 1 {
                bookingplayground = true
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "BookPlayGroundVC")as! BookPlayGroundVC
                cont.FilterType = "None"
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 2{
                let storyBoard : UIStoryboard = UIStoryboard(name: "TEAM", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "MYTEAMVC")as! MYTEAMVC
                self.present(cont, animated: true, completion: nil)
            }
                
            else if indexPath.row == 3{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "FavaVC")as! FavaVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 4{
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
            else if indexPath.row == 5{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "TermsVC")as! TermsVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 7{
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
            }else if indexPath.row == 6{
                changeLanguage()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension MoreVC: HttpHelperDelegate {
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
// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}
