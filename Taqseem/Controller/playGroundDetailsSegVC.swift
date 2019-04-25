//
//  playGroundDetailsSegVC.swift
//  Taqseem
//
//  Created by apple on 2/24/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
class playGroundDetailsSegVC: UIViewController {
    
    var AlertController: UIAlertController!
    var LatBranch = 0.0
    var LngBranch = 0.0
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var Constain_IconImge_Height: NSLayoutConstraint!
    @IBOutlet weak var Constain_IconImge_Widhtt: NSLayoutConstraint!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        FillData()
        openMapdirecion()
        // Do any additional setup after loading the view.
    }
    func FillData(){
//        print(Gitem._address)
        if comedromneartoplay == "NearME"{
            lblTime.text = GNearItems._time
            lblCapacity.text = "\(GNearItems._capacity) Players"
            lblDuration.text = "\(GNearItems._duration) Hours"
            lblDate.text = GNearItems._date
            lblSalary.text = "\(GNearItems._price) SAR/H"
            lblAddress.text = GNearItems._address
        }else if comedromneartoplay == "Fav"{
            lblTime.text = GFav._time
            lblCapacity.text = "\(GFav._capacity) Players"
            lblDuration.text = "\(GFav._duration) Hours"
            lblDate.text = GFav._date
            lblSalary.text = "\(GFav._price) SAR/H"
            lblAddress.text = GFav._address
        }else{
        lblTime.text = GMatchDetails._Time
            lblCapacity.text = "\(GMatchDetails._Capacity) Players"
            lblDuration.text = "\(GMatchDetails._Duration) Hours"
            lblDate.text = GMatchDetails._Date
            lblSalary.text = "\(Gitem._price) SAR/H"
        lblAddress.text = Gitem._address
        }
        
    }
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func setupConstrin(){
//        Constain_IconImge_Height.constant = view.frame.width / 16
//        Constain_IconImge_Widhtt.constant = view.frame.width / 16
        
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
            self.LatBranch = Double(GNearItems._lat)!
            self.LngBranch = Double(GNearItems._lng)!
            
        }else if comedromneartoplay == "Fav" {
            self.LatBranch = Double(GFav._lat)!
            self.LngBranch = Double(GFav._lng)!
            
        }else{
            self.LatBranch = Double(Gitem._lat)!
            self.LngBranch = Double(Gitem._lng)!
        }
        
        //
        //        if Helper.isDeviceiPad() {
        //
        //            if let popoverController = AlertController.popoverPresentationController {
        //                popoverController.sourceView = sender
        //            }
        //        }
        //
        self.present(AlertController, animated: true, completion: nil)
    }
    
}
