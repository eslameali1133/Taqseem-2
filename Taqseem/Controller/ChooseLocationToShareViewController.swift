//
//  ChooseLocationToShareViewController.swift
//  Handsy
//
//  Created by Ahmed Wahdan on 7/23/18.
//  Copyright © 2018 Ahmed Wahdan. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import CoreLocation
import MapKit

class ChooseLocationToShareViewController: UIViewController, CLLocationManagerDelegate {
    var AlertController: UIAlertController!
    @IBOutlet weak var BtnmapType: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchViewOut: UIView!{
        didSet {
            self.searchViewOut.layer.cornerRadius = 4.0
            self.searchViewOut.layer.borderWidth = 0.5
            self.searchViewOut.layer.borderColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1)
        }
    }
    @IBOutlet weak var searchBtn: UIButton!
    @IBAction func DismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var confirmBtn: UIButton!{
        didSet{
            self.confirmBtn.layer.cornerRadius = 25.0
        }
    }
    @IBOutlet weak var confirmSearchBtn: UIButton!{
        didSet{
            self.confirmSearchBtn.layer.cornerRadius = 25.0
        }
    }
    
    let locationManager = CLLocationManager()
    var marker: GMSMarker?
    
    var latu = ""
    var long = ""
    var lat = ""
    var lng = ""
    var LatBranch = 0.0
       var LngBranch = 0.0
    var address = ""
    var shareLocationDelegate: shareLocationDelegate?
    var shareLocationDelegateFilt: shareLocationDelegateFilter?
    var isfilter = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
      locationManager.requestWhenInUseAuthorization()
        confirmSearchBtn.isHidden = true
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
     
      mapView.mapType = .satellite
        if mapView.mapType == .satellite {
            BtnmapType.setImage(#imageLiteral(resourceName: "Group_1404"), for: .normal)
         
        }else {
          
              BtnmapType.setImage(#imageLiteral(resourceName: "Group_1404-1"), for: .normal)
        }
    }
    
    @IBAction func mylocationBtn(_ sender: Any) {
        let lat = self.mapView.myLocation?.coordinate.latitude
        let lng = self.mapView.myLocation?.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat! ,longitude: lng! , zoom: 14)
        self.mapView.animate(to: camera)
    }
    
    @IBAction func mapTypeAction(_ sender: UIButton) {
        if mapView.mapType == .satellite {
          
         BtnmapType.setImage(#imageLiteral(resourceName: "Group_1404-1"), for: .normal)
            mapView.mapType = .terrain
        }else {
           
           BtnmapType.setImage(#imageLiteral(resourceName: "Group_1404"), for: .normal)
            mapView.mapType = .satellite
        }
    }

    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        //        marker.icon = GMSMarker.markerImage(with: .black)
        
        print("Tapped at coordinate: " + String(coordinate.latitude) + " "
            + String(coordinate.longitude))
        
        //        // Zoom in one zoom level
        //        zoom = "\(zoomCamera)"
        //        print(zoom + "zoom")
        if self.marker == nil {
            self.marker = GMSMarker(position: coordinate)
        } else {
            self.marker?.position = coordinate
        }
        marker!.map = mapView
//        reverseGeocodeCoordinate(coordinate)
        map(l: coordinate.latitude, lng: coordinate.longitude, Z: 17.0, title: "")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        reverseGeocodeCoordinate(marker.position)
        return false
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        self.lat = String(coordinate.latitude)
        self.lng = String(coordinate.longitude)
        print("la: \(self.lat)"+"lng: \(self.lng)")
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            self.marker?.title = lines.joined(separator: "\n")
            self.address = lines.joined(separator: "\n")
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    func map(l: Double, lng: Double, Z: Float, title: String) {
        print("\(Z)" + "zoom")
        confirmSearchBtn.isHidden = false
        let target = CLLocationCoordinate2D(latitude: l, longitude: lng)
        mapView.animate(toLocation: target)
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        var zooml = Z
        if zooml == 0.0 {
            zooml = 20
            mapView.animate(toZoom: zooml)
        }else {
            mapView.animate(toZoom: Z)
        }
        self.latu = String(l)
        self.long = String(lng)
        print("la: \(self.latu)"+"lng: \(self.long)")
        if self.marker == nil {
            self.marker = GMSMarker(position: target)
        } else {
            self.marker?.position = target
        }
        
        marker!.title = title
        marker!.map = mapView
    }
    
    @IBAction func confirmMyLocationBtn(_ sender: UIButton) {
        if lat != "" && lng != "" {
            print("lat: \(lat)")
            if isfilter == true
            {
                isfilter = false
                self.shareLocationDelegateFilt?.shareLocationDelegate(lat: lat, Long: lng)
            }else{
            self.shareLocationDelegate?.shareLocationDelegate(lat: lat, Long: lng)
            }
//            self.dismiss(animated: false, completion: nil)
           self.dismiss(animated: true, completion: nil)
        }else {
            
        }
    }
    
    @IBAction func confirmSearchLocationBtn(_ sender: UIButton) {
        if latu != "" && long != "" {
            print("lat: \(latu)")
            if isfilter == true
            {
                 isfilter = false
                self.shareLocationDelegateFilt?.shareLocationDelegate(lat: lat, Long: lng)
            }else{
                self.shareLocationDelegate?.shareLocationDelegate(lat: lat, Long: lng)
            }
//            self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
        }else {
            
        }
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
         self.tabBarController?.tabBar.isHidden = false
       navigationController?.popViewController(animated: true)
    }
    
    //////////////////
  
}

extension ChooseLocationToShareViewController: GMSAutocompleteViewControllerDelegate, GMSMapViewDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        searchBtn.setTitle(place.name, for: .normal)
        map(l: place.coordinate.latitude, lng: place.coordinate.longitude, Z: 17.0, title: place.formattedAddress!)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Here you verify the user has granted you permission while the app is in use.
        
        if status == .authorizedWhenInUse {
            
            // Once permissions have been established, ask the location manager for updates on the user’s location.
            
            locationManager.startUpdatingLocation()
            
            // GMSMapView has two features concerning the user’s location: myLocationEnabled draws a light blue dot where the user is located, while myLocationButton, when set to true, adds a button to the map that, when tapped, centers the map on the user’s location.
            
            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
            mapView.settings.zoomGestures = true
        }
    }
    
    
    // locationManager(_:didUpdateLocations:) executes when the location manager receives new location data.
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // This updates the map’s camera to center around the user’s current location. The GMSCameraPosition class aggregates all camera position parameters and passes them to the map for display.
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
            
            // Tell locationManager you’re no longer interested in updates; you don’t want to follow a user around as their initial location is enough for you to work with.
            
            // Create marker and set location
            if self.marker == nil {
//                self.marker = GMSMarker(position: location.coordinate)
            } else {
                self.marker?.position = location.coordinate
            }
            self.marker?.map = self.mapView
            
            locationManager.stopUpdatingLocation()
        }
        
    }
}

