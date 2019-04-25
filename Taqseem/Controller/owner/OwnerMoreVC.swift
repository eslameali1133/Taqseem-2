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

    let DeviceID = UIDevice.current.identifierForVendor!.uuidString
    var http = HttpHelper()
    var arrylabelimag = ["Group 1607","Group 1609","Symbol 85 – 1","Symbol 42","terms","ic_exit"]
    var arrylabel1 = ["ADD","ADD","NOFIFICATIONS","SHARE","TERMS &","LOGOUT"]
    var arrylabel2 = ["MATCH","PLAYGROUND","","APP","COUNDITIONS",""]
    
    var arrylabel1Arabic = ["الخروج","الصلاحيات","أنشر","الإشعارات","أضف","أضف"]
    var arrylabel2Arabic = ["والشروط","التطبيق","","ملعب","مباراة",""]
    
    
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
        lblName.text = AppCommon.sharedInstance.getJSON("Profiledata")["name"].stringValue
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
            "Authorization" : "\(token_type) \(AccessToken)",
               "lang":SharedData.SharedInstans.getLanguage() 
        ]
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: "\(APIConstants.logout)?device_id=\(DeviceID)", method: .post, tag: 1, header: headers)
    }
    
}

extension OwnerMoreVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arrylabelimag.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuCell
       
        if SharedData.SharedInstans.getLanguage() == "en"
        {
            cell.lbl_1.text = arrylabel1[indexPath.row]
            cell.lbl_2.text = arrylabel2[indexPath.row]
            cell.iconImageView.image = UIImage(named: arrylabelimag[indexPath.row])
            
        }else{
            cell.lbl_1.text = arrylabel1Arabic[indexPath.row]
            cell.lbl_2.text = arrylabel2Arabic[indexPath.row]
            cell.iconImageView.image = UIImage(named: arrylabelimag[indexPath.row])
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if indexPath.row == 0 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "OwnerADDMatchVC")as! OwnerADDMatchVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 1 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "AddPlayGroundVC")as! AddPlayGroundVC
                self.present(cont, animated: true, completion: nil)
            }
            else if indexPath.row == 4{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Profile", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "TermsVC")as! TermsVC
                self.present(cont, animated: true, completion: nil)
            }
        
            else if indexPath.row == 5{
                Logout()
                AppCommon.sharedInstance.showlogin(vc: self)
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
