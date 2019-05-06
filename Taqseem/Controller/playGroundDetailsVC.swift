//
//  playGroundDetailsVC.swift
//  Taqseem
//
//  Created by apple on 2/24/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
var GMatchDetails : MatchDetailsModelClass!
var Gitem : PlaygroundModelClass!
var GNearItems : NearPlayGroundModelClass!
var GFav : NearPlayGroundModelClass!
class playGroundDetailsVC: UIViewController , shareLocationDelegateFilter {
    func shareLocationDelegate(lat: String, Long: String) {
        
    }
    var LatBranch = 0.0
    var LngBranch = 0.0
    var AlertController: UIAlertController!
    var MatchDetails : MatchDetailsModelClass!
    var item : PlaygroundModelClass!
    var NearItems : NearPlayGroundModelClass!
    var FavItem : NearPlayGroundModelClass!
    
    @IBAction func btnArrow(_ sender: Any) {
    }
    @IBOutlet weak var Constain_IconImge_Height: NSLayoutConstraint!
    @IBOutlet weak var Constain_IconImge_Widhtt: NSLayoutConstraint!
    
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstrin()
        fillData()
        openMapdirecion()
        
        
   //     print(item._address)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLocation(_ sender: Any) {
        }
    
    @IBAction func btnChoose(_ sender: Any) {
        print(123)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Match", bundle:nil)
//                   let cont = storyBoard.instantiateViewController(withIdentifier: "PaidVC")as! PaidVC
//       // self.show(cont, sender: true)
//             self.present(cont, animated: true, completion: nil)
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func setupConstrin(){
        Constain_IconImge_Height.constant = view.frame.width / 16
        Constain_IconImge_Widhtt.constant = view.frame.width / 16
    
    }
    func fillData(){
        
        lblLocation.text = ""
        if comedromneartoplay == "NearME" {
            lblName.text = NearItems._name
            lblSalary.text = "\(NearItems._price) SAR/h"
            lblAddress.text = NearItems._address
            
            lblCapacity.text = "\(NearItems._capacity) Players"
            lblDuration.text = "\(NearItems._duration) Hours"
            lblTime.text = NearItems._time
            lblDate.text = NearItems._date
            GNearItems = NearItems
        }else if comedromneartoplay == "Fav" {
        lblName.text = FavItem._name
        lblSalary.text = "\(FavItem._price) SAR/h"
        lblAddress.text = FavItem._address
        
        lblCapacity.text = "\(FavItem._capacity) Players"
        lblDuration.text = "\(FavItem._duration) Hours"
        lblTime.text = FavItem._time
        lblDate.text = FavItem._date
        
        GFav = FavItem
            print(FavItem._duration)
        //GMatchDetails = MatchDetails
        }
        else {
            lblName.text = item._name
            lblSalary.text = "\(item._price) SAR/h"
            lblAddress.text = item._address
            
            lblCapacity.text = "\(MatchDetails._Capacity) Players"
            lblDuration.text = "\(MatchDetails._Duration) Hours"
            lblTime.text = MatchDetails._Time
            lblDate.text = MatchDetails._Date
            
            Gitem = item
            GMatchDetails = MatchDetails
        }
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
        
        if comedromneartoplay == "NearME" {
            self.LatBranch = Double(NearItems._lat)!
            self.LngBranch = Double(NearItems._lng)!
            
        }else if comedromneartoplay == "Fav" {
            self.LatBranch = Double(FavItem._lat)!
            self.LngBranch = Double(FavItem._lng)!
            
            }else{
                self.LatBranch = Double(item._lat)!
                self.LngBranch = Double(item._lng)!
            }
        


        self.present(AlertController, animated: true, completion: nil)
    }
    
}
