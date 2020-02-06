//
//  BottomSheetViewController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 03/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import UBottomSheet
import CoreLocation

class BottomSheetViewController: BottomSheetController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        
        setupTagsController()
        
        locationTableView.backgroundColor = .black
        locationTableView.tableFooterView = UIView()
        setuppoi()
        locationTableView.register(LocationSearchTableViewCell.self, forCellReuseIdentifier: "cellID")
        
        setupLocationInfoViewLayout()
        
        setupLayout()
        view.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentTag = "All"
        var j = 0.0
        for i in poi_array
        {

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + j) {
                self.handleMapDelegate?.setTag(name: i.locationName, location: i.locationCoordinates, tag: i.tagCategory)
            }
            j+=0.1
        }
    }
    
    //MARK: BottomSheetController configurations
    override var initialPosition: SheetPosition {
        return .bottom
    }

    //MARK:tagView Conf
    var currentTag = ""
    let tags = ["All", "Sports", "Proshow", "Buildings", "Food Stalls", "Informals"]
    fileprivate let tagsController = TagsController(collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate func setupTagsController() {
               tagsController.delegate = self
               tagsController.tags = self.tags
               tagsController.markerBar.backgroundColor = UIColor.green
               tagsController.specialColor = UIColor.green
               tagsController.menuBar.backgroundColor = UIColor.black
               tagsController.collectionView.backgroundColor = UIColor.black
               tagsController.shadowBar.backgroundColor = UIColor.black
       }

//MARK: tableView conf
    
    var placeArray = [String]()
    private var filteredArray = [String]()
    var tagArray = [String:String]()
    
    lazy var locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    struct poi {
           var locationName:String
           var locationCoordinates:CLLocationCoordinate2D
           var directionCoordinates:CLLocationCoordinate2D
           var tagCategory:String
       }
    
    var poi_array = [poi]()
    func setuppoi()
    {
        //poi_coordinates["FC 1"] = CLLocationCoordinate2D(latitude: 13.347706, longitude: 74.794204)
        poi_array.append(poi.init(locationName: "MIT Football Ground", locationCoordinates:  CLLocationCoordinate2D(latitude: 13.342734, longitude: 74.793286), directionCoordinates: CLLocationCoordinate2D(latitude: 13.342734, longitude: 74.793286), tagCategory: "Sports"))
        poi_array.append(poi.init(locationName: "MIT Cricket Ground", locationCoordinates:   CLLocationCoordinate2D(latitude: 13.343935, longitude: 74.794053), directionCoordinates: CLLocationCoordinate2D(latitude: 13.343935, longitude: 74.794053), tagCategory: "Sports"))
        poi_array.append(poi.init(locationName: "SP", locationCoordinates:   CLLocationCoordinate2D(latitude: 13.347488, longitude: 74.793315), directionCoordinates:    CLLocationCoordinate2D(latitude: 13.347488, longitude: 74.793315), tagCategory: "Informals"))
        poi_array.append(poi.init(locationName: "Food Stall", locationCoordinates:   CLLocationCoordinate2D(latitude: 13.351776, longitude: 74.791795), directionCoordinates:    CLLocationCoordinate2D(latitude: 13.351776, longitude: 74.791795), tagCategory: "Food Stalls"))
        poi_array.append(poi.init(locationName: "AB5", locationCoordinates:  CLLocationCoordinate2D(latitude: 13.353478, longitude:74.793458), directionCoordinates:   CLLocationCoordinate2D(latitude: 13.353478, longitude:74.793458), tagCategory: "Buildings"))
        poi_array.append(poi.init(locationName: "IC", locationCoordinates:  CLLocationCoordinate2D(latitude: 13.351446, longitude: 74.792579), directionCoordinates:  CLLocationCoordinate2D(latitude: 13.351446, longitude: 74.792579), tagCategory: "Buildings"))
        poi_array.append(poi.init(locationName: "NLH", locationCoordinates:  CLLocationCoordinate2D(latitude: 13.351440, longitude:74.792906), directionCoordinates:  CLLocationCoordinate2D(latitude: 13.351440, longitude:74.792906), tagCategory: "Buildings"))
        poi_array.append(poi.init(locationName: "AB2", locationCoordinates:  CLLocationCoordinate2D(latitude: 13.352386,  longitude: 74.793616), directionCoordinates:  CLLocationCoordinate2D(latitude: 13.352386,  longitude: 74.793616), tagCategory: "Buildings"))
        poi_array.append(poi.init(locationName: "Quadrangle", locationCoordinates: CLLocationCoordinate2D(latitude: 13.352727, longitude: 74.792803), directionCoordinates: CLLocationCoordinate2D(latitude: 13.352727, longitude: 74.792803), tagCategory: "Proshow"))
        for i in poi_array{
                       placeArray.append(i.locationName)
                       placeArray.sort()
                   }
    }
    
    //MARK: locationInfoView conf
    var currentLocation:String = ""
    var currentLocationDirectionCoordinates:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var handleMapDelegate:HandleMapDelegate? = nil
    
    lazy var nameLabel : UILabel = {
       let label = UILabel()
       label.numberOfLines = 0
       label.translatesAutoresizingMaskIntoConstraints = false
       label.lineBreakMode = .byWordWrapping
       label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
       label.textAlignment = .left
       label.textColor = .white
       label.text = ""
       return label
    }()

    lazy var closeButton : UIButton = {
       let button = UIButton()
       button.setTitle("X", for: .normal)
       button.setTitleColor(.white, for: .normal)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.layer.cornerRadius = 10
       button.clipsToBounds = true
       button.backgroundColor = .red
       button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
       return button
     }()

    lazy var directionButton : UIButton = {
       let button = UIButton()
       button.setTitle("Direction", for: .normal)
       button.translatesAutoresizingMaskIntoConstraints = false
       button.layer.cornerRadius = 10
       button.clipsToBounds = true
       button.backgroundColor = #colorLiteral(red: 0.0628238342, green: 0.0628238342, blue: 0.0628238342, alpha: 1)
       button.addTarget(self, action: #selector(showDirection), for: .touchUpInside)
       return button
    }()

    lazy var navigationButton : UIButton = {
          let button = UIButton()
          button.setTitle("Navigation", for: .normal)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.layer.cornerRadius = 10
          button.clipsToBounds = true
          button.backgroundColor = #colorLiteral(red: 0.0628238342, green: 0.0628238342, blue: 0.0628238342, alpha: 1)
          button.addTarget(self, action: #selector(showNavigation), for: .touchUpInside)
          return button
      }()
    
    lazy var imageView:UIImageView={
        let iV = UIImageView()
        iV.clipsToBounds = true
        return iV
    }()

    lazy var locationInfoView:UIView={
       let view = UIView()
       view.backgroundColor = .black
       return view
    }()
    
    @objc func handleClose()
        {
            handleMapDelegate?.removeDirection()
            locationInfoView.isHidden = true
        }
    
    @objc func showDirection()
    {
        changePosition(to: .bottom)
        handleMapDelegate?.showDirection(to: currentLocationDirectionCoordinates)
    }

    @objc func showNavigation() {
        handleMapDelegate?.showNavigation(to: currentLocation, coordinates: currentLocationDirectionCoordinates)
    }
    
     fileprivate func setupLocationInfoViewLayout() {
    
            locationInfoView.addSubview(nameLabel)
            //nameLabel.text = "test"
            nameLabel.leftAnchor.constraint(equalTo: locationInfoView.leftAnchor, constant: 20).isActive = true
            nameLabel.topAnchor.constraint(equalTo: locationInfoView.topAnchor, constant: 8).isActive = true
            nameLabel.widthAnchor.constraint(equalTo: locationInfoView.widthAnchor, constant: -32).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
            locationInfoView.addSubview(closeButton)
            closeButton.rightAnchor.constraint(equalTo: locationInfoView.rightAnchor , constant: -20).isActive = true
            closeButton.topAnchor.constraint(equalTo: locationInfoView.topAnchor, constant: 10).isActive = true
            closeButton.widthAnchor.constraint(equalTo: locationInfoView.widthAnchor, constant: -390).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    
            locationInfoView.addSubview(directionButton)
            directionButton.centerXAnchor.constraint(equalTo: locationInfoView.centerXAnchor , constant: 0).isActive = true
            directionButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
            directionButton.widthAnchor.constraint(equalTo: locationInfoView.widthAnchor, constant: -50).isActive = true
            directionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
            locationInfoView.addSubview(navigationButton)
            navigationButton.centerXAnchor.constraint(equalTo: locationInfoView.centerXAnchor , constant: 0).isActive = true
            navigationButton.topAnchor.constraint(equalTo: directionButton.bottomAnchor, constant: 15).isActive = true
            navigationButton.widthAnchor.constraint(equalTo: locationInfoView.widthAnchor, constant: -50).isActive = true
            navigationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
            imageView  = UIImageView(frame:CGRect.init(x: 25, y: 190, width: view.bounds.maxX-50, height: 250));
            imageView.layer.cornerRadius = 5
            locationInfoView.addSubview(imageView)
        }
    
    func setDelegate(vc:HandleMapDelegate)
    {
        handleMapDelegate = vc
    }
       
    func loadLocationInfoView(title:String)
    {
        nameLabel.text = title
        currentLocation = title
        if(UIImage(named: title) != nil) {
            imageView.image = UIImage(named:title)
        }
        locationInfoView.isHidden = false
        changePosition(to: .middle)
        for i in poi_array
        {
           if i.locationName == currentLocation
           {
               currentLocationDirectionCoordinates = i.directionCoordinates
           }
        }
    }
    
    func hideLocationInfoView()
    {
        locationInfoView.isHidden = true
        changePosition(to: .bottom)
    }
    
//MARK: ViewSetup
    fileprivate func setupLayout() {
         let layer = CAShapeLayer()
         layer.path = UIBezierPath(roundedRect: CGRect(x: view.frame.width/2-20 , y: 7.5, width: 40, height: 5), cornerRadius: 50).cgPath
         layer.fillColor = UIColor.red.cgColor
         view.layer.addSublayer(layer)
         
         guard let tagsView = tagsController.view else {return}
         tagsView.backgroundColor = .white
         view.addSubview(tagsView)
         _ = tagsView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
         tagsController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)

        view.addSubview(locationTableView)
         locationTableView.backgroundColor = .black
         _ = locationTableView.anchor(top: tagsView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
         
        view.addSubview(locationInfoView)
        
        _ = locationInfoView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.view.frame.height)
        locationInfoView.isHidden = true
         
     }
}

//MARK:TableVC conf
extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if currentTag != "All"
            {
               return filteredArray.count
            }
        else
            {
               return placeArray.count
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         var place:String?
         if currentTag != "All"
         {
             place = filteredArray[indexPath.row]
         }
         else
         {
             place = placeArray[indexPath.row]
         }
         let cell: LocationSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! LocationSearchTableViewCell
         cell.textLabel?.text = place
         cell.textLabel?.textColor = .lightGray
         
         cell.selectionStyle = .blue
         cell.backgroundColor = .black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.gray
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 13.352727, longitude: 74.792803)
        var name = ""
        if currentTag != "All"
        {
            name = filteredArray[indexPath.row]
            for c in poi_array
            {
                if c.locationName == name
                {
                    location = c.locationCoordinates
                }
            }
        }
        else
        {
            name = placeArray[indexPath.row]
            for c in poi_array
            {
                if c.locationName == name
                {
                    location = c.locationCoordinates
                }
            }
        }
        handleMapDelegate?.zoomToPlace(name: name, location: location)
        loadLocationInfoView(title: name)
    }
}

//MARK:tagVC conf

protocol TagsControllerDelegate {
    func didTapTag(indexPath: IndexPath)
}

extension BottomSheetViewController:TagsControllerDelegate
{
    func didTapTag(indexPath: IndexPath) {

        guard currentTag != tags[indexPath.row] else {return}
        currentTag = tags[indexPath.row]
        handleMapDelegate?.removeAnnotations()
        if currentTag != "All"
        {
            filteredArray.removeAll()
            for i in poi_array
            {
               if i.tagCategory == currentTag
               {
                    handleMapDelegate?.setTag(name: i.locationName, location: i.locationCoordinates, tag:i.tagCategory )
                    filteredArray.append(i.locationName)
                    //handleMapDelegate?.addAnnotation(name: i.locationName, locationCoordinate: i.locationCoordinates)
               }
            }
            filteredArray.sort()
        }
        else
        {
            var j = 0.0
            for i in poi_array
            {
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + j) {
                    self.handleMapDelegate?.setTag(name: i.locationName, location: i.locationCoordinates, tag: i.tagCategory)
                }
                j+=0.03
            }
        }
        locationTableView.reloadData(with: .automatic)
    }
}



//UIViewController Extensions
extension UIViewController {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
   }
}

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}


