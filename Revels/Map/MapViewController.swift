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
    let btvc = bottomUI()
    let placeVC = placeInfoUI()
    var ann:MKAnnotationView? = nil
    var currentUI = 0; //to switch btw btvc and placeVC
    var poi_array = [String:poi]()
    var annotationArray = [MKPointAnnotation]()
    var annotationImage:UIImage? = nil
    var polyline = MKPolyline()
    var currentPolylineOverlay = [MKPolyline]()
    let locationManager = CLLocationManager()
    
    struct poi {
        var locationName:String
        var locationCoordinates:CLLocationCoordinate2D
        var directionCoordinates:CLLocationCoordinate2D
        var tagCategory:String
    }

    let mapKitView:MKMapView={
        let map = MKMapView()
        map.mapType = MKMapType.standard
        map.isRotateEnabled = true
        map.isPitchEnabled = true
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.showsPointsOfInterest = true
        map.showsBuildings = true
       
        return map
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
        checkLocationServices()
        mapKitView.delegate = self
        addAnnOfTag(tag: "All")
    }

    func setupView()
    {
        view.addSubview(mapKitView)
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = view.safeAreaInsets.top
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        mapKitView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)

        let buttonItem = MKUserTrackingButton(mapView: mapKitView)
        buttonItem.frame = CGRect(origin: CGPoint(x:view.frame.width-65, y: 80), size: CGSize(width: 45, height: 45))
        buttonItem.layer.cornerRadius = 5
        buttonItem.backgroundColor = .black
        mapKitView.addSubview(buttonItem)
        mapKitView.showsCompass = false

        btvc.suggestionTable.handleMapSearchDelegate = self
        btvc.attach(to: self)
        placeVC.handleMapSearchDelegate = self
        zoomMap(byFactor: 1)
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
        DispatchQueue.main.async(execute: {
                   let alertController = UIAlertController(title: "Permission Denied", message: "Please check your device settings", preferredStyle: .alert)
                   let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alertController.addAction(defaultAction)
                   self.present(alertController, animated: true, completion: nil)
               })
       }
    }

    func setupLocationManager()
    {
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
    }

    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus()
        {
            case .authorizedWhenInUse:
                mapKitView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                centreViewOnUserLocation()
                break
            case .denied:
               DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Permission Denied", message: "To view your location in the map, grant the permission to access your location.", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                self.locationManager.requestWhenInUseAuthorization()
                            })
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        })
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Permission Denied", message: "Please check your device settings", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                })
                break
            case .authorizedAlways:
                mapKitView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                centreViewOnUserLocation()
                break
            @unknown default:
                print("Unknown Error")
        }
    }
    
    func centreViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
            mapKitView.setRegion(region, animated: true)
        }
    }
    
    func zoomMap(byFactor delta: Double) {
        var region: MKCoordinateRegion = self.mapKitView.region
        var span: MKCoordinateSpan = mapKitView.region.span
        span.latitudeDelta *= delta
        span.longitudeDelta *= delta
        region.span = span
        mapKitView.setRegion(region, animated: true)
    }
}

extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}

extension MapViewController:MKMapViewDelegate{

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

            let x  = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            x.glyphImage = UIImage(named: poi_array[annotation.title!!]!.tagCategory)
            x.glyphTintColor = .black
            x.animatesWhenAdded = true
            annotationView = x
        
            annotationView?.displayPriority = .required
            annotationView!.canShowCallout = true
            annotationView?.annotation = annotation

        return annotationView
    }
    
//    func delaySomething(annotation)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var nam = ""
        nam = ((view.annotation?.title)!)!
        ann = view
        btvc.changePosition(to: .bottom)
        if (UIImage(named: nam) != nil) {
                  placeVC.imageView.image = UIImage(named:nam)
              }
              else {
                placeVC.imageView.image = UIImage(named:"SP")
              }
        if currentPolylineOverlay.count != 0
               {
                   mapKitView.removeOverlays(currentPolylineOverlay)
                   currentPolylineOverlay.removeAll()
               }

        if placeVC.isLoaded == 0
        {
            placeVC.attach(to: self)
            placeVC.isLoaded = 1
            placeVC.name = nam
            //placeVC.changePosition(to: .middle)
        }
        else
        {
            placeVC.name = nam
            placeVC.isLoaded = 1
           // placeVC.changePosition(to: .middle)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        removeDirection()
        placeVC.detach()
        placeVC.isLoaded = 0
    }
}

protocol HandleMapSearch
{
    func zoomToPlace(name:String,location:CLLocationCoordinate2D)
    func addAnn(locationName:String,locationCoordinate:CLLocationCoordinate2D,directionCoordinate:CLLocationCoordinate2D,tagName:String)
    func addAnnOfTag(tag:String)
    func showDirection()
    func removeDirection()
    func showNavigation()
}

