//
//  MapViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/30/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import Foundation
import MapKit

class MarkerMap {
    var image = [UIImage]()
    var title = [String]()
    var location = [CLLocationCoordinate2D]()
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startLocation = CLLocationCoordinate2D(
//            62.89447956,-152.756170369
            latitude: 62.89447956,
            longitude: -152.756170369
        )
    
        mapView.mapType = MKMapType.Hybrid
        mapView.delegate = self
        
        let span = MKCoordinateSpanMake(20, 20)
        let region = MKCoordinateRegion(center: startLocation, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let markerMap = MarkerMap()
        
        for var i:Int = 0; i < projectData.keys.array.count; i++ {
            var projectTitle = orderedTitles[i]
            var imageTitle = (projectData[projectTitle]!["preview_image"] as! String).lastPathComponent
            var image:UIImage = storedImages[imageTitle]!
            var latitude = projectData[projectTitle]!["latitude"] as! CLLocationDegrees
            var longitude = projectData[projectTitle]!["longitude"] as! CLLocationDegrees
            
            var tempLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            markerMap.location.append(tempLocation)
            markerMap.title.append((projectTitle))
            markerMap.image.append(image)
            
        let annotation = MKPointAnnotation()
            annotation.coordinate = markerMap.location[i]
            annotation.title = markerMap.title[i]
            annotation.subtitle = "Research Project: Tap for more"
            mapView.addAnnotation(annotation)
        }
    }
func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if let annotationn = annotation{
            var view: MKAnnotationView
        if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin"){
            pinView.annotation = annotation
            view = pinView
            view.image = UIImage(named: "diamond_blue.png")
            return view
        }
        else
        {   view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view.image = UIImage(named: "diamond_blue.png")
            view.canShowCallout = true
            let toResearch = UIButton()
            toResearch.setImage(UIImage(named: "research_icon.png"), forState: .Normal)
            toResearch.frame = CGRectMake(0,0,40,40)
            toResearch.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
            view.rightCalloutAccessoryView = toResearch
//            view.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "map_icon.png"))
//            view.rightCalloutAccessoryView.frame = CGRectMake(0,0,40,40)

            return view
        }
    }
return nil
}
    func pressed(sender: UIButton!){
        println("A button Press!")
        performSegueWithIdentifier("fromMaps",sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
