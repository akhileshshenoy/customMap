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

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTileOverlay()
        
        setupView()
        checkLocationServices()
        mapKitView.delegate = self
        
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
        // Do any additional setup after loading the view.
    }
    
    let locationManager = CLLocationManager()
    
    let mapKitView:MKMapView={
    let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isRotateEnabled = true
        map.isPitchEnabled = true
        
    map.isZoomEnabled = true
    map.isScrollEnabled = true
    return map
    }()
    
    func setupView()
    {
        view.addSubview(mapKitView)
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = view.safeAreaInsets.top
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        mapKitView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        addAnn()
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
    private func configureTileOverlay() {
       // We first need to have the path of the overlay configuration JSON
        //test.json - file from googlemapstyler
       guard let overlayFileURLString = Bundle.main.path(forResource: "test", ofType: "json") else {
               return
       }
       let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
       
       // After that, you can create the tile overlay using MapKitGoogleStyler
       guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
           return
       }
//        tileOverlay.minimumZ = 1
//        tileOverlay.maximumZ = 100
           // And finally add it to your MKMapView
        mapKitView.addOverlay(tileOverlay, level: .aboveRoads)
    }
}

extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centre, latitudinalMeters: 300, longitudinalMeters: 300)
        mapKitView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController:MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           // This is the final step. This code can be copied and pasted into your project
           // without thinking on it so much. It simply instantiates a MKTileOverlayRenderer
           // for displaying the tile overlay.
           if let tileOverlay = overlay as? MKTileOverlay {
               return MKTileOverlayRenderer(tileOverlay: tileOverlay)
           }
            else if let roverlay = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: roverlay)
                                     renderer.strokeColor = UIColor.systemBlue
                                     renderer.lineWidth = 5
                                     return renderer
            }
        else {
               return MKOverlayRenderer(overlay: overlay)
           }
       
       }

}
