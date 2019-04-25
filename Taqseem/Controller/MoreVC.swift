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
    var http = HttpHelper()
    var arrylabelimagplayer = ["Group 1607","Symbol 85 – 1","Group 1673","star-1","Symbol 83 – 1","terms","ic_exit","ic_exit"]
    var arrylabel1player = [
        AppCommon.sharedInstance.localization("ADD"),
        AppCommon.sharedInstance.localization("NOFIFICATIONS"),
        AppCommon.sharedInstance.localization("MY"),
        AppCommon.sharedInstance.localization("FAVOURITES"),
        AppCommon.sharedInstance.localization("SHARE"),
        AppCommon.sharedInstance.localization("TERMS &"),
        AppCommon.sharedInstance.localization("LOGOUT"),
        AppCommon.sharedInstance.localization("Change language")]
    var arrylabel2player = [
        AppCommon.sharedInstance.localization("MATCH"),
        "",
        AppCommon.sharedInstance.localization("MATCHES"),
        "",
        AppCommon.sharedInstance.localization("APP"),
        AppCommon.sharedInstance.localization("COUNDITIONS"),
        "",
        ""]
    
    
    var arrylabelimagteam = ["Group 1607","Group 1610","Symbol 85 – 1","Group 1673","Group 1608","Group 1609","Group 170","star-1","Symbol 83 – 1","terms","ic_exit","ic_exit"]
    var arrylabel1team = [
        AppCommon.sharedInstance.localization("ADD"),
        AppCommon.sharedInstance.localization("NEAR"),
        AppCommon.sharedInstance.localization("NOFIFICATIONS"),
        AppCommon.sharedInstance.localization("MY"),
        AppCommon.sharedInstance.localization("PLAY"),
        AppCommon.sharedInstance.localization("BOOKING"),
        AppCommon.sharedInstance.localization("MY"),
        AppCommon.sharedInstance.localization("FAVOURITES"),
        AppCommon.sharedInstance.localization("SHARE"),
        AppCommon.sharedInstance.localization("TERMS &"),
        AppCommon.sharedInstance.localization("LOGOUT"),
        AppCommon.sharedInstance.localization("Change language")]
    var arrylabel2team = [
        AppCommon.sharedInstance.localization("MATCH"),
        AppCommon.sharedInstance.localization("you"),
        "",
        AppCommon.sharedInstance.localization("MATCHES"),
        AppCommon.sharedInstance.localization("NOW"),
        AppCommon.sharedInstance.localization("PLAYGROUND"),
        AppCommon.sharedInstance.localization("TEAM"),
        "",
        AppCommon.sharedInstance.localization("APP"),
        AppCommon.sharedInstance.localization("COUNDITIONS"),
        "",
        ""]
    
    
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
        lblUserName.text = AppCommon.sharedInstance.getJSON("Profiledata")["name"].stringValue
        print(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)
        imgUser.loadimageUsingUrlString(url: "\(APIConstants.Base_Image_URL)\(AppCommon.sharedInstance.getJSON("Profiledata")["photo"].stringValue)")
        TBL_Menu.dataSource = self
        TBL_Menu.delegate = self
        TBL_Menu.changeView()
        
        http.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func Logout() {
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        
        let headers = [
            "Authorization" : "\(token_type) \(AccessToken)"
        ]
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: "\(APIConstants.logout)?device_id=\(DeviceID)", method: .post, tag: 1, header: headers)
    }
    
    
    func changeLanguage() {
        AppCommon.sharedInstance.alertWith(title: AppCommon.sharedInstance.localization(""), message: AppCommon.sharedInstance.localization(""), controller: self, actionTitle: AppCommon.sharedInstance.localization(""), actionStyle: .default, withCancelAction: true) {
            
            if  SharedData.SharedInstans.getLanguage() == "en" {
                L102Language.setAppleLAnguageTo(lang: "ar")
                SharedData.SharedInstans.setLanguage("ar")
                
            } else if SharedData.SharedInstans.getLanguage() == "ar" {
                L102Language.setAppleLAnguageTo(lang: "en")
                SharedData.SharedInstans.setLanguage("en")
                
            }
            UIView.appearance().semanticContentAttribute = SharedData.SharedInstans.getLanguage() == "en" ? .forceLeftToRight : .forceRightToLeft
            
        }
        
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
            
            cell.lbl_1.text = arrylabel1player[indexPath.row]
            cell.lbl_2.text = arrylabel2player[indexPath.row]
            cell.iconImageView.image = UIImage(named: arrylabelimagplayer[indexPath.row])
            
        } else{
            
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
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "AddMatchVC")as! AddMatchVC
                self.present(cont, animated: true, completion: nil)
            }
                
            else if indexPath.row == 2 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchesTableVC")as! MyMatchesTableVC
                self.present(cont, animated: true, completion: nil)
            }
                
            else if indexPath.row == 3{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "FavaVC")as! FavaVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 5{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "TermsVC")as! TermsVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 6{
                Logout()
                AppCommon.sharedInstance.showlogin(vc: self)
            }
            else if indexPath.row == 7{
                changeLanguage()
            }
        }else
            // team action
        {
            
            if indexPath.row == 0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "AddMatchVC")as! AddMatchVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 1 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "NearMeVC")as! NearMeVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 3 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchesTableVC")as! MyMatchesTableVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 4 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "BookPlayGroundVC")as! BookPlayGroundVC
                cont.FilterType = ""
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 5 {
                bookingplayground = true
                let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "BookPlayGroundVC")as! BookPlayGroundVC
                cont.FilterType = "None"
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 6{
                let storyBoard : UIStoryboard = UIStoryboard(name: "TEAM", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "MYTEAMVC")as! MYTEAMVC
                self.present(cont, animated: true, completion: nil)
            }
                
            else if indexPath.row == 7{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Player", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "FavaVC")as! FavaVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 9{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "TermsVC")as! TermsVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 10{
                Logout()
                AppCommon.sharedInstance.showlogin(vc: self)
            }else if indexPath.row == 11{
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
                SharedData.SharedInstans.SetIsLogin(false)
                Loader.showSuccess(message: message.stringValue)
            }
            else {
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
