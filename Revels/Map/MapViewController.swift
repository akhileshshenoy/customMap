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
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    let locationManager = CLLocationManager()
    
    let mapView:MKMapView!={
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
        view.addSubview(mapView)
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
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
            mapView.setRegion(region, animated: true)
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
                mapView.showsUserLocation = true
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
        NLH.coordinate = CLLocationCoordinate2D(latitude: 13.351356, longitude: 74.793067)
        mapView.addAnnotation(NLH)
        
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
        tileOverlay.minimumZ = 1
        tileOverlay.maximumZ = 100
           // And finally add it to your MKMapView
        mapView.addOverlay(tileOverlay, level: .aboveLabels)
    }
}

extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let centre = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: centre, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
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
           } else {
               return MKOverlayRenderer(overlay: overlay)
           }
       }

}
