//
//  MapViewController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 21/12/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MapKitGoogleStyler

class MapViewController: UIViewController
{
    var poi_coordinates = [String:CLLocationCoordinate2D]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureTileOverlay()
        setuppoi()
        setupView()
        checkLocationServices()
        mapKitView.delegate = self
        //setupDirection()
    }
    
    //*****Declarations*****//
    let annotation = MKPointAnnotation()
    var polyline = MKPolyline()
    var currentPolylineOverlay = [MKPolyline]()
    let locationManager = CLLocationManager()
    
    let mapKitView:MKMapView={
        let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isRotateEnabled = true
        map.isPitchEnabled = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsPointsOfInterest = false
        return map
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(searchPlaces), for: .touchUpInside)
        return button
      }()
    
    let myLocation: UIButton = {
      let button = UIButton()
      button.setTitle("My Location", for: .normal)
      button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.layer.cornerRadius = 5
      button.setTitleColor(.systemBlue, for: .normal)
      button.addTarget(self, action: #selector(currentLocation), for: .touchUpInside)
      return button
    }()
    
    let searchController:UISearchController? = nil
    
    let suggestionTable = LocationSearchTableViewController()
    
    //*********Start of functions*********//
    
    @objc func searchPlaces() {
        if currentPolylineOverlay.count != 0
        {
            mapKitView.removeOverlays(currentPolylineOverlay)
            currentPolylineOverlay.removeAll()
        }
        let searchController = UISearchController(searchResultsController: self.suggestionTable)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = suggestionTable
        //searchController.searchBar.showsCancelButton = false
        //searchController.searchBar.scopeButtonTitles = ["All", "Sports", "Buildings", "Food"]
        
        suggestionTable.handleMapSearchDelegate = self
        present(searchController,animated: true,completion: nil)
    }
    
    @objc func currentLocation() {
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let reg = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        self.mapKitView.animatedZoom(zoomRegion: reg, duration: 1 )
    }
    
    @objc func showDirection() {
        if currentPolylineOverlay.count != 0
        {
            mapKitView.removeOverlays(currentPolylineOverlay)
            currentPolylineOverlay.removeAll()
        }
        
        let sC = (locationManager.location?.coordinate)!
        let dC = annotation.coordinate
        
        let sP = MKPlacemark(coordinate: sC)
        let dP = MKPlacemark(coordinate: dC)
        
        let sI = MKMapItem(placemark: sP)
        let dI = MKMapItem(placemark: dP)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sI
        directionRequest.destination = dI
        directionRequest.transportType = .walking
        
        let direction = MKDirections(request: directionRequest)
        
        direction.calculate(completionHandler: {
            res,err in
            guard let res = res else {
                if let err = err {
                    print(err)
                }
                return
            }
            
            let route  = res.routes[0]
            self.polyline = route.polyline
            self.currentPolylineOverlay.append(self.polyline)
            self.mapKitView.addOverlay(self.polyline, level: .aboveLabels)
            let rekt = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegion(rekt), animated: true)
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: false, completion: nil)
        
        if searchBar.text == "Ab5"
        {
            let latitude = 13.353657
            let longitude = 74.793580
            
            let annotation = MKPointAnnotation()
            annotation.title = "AB5"
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            self.mapKitView.addAnnotation(annotation)
            annotation.subtitle = "abc"
            let crd:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let reg = MKCoordinateRegion(center: crd, span: span)
            self.mapKitView.setRegion(reg, animated: true)
        }
    }
  
    
    func setupView()
    {
        view.addSubview(mapKitView)
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = view.safeAreaInsets.top
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        mapKitView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        view.addSubview(searchButton)
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10).isActive = true
        searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 42).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(myLocation)
        myLocation.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10).isActive = true
        myLocation.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        myLocation.widthAnchor.constraint(equalToConstant: 100).isActive = true
        myLocation.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setuppoi()
    {
        poi_coordinates["Quadrangle"] = CLLocationCoordinate2D(latitude: 13.352727, longitude: 74.792803)
        poi_coordinates["AB2"] = CLLocationCoordinate2D(latitude: 13.352500, longitude:74.793622)
        poi_coordinates["NLH"] = CLLocationCoordinate2D(latitude: 13.351440, longitude:74.792906)
        poi_coordinates["IC"] = CLLocationCoordinate2D(latitude: 13.351446, longitude: 74.792579)
        poi_coordinates["AB5"] = CLLocationCoordinate2D(latitude: 13.353478, longitude:74.793458)
        poi_coordinates["Food Stalls"] = CLLocationCoordinate2D(latitude: 13.351776, longitude: 74.791795)
        poi_coordinates["SP"] = CLLocationCoordinate2D(latitude: 13.347488, longitude: 74.793315)
        poi_coordinates["MIT Cricket Ground"] = CLLocationCoordinate2D(latitude: 13.343935, longitude: 74.794053)
        poi_coordinates["MIT Football Ground"] = CLLocationCoordinate2D(latitude: 13.342734, longitude: 74.793286)
//        poi_coordinates["MIT Football Ground"] = CLLocationCoordinate2D(latitude: 13.343942, longitude: 74.792991)
        poi_coordinates["FC 1"] = CLLocationCoordinate2D(latitude: 13.347706, longitude: 74.794204)
        let c = poi_coordinates.keys.sorted()
        for i in c{
            suggestionTable.placeArray.append(String(i))
        }
        //suggestionTable.poi_coordinates = self.poi_coordinates
    }
    
    func setupLocationManager()
    {
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
    }
    
    func centreViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
           
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
            mapKitView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            setupLocationManager()
            checkLocationAuthorization()
        }
        else
        {
            print("Error 1")
            //show alert
        }
    }
    
    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus()
        {
            case .authorizedWhenInUse:
                print(1)
               
                mapKitView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                centreViewOnUserLocation()
                //configureTileOverlay()
                //addAnn()
                //Do map stuff
                break
            case .denied:
                print(2)
                //Show alert to turn on location
                break
            case .notDetermined:
                print(3)
                locationManager.requestWhenInUseAuthorization()
                //mapView.showsUserLocation = true
                break
            case .restricted:
                print(4)
                //alert that some parental permission is not letting access
                break
            case .authorizedAlways:
                print(5)
                break
        @unknown default:
            print("Unknown Error")
        }
    }
    
    //NLH annotation
    func addAnn()
    {
        let NLH = MKPointAnnotation()
        NLH.title = "NLH"
        NLH.coordinate = CLLocationCoordinate2D(latitude: 13.351374, longitude: 74.792903)
        mapKitView.addAnnotation(NLH)
    }
    
    //For custom tile from google
    private func configureTileOverlay()
    {
        // We first need to have the path of the overlay configuration JSON
        //test.json - file from googlemapstyler
        guard let overlayFileURLString = Bundle.main.path(forResource: "mapTile", ofType: "json") else {return}
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {return}
        //        tileOverlay.minimumZ = 1
        //        tileOverlay.maximumZ = 100
        // And finally add it to your MKMapView
        mapKitView.addOverlay(tileOverlay, level: .aboveLabels)
    }
    
    func setupDirection()
    {
        let sC = (locationManager.location?.coordinate)!
        let dC = CLLocationCoordinate2DMake(13.344705, 74.793340)
        
        let sP = MKPlacemark(coordinate: sC)
        let dP = MKPlacemark(coordinate: dC)
        
        let sI = MKMapItem(placemark: sP)
        let dI = MKMapItem(placemark: dP)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sI
        directionRequest.destination = dI
        directionRequest.transportType = .walking
        
        let direction = MKDirections(request: directionRequest)
        
        direction.calculate(completionHandler: {
            res,err in
            guard let res = res else {
                if let err = err {
                    print(err)
                }
                return
            }
            
            let route  = res.routes[0]
            self.mapKitView.addOverlay(route.polyline, level: .aboveRoads)
            let rekt = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegion(rekt), animated: true)
        })
    }
}

extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else {return}
        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centre, latitudinalMeters: 300, longitudinalMeters: 300)
        mapKitView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}

extension MapViewController:MKMapViewDelegate,UISearchBarDelegate{

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if let tileOverlay = overlay as? MKTileOverlay
        {
           return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        }
        else if let roverlay = overlay as? MKPolyline
        {
            let renderer = MKPolylineRenderer(overlay: roverlay)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        else
        {
           return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        
        if annotationView == nil
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
        }
        else
        {
            annotationView!.annotation = annotation
        }
        let annotationButton = UIButton(type: .infoLight)
        annotationButton.tag = annotation.hash
        annotationButton.addTarget(self, action: #selector(showDirection), for: .touchUpInside)
        annotationView!.rightCalloutAccessoryView = annotationButton

        return annotationView
    }

}

extension MapViewController:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    
}

protocol HandleMapSearch
{
    func zoomToPlace(place:String)
}

extension MapViewController:HandleMapSearch
{
    func zoomToPlace(place: String) {
        dismiss(animated: true, completion: nil)
        if annotation.title != ""
        {
            mapKitView.removeAnnotation(annotation)
        }
        guard let placeCoordinates = poi_coordinates[place] else {return}
        let latitude = placeCoordinates.latitude
        let longitude = placeCoordinates.longitude
        let crd:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let reg = MKCoordinateRegion(center: crd, span: span)
        
        annotation.title = place
        annotation.coordinate = placeCoordinates
        mapKitView.addAnnotation(annotation)
        //self.mapKitView.setRegion(reg, animated: true)
        self.mapKitView.animatedZoom(zoomRegion: reg, duration: 1 )
    }
}
    
    


//For animating from one region to another
extension MKMapView {
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
            }, completion: nil)
    }
}
