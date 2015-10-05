//
//  MapViewController.swift
//  FrontierScientistsMedia
//
//  Created by sfarabaugh on 6/30/15.
//  Copyright (c) 2015 FrontierScientists. All rights reserved.
//

import Foundation
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var resetMapButton: UIButton!
    
    @IBAction func resetMap(sender: AnyObject) {
        let startLocation = CLLocationCoordinate2D(
            //            62.89447956,-152.756170369
            latitude: 62.89447956,
            longitude: -152.756170369
        )
        let span = MKCoordinateSpanMake(20, 20)
        let region = MKCoordinateRegion(center: startLocation, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    var currentAnnotation = MKPointAnnotation()
    
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
        
        for var i:Int = 0; i < projectData.keys.count; i++ {
            let projectTitle = orderedTitles[i]
            print("projectTitle: " + projectTitle)
            let imageTitle = (projectData[projectTitle]!["preview_image"] as! String).lastPathComponent
            print("imageTitle: " + imageTitle)
            let image:UIImage = storedImages[imageTitle]!
            let latitude = projectData[projectTitle]!["latitude"] as! CLLocationDegrees
            let longitude = projectData[projectTitle]!["longitude"] as! CLLocationDegrees
            let tempLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            markerMap.location.append(tempLocation)
            markerMap.title.append((projectTitle))
            markerMap.image.append(image)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = markerMap.location[i]
            annotation.title = markerMap.title[i]
            annotation.subtitle = "Research Project: Tap picture for more"
            
            mapView.addAnnotation(annotation)
            
            markerMap.annotationDict[annotation.title!] = annotation
            
            
            print("viewDidLoad title: " + annotation.title!)
            print("viewDidLoad image:" + imageTitle)
            print("viewDidLoad index: ")
            print(i)
        }
        
        if currentLinkedProject != "" {
            print(currentLinkedProject)
            for (projectKey,projectAnnotation) in markerMap.annotationDict {
                if currentLinkedProject == projectKey {
                    currentAnnotation = projectAnnotation
                    mapView.selectAnnotation(currentAnnotation, animated: true)}}
        currentLinkedProject = ""
        }
        
//        Setting up a left bar button
//                resetMapButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "ChalkDuster", size: 20)!], forState: .Normal)
        
        netStatus = reachability.currentReachabilityStatus();
        if(netStatus.rawValue == NOTREACHABLE){
            noInternetAlert();
        }
        
    }
    
    func noInternetAlert(){
        
        let ALERTMESSAGE = "No network connection was found. Map cannot load.";
        let alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil);
        alert.show();
        
        // Delay the dismissal by 5 seconds
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alert.dismissWithClickedButtonIndex(-1, animated: true)
        })
    }
    
func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
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
            var imageTitle = (projectData[annotation.title!!]!["preview_image"])!.lastPathComponent
            toResearch.setImage(storedImages[imageTitle], forState: .Normal)
            toResearch.frame = CGRectMake(0,0,40,40)
            toResearch.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
            toResearch.titleLabel!.text = annotation.title!
            view.leftCalloutAccessoryView = toResearch
//            view.rightCalloutAccessoryView = UIImageView(image: UIImage(named: "map_icon.png"))
//            view.rightCalloutAccessoryView.frame = CGRectMake(0,0,40,40)

            print("viewForAnnotation title: " + annotation.title!!)
            print("viewForAnnotation image: " + imageTitle)
            
            return view
        }
    }
return nil
}
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        let imageTitle = (projectData[view.annotation!.title!!]!["preview_image"])!.lastPathComponent
        let toResearch = UIButton()
        toResearch.setImage(storedImages[imageTitle], forState: .Normal)
        toResearch.frame = CGRectMake(0,0,40,40)
        toResearch.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        toResearch.titleLabel!.text = view.annotation!.title!
        view.leftCalloutAccessoryView = toResearch
    }
    
    
    class MarkerMap {
        var image = [UIImage]()
        var title = [String]()
        var location = [CLLocationCoordinate2D]()
        var annotationDict = Dictionary<String, MKPointAnnotation>()
    }
    
    func pressed(sender: UIButton!){
        print("A button Press!")
        // Set currentLinkedProject to whatever name of project is
        print(sender.titleLabel!.text!)
        currentLinkedProject = sender.titleLabel!.text!
        performSegueWithIdentifier("fromMaps",sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
