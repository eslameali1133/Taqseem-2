//
//  NEXTMATCHVC.swift
//  Taqseem
//
//  Created by apple on 2/28/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import GooglePlaces
import MapKit
class NEXTMATCHVC: UIViewController {

    var AlertController: UIAlertController!
    var LatBranch = 0.0
    var LngBranch = 0.0
    
    var NextMatchs : MatchsModelClass!
    var Players = [PlayerModelClass]()
    var http = HttpHelper()
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var Constain_IconImge_Height: NSLayoutConstraint!
    @IBOutlet weak var Constain_IconImge_Widhtt: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        http.delegate = self
        GetNextMatchs()
        openMapdirecion()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPlayerAnotherTeam(_ sender: Any) {
        GetPlayer()
    }
    func GetPlayer(){
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print(token_type , AccessToken)
        print(AccessToken)
        let params = [
            "date":NextMatchs._date,
            "time":NextMatchs._time,
        "ground_id":NextMatchs._ground_id
            ] as [String: Any]
        
        let headers = [
            "Accept-Type": "application/json" ,
            "Content-Type": "application/json" ,
               "lang":SharedData.SharedInstans.getLanguage() ,
            "Authorization": "\(token_type) \(AccessToken)"
        ]
        
        
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        http.requestWithBody(url: APIConstants.GetPlayer, method: .post, parameters: params, tag: 1, header: headers)
    }
    func GetNextMatchs() {
        AppCommon.sharedInstance.ShowLoader(self.view,color: UIColor.hexColorWithAlpha(string: "#000000", alpha: 0.35))
        let AccessToken = UserDefaults.standard.string(forKey: "access_token")!
        let token_type = UserDefaults.standard.string(forKey: "token_type")!
        print(token_type , AccessToken)
        print(AccessToken)
        let headers: HTTPHeaders = ["Authorization" : "\(token_type) \(AccessToken)",
           "lang":SharedData.SharedInstans.getLanguage() ]
        http.Get(url: "\(APIConstants.NextMatch)", Tag: 2, headers: headers)
    }
    func openMapdirecion(){
        AlertController = UIAlertController(title:"" , message: "اختر الخريطة", preferredStyle: UIAlertController.Style.actionSheet)
        
        let Google = UIAlertAction(title: "جوجل ماب", style: UIAlertAction.Style.default, handler: { (action) in
            self.openMapsForLocationgoogle(Lat:self.LatBranch, Lng:self.LngBranch)
        })
        let MapKit = UIAlertAction(title: "الخرائط", style: UIAlertAction.Style.default, handler: { (action) in
            self.openMapsForLocation(Lat:self.LatBranch, Lng:self.LngBranch)
        })
        
        let Cancel = UIAlertAction(title: "رجوع", style: UIAlertAction.Style.cancel, handler: { (action) in
            //
        })
        
        self.AlertController.addAction(Google)
        self.AlertController.addAction(MapKit)
        self.AlertController.addAction(Cancel)
        
    }
    
    func openMapsForLocation(Lat: Double, Lng: Double) {
        let location = CLLocation(latitude: Lat, longitude: Lng)
        print(location.coordinate)
        
        MKMapView.openMapsWith(location) { (error) in
            if error != nil {
                print("Could not open maps" + error!.localizedDescription)
            }
        }
    }
    func openMapsForLocationgoogle(Lat: Double, Lng: Double) {
        let location = CLLocation(latitude: Lat, longitude: Lng)
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=\(Lat),\(Lng)&zoom=14&views=traffic&q=\(Lat),\(Lng)")!, options: [:], completionHandler: nil)
        }
        else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=\(Lat),\(Lng)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func directionsAction(_ sender: UIButton) {
        
//            self.LatBranch = Double(NextMatchs._._lat)!
//            self.LngBranch = Double(NearItems._lng)!
//            
//        
//        //
//        //        if Helper.isDeviceiPad() {
//        //
//        //            if let popoverController = AlertController.popoverPresentationController {
//        //                popoverController.sourceView = sender
//        //            }
//        //        }
//        //
//        self.present(AlertController, animated: true, completion: nil)
    }
    
}
extension NEXTMATCHVC: HttpHelperDelegate {
    func receivedErrorWithStatusCode(statusCode: Int) {
        
    }
    
    func receivedResponse(dictResponse: Any, Tag: Int) {
        
        if Tag == 2 {
            print(dictResponse)
            AppCommon.sharedInstance.dismissLoader(self.view)
            let json = JSON(dictResponse)
            print(json)
            let status =  json["status"]
            let message = json["message"]
            print(status)
            print(json["status"])
            if status.stringValue  == "1" {
               NextMatchs = MatchsModelClass(
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
                print(NextMatchs._date)
                print(json["date"].stringValue)
                lblDate.text = NextMatchs._date
                lblTime.text = NextMatchs._time
                lblSalary.text = "\(NextMatchs._price) SAR/H"
                lblAddress.text = NextMatchs._address
                lblDuration.text = "\(NextMatchs._duration) Hours"
                lblCapacity.text = "\(NextMatchs._capacity) Players"
            } else {
                Loader.showError(message: message.stringValue)
            }
        }else if Tag == 1 {
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
                    Players.append(obj)
                    
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
                let cont = storyBoard.instantiateViewController(withIdentifier: "PLAYEROTHERTEAMVC")as! PLAYEROTHERTEAMVC
                cont.Players = Players
                self.present(cont, animated: true, completion: nil)
                
            } else {
                Loader.showError(message: message.stringValue)
            }
        }
        
    }
    func retryResponse(numberOfrequest: Int) {
        
    }
}

