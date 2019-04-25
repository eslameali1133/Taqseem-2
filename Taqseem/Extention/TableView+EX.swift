//
//  TableView+EX.swift
//  Taqseem
//
//  Created by apple on 2/17/19.
//  Copyright © 2019 OnTime. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension UITableView{
    func changeView() {
        self.tableFooterView = UIView()
        self.separatorInset = .zero
        self.contentInset = .zero
    }
}

extension MKMapView {
    
    class func openMapsWith(_ location: CLLocation, completion: @escaping (_ error: NSError?)->()) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                completion(error as NSError?)
            } else {
                let placemark = MKPlacemark(placemark: placemarks!.first!)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                completion(nil)
            }
        }
    }
    
    
    
}
