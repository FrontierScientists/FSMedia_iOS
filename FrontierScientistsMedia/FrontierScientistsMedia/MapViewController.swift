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
    @IBOutlet weak var resetMapButton: UIButton!
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
    
/*
    Class Functions
*/
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = MKMapType.Hybrid
        mapView.delegate = self
        resetMap(self);
        let markerMap = MarkerMap()
        
        // For each project, grab the latitude and longitude data from projectData and create a marker.
        for projectTitle in orderedTitles {
            let imageURL = NSURL(fileURLWithPath: projectData[projectTitle]!["preview_image"] as! String)
            let imageTitle = imageURL.lastPathComponent
            let image:UIImage = storedImages[imageTitle!]!
            let latitude = projectData[projectTitle]!["latitude"] as! CLLocationDegrees
            let longitude = projectData[projectTitle]!["longitude"] as! CLLocationDegrees
            let tempLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            markerMap.location.append(tempLocation)
            markerMap.title.append(projectTitle)
            markerMap.image.append(image)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = tempLocation
            annotation.title = projectTitle
            annotation.subtitle = "Research Project: Tap picture for more"
            
            mapView.addAnnotation(annotation)
            markerMap.annotationDict[annotation.title!] = annotation
        }
        
        if currentLinkedProject != "" {
            for (projectKey, projectAnnotation) in markerMap.annotationDict {
                if currentLinkedProject == projectKey {
                    currentAnnotation = projectAnnotation
                    mapView.selectAnnotation(currentAnnotation, animated: true)
                }
            }
            currentLinkedProject = ""
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
            let imageTitle = (projectData[annotation.title!!]!["preview_image"])!.lastPathComponent
            toResearch.setImage(storedImages[imageTitle], forState: .Normal)
            toResearch.frame = CGRectMake(0,0,40,40)
            toResearch.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
            toResearch.titleLabel!.text = annotation.title!
            view.leftCalloutAccessoryView = toResearch
        }
        return view
    }
    // didSelectAnnotationView
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        let imageTitle = (projectData[view.annotation!.title!!]!["preview_image"])!.lastPathComponent
        let toResearch = UIButton()
        toResearch.setImage(storedImages[imageTitle], forState: .Normal)
        toResearch.frame = CGRectMake(0,0,40,40)
        toResearch.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        toResearch.titleLabel!.text = view.annotation!.title!
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
        currentLinkedProject = sender.titleLabel!.text!
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
        var annotationDict = Dictionary<String, MKPointAnnotation>()
    }
}
