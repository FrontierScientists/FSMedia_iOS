//
//  MapViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/30/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(
//            62.89447956,-152.756170369
            latitude: 62.89447956,
            longitude: -152.756170369
        )
    
        mapView.mapType = MKMapType.Hybrid
        
        let span = MKCoordinateSpanMake(20, 20)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
//        let annotation = MKPointAnnotation()
//        annotation.setCoordinate(location)
//        annotation.title = "Big Ben"
//        annotation.subtitle = "London"
        
//        mapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
