//  MapViewController.swift

import Foundation
import MapKit

/*
    This is the MapViewController class, responsable for displaying an MKMapView of Alaska,
    along with markers at the longitude/latitude points of each project, specified in 
    projectData. Each marker is displayed as a diamond icon and, when pressed, expands into
    a quick preview of the project for that location. Selecting the expanded marker navigates
    the user to the specified project page in the Research section.
*/
class MapViewController: UIViewController, MKMapViewDelegate {

/*
    Outlets
*/
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resetMap: UIBarButtonItem!
/*
    Actions
*/
    @IBAction func resetMap(sender: AnyObject) {
        let region = MKCoordinateRegion(center: startLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
/*
    Class Constants
*/
    let startLocation = CLLocationCoordinate2D(latitude: 62.89447956, longitude: -152.756170369)
    let span = MKCoordinateSpanMake(20, 20)
/*
    Class Variables
*/
    var currentAnnotation = MKPointAnnotation()
    let markerMap = MarkerMap()
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = MKMapType.Hybrid
        mapView.delegate = self
        resetMap(self);

        
        // For each project, grab the latitude and longitude data from projectData and create a marker.
        var index = 0
        for RP in RPMap {

            let image = RP.image
            let latitude = RP.mapData.lat 
            let longitude = RP.mapData.long
            let tempLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            markerMap.location.append(tempLocation)
            markerMap.title.append(RP.title)
            markerMap.image.append(image)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = tempLocation
            annotation.title = RP.title
            annotation.subtitle = "Research Project: Tap picture for more"
            
            mapView.addAnnotation(annotation)
            markerMap.annotationDict[index] = annotation
            
            markerMap.titleToIndex[RP.title] = index

            index += 1
        }
        
        if currentLinkedProject != -1 {
            for (projectKey, projectAnnotation) in markerMap.annotationDict {
                if currentLinkedProject == projectKey {
                    currentAnnotation = projectAnnotation
                    mapView.selectAnnotation(currentAnnotation, animated: true)
                }
            }
            // currentLinkedProject = -1
        }
        
        // Do an internet check
        netStatus = reachability.currentReachabilityStatus();
        if(netStatus.rawValue == NOTREACHABLE){
            noInternetAlert();
        }
    }

/*
    MapView Functions
*/
    // viewForAnnotation
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView
        if let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") {
            pinView.annotation = annotation
            view = pinView
            view.image = UIImage(named: "diamond_blue.png")
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view.image = UIImage(named: "diamond_blue.png")
            view.canShowCallout = true
            let toResearch = UIButton()
             toResearch.setImage(RPMap[markerMap.titleToIndex[annotation.title!!]!].image, forState: .Normal)
            toResearch.frame = CGRectMake(0,0,40,40)
            toResearch.addTarget(self, action: #selector(MapViewController.pressed(_:)), forControlEvents: .TouchUpInside)
             toResearch.titleLabel!.text = RPMap[markerMap.titleToIndex[annotation.title!!]!].title
            view.leftCalloutAccessoryView = toResearch
        }
        return view
    }
    // didSelectAnnotationView
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        let toResearch = UIButton()
         toResearch.setImage(RPMap[markerMap.titleToIndex[view.annotation!.title!!]!].image, forState: .Normal)
        toResearch.frame = CGRectMake(0,0,40,40)
        toResearch.addTarget(self, action: #selector(MapViewController.pressed(_:)), forControlEvents: .TouchUpInside)
         toResearch.titleLabel!.text = RPMap[markerMap.titleToIndex[view.annotation!.title!!]!].title
        print(view.annotation!.title!!)
        view.leftCalloutAccessoryView = toResearch
    }
    
/*
    Helper and Content Functions
*/
    // noInternetAlert
    // This function simply displays then dismisses an alert
    func noInternetAlert() {
        let ALERTMESSAGE = "No network connection was found. Map cannot load."
        let alert = UIAlertView(title: "", message: ALERTMESSAGE, delegate: self, cancelButtonTitle: nil)
        alert.show()
        delayDismissal(alert)
    }
    // pressed
    // This function is called when an expanded marker is selected. It simply sets currentLinkedProject to
    // the title of the project of the selected marker.
    func pressed(sender: UIButton!) {
        currentLinkedProject = markerMap.titleToIndex[sender.titleLabel!.text!]!
        print(currentLinkedProject)
        performSegueWithIdentifier("fromMaps",sender: nil)
    }
    
/*
    This is the MarkerMap class, a very simple class that represents a marker and includes member variable that
    store needed data for any given marker.
*/
    class MarkerMap {
    
    /*
        Class Member Variables
    */
        var image = [UIImage]()
        var title = [String]()
        var location = [CLLocationCoordinate2D]()
        var annotationDict = Dictionary<Int, MKPointAnnotation>()
        var titleToIndex = Dictionary<String,Int>()
    }
}
