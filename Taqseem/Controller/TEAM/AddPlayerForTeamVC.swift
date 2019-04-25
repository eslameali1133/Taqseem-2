//
//  AddPlayerForTeamVC.swift
//  Taqseem
//
//  Created by apple on 2/28/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class AddPlayerForTeamVC: UIViewController {
    var http = HttpHelper()
    var items = [PlayerModelClass]()
    var itemSelectedid:[Int] = []
    var MemberIndex = 0
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPlayerName: UITextField!
    @IBOutlet var addViewplayer: UIView!
     @IBOutlet weak var tblPlayer: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        http.delegate = self
        
        tblPlayer.dataSource = self
        tblPlayer.delegate = self
        tblPlayer.changeView()
        
        addViewplayer.isHidden = true
        DispatchQueue.main.async {
            self.addViewplayer.frame = CGRect.init(x: 10,
                                                    y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            self.addViewplayer.center = self.view.center
            self.view.addSubview(self.addViewplayer)
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func AddPlayerBTN(_ sender: Any) {
     addViewplayer.isHidden = false
    }
    
    @IBAction func ADD_btn(_ sender: Any) {
        if validation(){
            Add()
            txtPlayerName.text = ""
            txtPhoneNumber.text = ""
        }
        addViewplayer.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillData()
        
    }
    
    func fillData()  {
        items.removeAll()
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        print(AccessToken)
        let headers: HTTPHeaders = ["Authorization" : "\(token_type) \(AccessToken)",
               "lang":SharedData.SharedInstans.getLanguage()
        ]
        http.Get(url: "\(APIConstants.GetMember)", Tag: 2, headers: headers)
    }
    
    func validation () -> Bool {
        var isValid = true
        
        
//        if (txtPhoneNumber.text?.count)! != 11  {
//            Loader.showError(message: AppCommon.sharedInstance.localization("Phone number must be between 7 and 17 characters long"))
//            isValid = false
//        }
//
        if txtPhoneNumber.text! == "" {
            Loader.showError(message: AppCommon.sharedInstance.localization("Phone field cannot be left blank"))
            isValid = false
        }
        if txtPlayerName.text! == "" { Loader.showError(message: AppCommon.sharedInstance.localization("Name field cannot be left blank"))
            isValid = false
        }
        
        
        return isValid
    }

func Add() {
    let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
    let token_type = UserDefaults.standard.string(forKey: "token_type")!
    
    let params = [
        
        "name":txtPlayerName.text!,
        "phone": txtPhoneNumber.text!
        
        ] as [String: Any]
    
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
    ]
    
    
    AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.AddMember, method: .post, parameters: params, tag: 1, header: headers)
    }
    
    
    @objc func removeService(_ sender:UIButton){
        MemberIndex = sender.tag
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this player", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.deleteRecord()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            dialogMessage.dismiss(animated: false, completion: nil)
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deleteRecord() {
        
        print(items[MemberIndex]._PlayerId)
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        
        let params = [
            
            "member_id":items[MemberIndex]._PlayerId
            
            ] as [String: Any]
        
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
        ]
        
        
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.DeleteMember, method: .post, parameters: params, tag: 3 , header: headers)
        
    }
    }

extension AddPlayerForTeamVC: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        
        if Tag == 1 {
            print(dictResponse)
            AppCommon.sharedInstance.dismissLoader(self.view)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
            let data =  JSON(json["data"])
            
            if status.stringValue == "1" {
                
                
                AppCommon.sharedInstance.saveJSON(json: data, key: "Playerdata")
                
                print(AppCommon.sharedInstance.getJSON("Playerdata")["phone"].stringValue)
                
                Loader.showSuccess(message: message.stringValue)
                 self.fillData()
            } else {
                
                Loader.showError(message: message.stringValue )
            }
        }
        else if Tag == 2 {
            print(dictResponse)
            AppCommon.sharedInstance.dismissLoader(self.view)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
            print(status)
            print(json["status"])
            if status.stringValue  == "1" {
                let result =  json["data"].arrayValue
                for json in result{
                    let obj = PlayerModelClass(
                PlayerName: json["name"].stringValue,
                PlayerId: json["id"].stringValue,
                PlayerPhone: json["phone"].stringValue,
                PlayerTeamId: json["team_id"].stringValue,
                CreatedDate: json["created_at"].stringValue,
                UpdatedDate: json["updated_at"].stringValue
                    )
                    items.append(obj)
                }
                tblPlayer.reloadData()
            } else {
                Loader.showError(message: message.stringValue)
            }
            
        } else if Tag == 3 {
            print(dictResponse)
            AppCommon.sharedInstance.dismissLoader(self.view)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
          
            
            if status.stringValue == "1" {
              
                Loader.showSuccess(message: message.stringValue)
                self.fillData()
            } else {
                
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


extension AddPlayerForTeamVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        cell.lblPlayerName.text = items[indexPath.row]._PlayerName
        cell.PlayerID = items[indexPath.row]._PlayerId
        
        cell.BtnDelete.tag = indexPath.row
        cell.BtnDelete.addTarget(self, action: #selector(self.removeService(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        print(123)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    
}

