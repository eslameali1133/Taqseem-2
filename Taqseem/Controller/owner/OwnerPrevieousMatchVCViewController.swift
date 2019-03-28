//
//  OwnerPrevieousMatchVCViewController.swift
//  Taqseem
//
//  Created by Husseinomda16 on 3/26/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class OwnerPrevieousMatchVCViewController: UIViewController {
        var http = HttpHelper()
        var previousR = "get-previous-requests"
        var Matchs = [MatchsModelClass]()
        var items : PlaygroundModelClass!
    
    @IBOutlet weak var tblPrevMatch: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPrevMatch.reloadData()
        tblPrevMatch.reloadData()
        tblPrevMatch.dataSource = self
        tblPrevMatch.delegate = self
        tblPrevMatch.changeView()
        http.delegate = self
        FillData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(Matchs.count)
        tblPrevMatch.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(Matchs.count)
        tblPrevMatch.reloadData()
    }
    
func FillData() {
    
    Matchs.removeAll()
    let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
    let token_type = UserDefaults.standard.string(forKey: "token_type")!
    
    let params = [
        "ground_id" : GlobalGroundDetails._id
        ] as [String: Any]
    
    let headers = [
        "Accept-Type": "application/json" ,
        "Content-Type": "application/json" ,
        "Authorization": "\(token_type) \(AccessToken)"
    ]
    
    AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
    http.requestWithBody(url: "\(APIConstants.Owner)\(previousR)", method: .post, parameters: params, tag: 1, header: headers)

    
}
}
extension OwnerPrevieousMatchVCViewController: HttpHelperDelegate {
    func receivedResponse(dictResponse: Any, Tag: Int) {
        
        if Tag == 1 {
            print(dictResponse)
            
            
            AppCommon.sharedInstance.dismissLoader(self.view)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
            
            if status.stringValue == "1" {
                
                
                let result =  json["data"].arrayValue
                for json in result{
                    let obj = MatchsModelClass(
                        ground_id: json["ground_id"].stringValue,
                        note: json["ground_image"].stringValue,
                        ground_image: json["note"].stringValue,
                        ground_name: json["ground_name"].stringValue,
                        price: json["price"].stringValue,
                        address: json["address"].stringValue,
                        user_name: json["user_name"].stringValue,
                        capacity: json["capacity"].stringValue,
                        reservation_no: json["reservation_no"].stringValue,
                        duration: json["duration"].stringValue,
                        date: json["date"].stringValue,
                        time: json["time"].stringValue,
                        reservation_type: json["reservation_type"].stringValue,
                        reservation_status: json["reservation_status"].stringValue,
                        photo: json["photo"].stringValue
                    )
                    Matchs.append(obj)
                }
                
                tblPrevMatch.reloadData()
                //Loader.showSuccess(message: message.stringValue)
                
                
                
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

extension OwnerPrevieousMatchVCViewController :UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Matchs.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPMatchCellTableViewCell", for: indexPath) as! MyPMatchCellTableViewCell
        cell.viewContent.dropShadow()
        print(Matchs[indexPath.row]._date)
        cell.lblDate.text = Matchs[indexPath.row]._date
        cell.lblUserName.text = Matchs[indexPath.row]._ground_name
        cell.lblTime.text = Matchs[indexPath.row]._time
        cell.lblUName.text = Matchs[indexPath.row]._user_name
        print(Matchs[indexPath.row]._photo)
        if Matchs[indexPath.row]._photo != "" {
            cell.imgUser.loadimageUsingUrlString(url: Matchs[indexPath.row]._photo)
        }
        
        print(Matchs[indexPath.row]._ground_image)
        if Matchs[indexPath.row]._ground_image != "" {
            cell.imgGround.loadimageUsingUrlString(url: Matchs[indexPath.row]._ground_image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "MyMatchVC")as! MyMatchVC
        cont.match = Matchs[indexPath.row]
        //cont.item = items
        cont.title = "MATCH DETAILS"
        self.present(cont, animated: true, completion: nil)
        print(123)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}

