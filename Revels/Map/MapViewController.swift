//
//  MapViewController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 04/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController
{
     override func viewDidLoad()
     {
        if #available(iOS 13.0, *) {
        self.overrideUserInterfaceStyle = .dark
        }
        super.viewDidLoad()
        setupView()
        checkLocationServices()
        mapKitView.delegate = self
        bottomSheetVC.setDelegate(vc: self)
     }
    
    //MARK:ViewSetup
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
        
        bottomSheetVC.attach(to: self)
    }
    
    //MARK:MapView conf
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
    
    let locationManager = CLLocationManager()
    var selectedAnnotation:MKAnnotation? = nil      //For deselcting selected one when close button is clicked
    var annotationArray = [MKPointAnnotation]()     //For removing rendered annotations
    var polyline = MKPolyline()
    var currentPolylineOverlay = [MKPolyline]()     //For removing rendered polyline
    var tagArray = [String:String]()                //For glyph image
    
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
                locationManager.requestWhenInUseAuthorization()
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
    
    //MARK: BottomSheet conf
    let bottomSheetVC = BottomSheetViewController()
}

//Extensions
extension MapViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}

extension MKMapView {
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
            }, completion: nil)
    }
}

extension MapViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        //Renders polyline
        if let roverlay = overlay as? MKPolyline
        {
            let renderer = MKPolylineRenderer(overlay: roverlay)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        //Renders map
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
        let markerAnnotation  = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        if let name = annotation.title
        {
            if let imgName = tagArray[name ?? ""]
            {
                markerAnnotation.glyphImage = UIImage(named:imgName)
            }
        }
    
        markerAnnotation.glyphTintColor = .black
        markerAnnotation.animatesWhenAdded = true
        annotationView = markerAnnotation

        annotationView?.displayPriority = .required
        annotationView!.canShowCallout = true
        annotationView?.annotation = annotation

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var title = ""
        guard let annotation = view.annotation else {return}
        guard let annotationTitle = annotation.title else {return}
        title = annotationTitle ?? ""
        selectedAnnotation = annotation
        let latitude = annotation.coordinate.latitude - CLLocationDegrees(0.001)
        let longitude = annotation.coordinate.longitude
        let crd:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let reg = MKCoordinateRegion(center: crd, span: span)
        self.mapKitView.animatedZoom(zoomRegion: reg, duration: 1 )
        bottomSheetVC.loadLocationInfoView(title: title)
        if currentPolylineOverlay.count != 0
        {
           mapKitView.removeOverlays(currentPolylineOverlay)
           currentPolylineOverlay.removeAll()
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        removeDirection()
        bottomSheetVC.hideLocationInfoView()
    }
}

//MARK:handlemapDelegate

protocol HandleMapDelegate
{
    func zoomToPlace(name:String,location:CLLocationCoordinate2D)
    func addAnnotation(name: String, locationCoordinate: CLLocationCoordinate2D)
    func removeAnnotations()
    func showDirection(to:CLLocationCoordinate2D)
    func removeDirection()
    func showNavigation(to:String,coordinates:CLLocationCoordinate2D)
    func setupTagDictionary(name:String,tag:String)
}

extension MapViewController:HandleMapDelegate
{
    
    func zoomToPlace(name:String, location: CLLocationCoordinate2D) {
        //Remove current overlays and annotation
        if currentPolylineOverlay.count != 0
               {
                   mapKitView.removeOverlays(currentPolylineOverlay)
                   currentPolylineOverlay.removeAll()
               }

        let latitude = location.latitude - CLLocationDegrees(0.001)
        let longitude = location.longitude
        let crd:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        let reg = MKCoordinateRegion(center: crd, span: span)

        var annotation:MKAnnotation?
        for i in annotationArray
        {
            if i.title == name
            {
                annotation = i
            }
        }
        
        selectedAnnotation = annotation
        mapKitView.selectAnnotation(annotation!, animated: true)
        self.mapKitView.animatedZoom(zoomRegion: reg, duration: 1 )
    }
        
    func removeAnnotations() {
        mapKitView.removeAnnotations(annotationArray)
        annotationArray.removeAll()
    }
    
    func showDirection(to:CLLocationCoordinate2D) {
        if currentPolylineOverlay.count != 0
          {
              mapKitView.removeOverlays(currentPolylineOverlay)
              currentPolylineOverlay.removeAll()
          }

        guard let sC = (locationManager.location?.coordinate)
        else {
            DispatchQueue.main.async(execute: {
                                       let alertController = UIAlertController(title: "Permission Denied", message: "To show directions in the map, please grant the permission to access your location.", preferredStyle: .alert)
                                       let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                           self.locationManager.requestWhenInUseAuthorization()
                                       })
                                       alertController.addAction(defaultAction)
                                       self.present(alertController, animated: true, completion: nil)
                                   })
            return
        }
        let dC = to

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
    
    func addAnnotation(name: String, locationCoordinate: CLLocationCoordinate2D) {
          let annotation = MKPointAnnotation()
          annotation.title = name
          annotation.coordinate = locationCoordinate
          annotationArray.append(annotation)
          mapKitView.addAnnotation(annotation)
          let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: 13.347488, longitude: 74.793315), latitudinalMeters: 1000, longitudinalMeters: 1000)
          mapKitView.setRegion(region, animated: true)
      }

    func removeDirection() {
        if currentPolylineOverlay.count != 0
        {
            mapKitView.removeOverlays(currentPolylineOverlay)
            currentPolylineOverlay.removeAll()
        }
        mapKitView.deselectAnnotation(selectedAnnotation, animated: true)
    }
    
    func showNavigation(to:String,coordinates:CLLocationCoordinate2D) {
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let options = [MKLaunchOptionsMapCenterKey : NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey : NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = to
        mapItem.openInMaps(launchOptions: options)
    }
    
    func setupTagDictionary(name:String,tag:String)
    {
        tagArray[name] = tag
    }
}
