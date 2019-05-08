//
//  MyMatchVC.swift
//  Taqseem
//
//  Created by Husseinomda16 on 2/20/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import SwiftyJSON
import GooglePlaces
import MapKit
class MyMatchVC: AllignLocalizerVC {
    
    var AlertController: UIAlertController!
    var LatBranch = 0.0
    var LngBranch = 0.0
    
 var comeFrom = "MyMatches"
    var item : PlaygroundModelClass!
    var NearItems : NearPlayGroundModelClass!
    var FavItems : NearPlayGroundModelClass!
    var match : MatchsModelClass!
    
    @IBOutlet weak var lblGroundName: UILabel!
    
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUser: customImageView!{
        didSet{
            imgUser.layer.cornerRadius =  imgUser.frame.width / 2
            imgUser.layer.borderWidth = 1
            //            ProfileImageView.layer.borderColor =  UIColor(red: 0, green: 156, blue: 158, alpha: 1) as! CGColor
            
            imgUser.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btn_join: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var Constain_IconImge_Height: NSLayoutConstraint!
        @IBOutlet weak var Constain_IconImge_Widhtt: NSLayoutConstraint!
    
    @IBOutlet weak var Constain_profileImge_Height: NSLayoutConstraint!
    @IBOutlet weak var Constain_profileImge_Widhtt: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let Ararrow = UIImage(named: "down-arrow-1")
        let EnArarrow = UIImage(named: "down-arrow-2")
        if SharedData.SharedInstans.getLanguage() == "ar"{
            btnArrow.setImage(Ararrow , for: .normal)
        }else{
            btnArrow.setImage(EnArarrow , for: .normal)
        }
        openMapdirecion()
       // print(item._address)
//        setupConstrin()
        if comeFrom == "MyMatches"{
            lbl_title.text = "My Matches"
        }else{
        lbl_title.text = title
        }
        btn_join.isHidden = true
        
        if comedromneartoplay == "NearME"
        {
              btn_join.isHidden = false
            lbl_title.text = "NEAR ME"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPlayer(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Owner", bundle:nil)
        let cont = storyBoard.instantiateViewController(withIdentifier: "OwnerRequestPlayersVC")as! OwnerRequestPlayersVC
        if comedromneartoplay == "NearME" {
            cont.ReservationNum = NearItems._reservation_no
           
        }else {
        cont.ReservationNum = match._reservation_no
        }
        self.present(cont, animated: true, completion: nil)

    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func setupConstrin(){
        Constain_IconImge_Height.constant = view.frame.width / 16
        Constain_IconImge_Widhtt.constant = view.frame.width / 16
        
        Constain_profileImge_Height.constant = view.frame.width / 5.6
        Constain_profileImge_Widhtt.constant = view.frame.width / 5.6
    }
    override func viewWillAppear(_ animated: Bool) {
        fillData()
    }
    
    func fillData() {
        if comedromneartoplay == "NearME" {
            lblTime.text = "\(NearItems._time)"
            lblGroundName.text = NearItems._name
            lblDate.text = NearItems._date
            lblSalary.text = "\(NearItems._price) SAR"
            lblAddress.text = NearItems._address
            lblCapacity.text = "\(NearItems._capacity) Players"
            lblDuration.text = "\(NearItems._duration) Hours"
            lblUserName.isHidden = true
            imgUser.isHidden = true
            
             GNearItems = NearItems
            
        }else {
        lblTime.text = "\(match._time)"
        lblGroundName.text = match._ground_name
        lblDate.text = match._date
        lblSalary.text = "\(match._price) SAR"
        lblAddress.text = match._address
        lblCapacity.text = "\(match._capacity) Players"
        lblDuration.text = "\(match._duration) Hours"
        lblUserName.text = match._user_name
        if match._photo != ""
        {
        imgUser.loadimageUsingUrlString(url:"\(APIConstants.Base_Image_URL)\(match._photo)")
        }
        }}
   
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
        
        if comedromneartoplay == "NearME" {
            self.LatBranch = Double(NearItems._lat)!
            self.LngBranch = Double(NearItems._lng)!
            self.present(AlertController, animated: true, completion: nil)
        }
        
        //
        //        if Helper.isDeviceiPad() {
        //
        //            if let popoverController = AlertController.popoverPresentationController {
        //                popoverController.sourceView = sender
        //            }
        //        }
        //
        
    }
    
}