extension MapViewController:HandleMapSearch
{
    func addAnn(locationName: String, locationCoordinate: CLLocationCoordinate2D, directionCoordinate: CLLocationCoordinate2D, tagName: String) {
        poi_array[locationName]=poi(locationName: locationName, locationCoordinates: locationCoordinate, directionCoordinates: directionCoordinate, tagCategory: tagName)
    }
    
    func zoomToPlace(name:String, location: CLLocationCoordinate2D) {
        var nam = ""
        nam = name
        btvc.changePosition(to: .bottom)
         if currentPolylineOverlay.count != 0
               {
                   mapKitView.removeOverlays(currentPolylineOverlay)
                   currentPolylineOverlay.removeAll()
               }
        
        if (UIImage(named: name) != nil) {
            placeVC.imageView.image = UIImage(named:name)
        }
        else {
          placeVC.imageView.image = UIImage(named:"SP")
        }
        if placeVC.isLoaded == 0
        {
            placeVC.attach(to: self)
            placeVC.isLoaded = 1
            placeVC.name = nam
            placeVC.changePosition(to: .middle)
        }
        else
        {
            placeVC.name = nam
            placeVC.isLoaded = 1
            placeVC.changePosition(to: .middle)
        }
        btvc.changePosition(to: .bottom)
        mapKitView.removeAnnotations(annotationArray)
        annotationArray.removeAll()
        
        let latitude = location.latitude - CLLocationDegrees(0.001)
        let longitude = location.longitude
        let crd:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let reg = MKCoordinateRegion(center: crd, span: span)

        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = location
        
        annotationArray.append(annotation)
        mapKitView.addAnnotation(annotation)
        mapKitView.selectAnnotation(annotation, animated: true)
        //self.mapKitView.setRegion(reg, animated: true)
        self.mapKitView.animatedZoom(zoomRegion: reg, duration: 1 )
    }
    
    func addAnnOfTag(tag: String) {
        mapKitView.removeAnnotations(annotationArray)
        annotationArray.removeAll()
            
        if tag == "All"
        {
            for i in poi_array.values
                {
                    let latitude = i.locationCoordinates.latitude
                    let longitude = i.locationCoordinates.longitude
                    let location = CLLocationCoordinate2DMake(latitude, longitude)
                    
                    let tempAnnotation = MKPointAnnotation()
                    tempAnnotation.title = i.locationName
                    tempAnnotation.coordinate = location
                    
                    annotationArray.append(tempAnnotation)
                    mapKitView.addAnnotation(tempAnnotation)
                }
        }
        else
        {
            for i in poi_array.values
            {
                if i.tagCategory == tag
                {
                    let latitude = i.locationCoordinates.latitude
                    let longitude = i.locationCoordinates.longitude
                    let location = CLLocationCoordinate2DMake(latitude, longitude)

                    let tempAnnotation1 = MKPointAnnotation()
                    tempAnnotation1.title = i.locationName
                    tempAnnotation1.coordinate = location
                    
                    annotationArray.append(tempAnnotation1)
                    mapKitView.addAnnotation(tempAnnotation1)
                }
            }
        }
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 13.347488, longitude: 74.793315), latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapKitView.setRegion(region, animated: true)
    }
    
    func showDirection() {
      if currentPolylineOverlay.count != 0
          {
              mapKitView.removeOverlays(currentPolylineOverlay)
              currentPolylineOverlay.removeAll()
          }
        
        let sC = (locationManager.location?.coordinate)!
        guard let dC = ann?.annotation?.coordinate else {return}

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
    
    func removeDirection() {
        if currentPolylineOverlay.count != 0
        {
            mapKitView.removeOverlays(currentPolylineOverlay)
            currentPolylineOverlay.removeAll()
        }
        mapKitView.deselectAnnotation(ann?.annotation, animated: true)
    }
    
    func showNavigation() {
        let regionSpan = MKCoordinateRegion.init(center: (ann?.annotation!.coordinate)!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: (ann?.annotation!.coordinate)!)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = (ann?.annotation?.title)!
        mapItem.openInMaps(launchOptions: options)
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



////For custom tile from google
//private func configureTileOverlay()
//{
//    // We first need to have the path of the overlay configuration JSON
//    //test.json - file from googlemapstyler
//    guard let overlayFileURLString = Bundle.main.path(forResource: "mapTile", ofType: "json") else {return}
//    let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
//    // After that, you can create the tile overlay using MapKitGoogleStyler
//    guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {return}
//    //        tileOverlay.minimumZ = 1
//    //        tileOverlay.maximumZ = 100
//    // And finally add it to your MKMapView
//    mapKitView.addOverlay(tileOverlay, level: .aboveLabels)
//}
