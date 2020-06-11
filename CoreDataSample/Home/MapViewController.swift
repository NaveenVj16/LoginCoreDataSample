//
//  ViewController.swift
//  map-kit-tutorial-1
//
//  Created by Code Pro on 1/28/18.
//  Copyright © 2018 Code Pro. All rights reserved.


import UIKit
import MapKit
import CoreLocation


protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

internal class MapViewController: UIViewController {

    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    private var selectedPin: MKPlacemark?
   private var resultSearchController: UISearchController!
   private var previousLocation: CLLocation?
      
     private let geoCoder = CLGeocoder()
     private var directionsArray: [MKDirections] = []
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var delegate:IHomeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configureLocationServices() {
        navigationController?.navigationBar.isHidden = false
        locationManager.delegate = self
       
        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestLocation()
                let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
                resultSearchController = UISearchController(searchResultsController: locationSearchTable)
                resultSearchController.searchResultsUpdater = locationSearchTable
                let  searchBar = resultSearchController!.searchBar
                searchBar.sizeToFit()
                searchBar.placeholder = "Search for places"
                navigationItem.titleView = resultSearchController?.searchBar
                resultSearchController.hidesNavigationBarDuringPresentation = false
                resultSearchController.dimsBackgroundDuringPresentation = true
                definesPresentationContext = true
                locationSearchTable.mapView = mapView
                locationSearchTable.handleMapSearchDelegate = self
    }

    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
//    {
//        guard let selectedPin = selectedPin else { return }
//        let mapItem = MKMapItem(placemark: selectedPin)
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        mapItem.openInMaps(launchOptions: launchOptions)
//    }
    
     @objc func getDirections(){
         guard let location = locationManager.location?.coordinate else {
             //TODO: Inform user we don't have their current location
             return
         }
         
         let request = createDirectionsRequest(from: location)
         let directions = MKDirections(request: request)
         resetMapView(withNew: directions)
         
         directions.calculate { [unowned self] (response, error) in
             //TODO: Handle error if needed
             guard let response = response else { return } //TODO: Show response not available in an alert
             
             for route in response.routes {
                 self.mapView.addOverlay(route.polyline)
                 self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
             }
         }
     }
    
   private func resetMapView(withNew directions: MKDirections) {
           mapView.removeOverlays(mapView.overlays)
           directionsArray.append(directions)
           let _ = directionsArray.map { $0.cancel() }
       }
    
//    func getDirections()
    
   private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate       = getCenterLocation(for: mapView).coordinate
        let startingLocation            = MKPlacemark(coordinate: coordinate)
        let destination                 = MKPlacemark(coordinate: destinationCoordinate)
        
        let request                     = MKDirections.Request()
        request.source                  = MKMapItem(placemark: startingLocation)
        request.destination             = MKMapItem(placemark: destination)
        request.transportType           = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }

    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")

        guard let latestLocation = locations.first else { return }

        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }

        currentCoordinate = latestLocation.coordinate
    }
    
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       print("The status changed")
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print("error:: \(error)")
    }
    

}

extension MapViewController: HandleMapSearch {

    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name

        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }

        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region =  MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

}

extension MapViewController : MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{

        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button

        return pinView
    }
}

//MARK: New Mapview method
//import UIKit
//import MapKit
//

//
//class MapViewController: UIViewController {
//
//    var selectedPin: MKPlacemark?
//    var resultSearchController: UISearchController!
//
//    let locationManager = CLLocationManager()
//    //    var delegate:IHomeDelegate?
//    @IBOutlet weak var mapView: MKMapView!
//
//    var delegate:IHomeDelegate?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController.searchResultsUpdater = locationSearchTable
//        let searchBar = resultSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search for places"
//        navigationItem.titleView = resultSearchController?.searchBar
//        resultSearchController.hidesNavigationBarDuringPresentation = false
//        resultSearchController.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
//        locationSearchTable.mapView = mapView
//        locationSearchTable.handleMapSearchDelegate = self
//
//    }
//
//
//}
//
//extension MapViewController : CLLocationManagerDelegate {
//
//    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    //        print("Did get latest location")
//    //
//    //        guard let latestLocation = locations.first else { return }
//    //
//    //        if currentCoordinate == nil {
//    //            zoomToLatestLocation(with: latestLocation.coordinate)
//    //        }
//    //
//    //        currentCoordinate = latestLocation.coordinate
//    //    }
//    //
//    //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//    //       print("The status changed")
//    //        if status == .authorizedAlways || status == .authorizedWhenInUse {
//    //            beginLocationUpdates(locationManager: manager)
//    //        }
//    //    }
//
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
//
//    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: location.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
//
//
//
//}
//
//extension MapViewController: HandleMapSearch {
//
//    func dropPinZoomIn(placemark: MKPlacemark){
//        // cache the pin
//        selectedPin = placemark
//        // clear existing pins
//        mapView.removeAnnotations(mapView.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//
//        if let city = placemark.locality,
//            let state = placemark.administrativeArea {
//                annotation.subtitle = "\(city) \(state)"
//        }
//
//        mapView.addAnnotation(annotation)
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region =  MKCoordinateRegion(center: placemark.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
//
//}
//

