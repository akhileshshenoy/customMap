//
//  LocationSearchTableViewController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 10/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import CoreLocation
import UBottomSheet

class LocationSearchTableViewController: UITableViewController{

    private let cellID = "cellID"
    var placeArray = [String]()
    private var filteredArray = [String]()
    private var isSearching = false
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var poi_array = [poi]()
    public var tag:String = "All" {didSet{
        reload()
        }}
    
    override func viewDidLoad() {
        setuppoi() 
        super.viewDidLoad()
        tableView.register(LocationSearchTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.backgroundColor = .black
        tableView.tableFooterView = UIView()
        //self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
    }
    
    struct poi {
        var locationName:String
        var locationCoordinates:CLLocationCoordinate2D
        var directionCoordinates:CLLocationCoordinate2D
        var tagCategory:String
    }
    
    struct poiDec:Decodable {
        var locationName:String
        var locationCoordinates:coordinates
        var directionCoordinates:coordinates
        var tagCategory:String
    }
    
    struct coordinates:Decodable{
        var x : Double
        var y : Double
    }

    func reload(){
        if tag != "All"
        {
            filteredArray.removeAll()
            for i in poi_array
            {
                if i.tagCategory == tag
                {
                    filteredArray.append(i.locationName)
                }
            }
            filteredArray.sort()
        }
        handleMapSearchDelegate?.addAnnOfTag(tag: tag)
        tableView.reloadData(with:.automatic)
    }
    
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
                handleMapSearchDelegate?.addAnn(locationName: i.locationName, locationCoordinate: i.locationCoordinates, directionCoordinate: i.directionCoordinates, tagName: i.tagCategory)
                placeArray.append(i.locationName)
                placeArray.sort()
            }
        }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tag != "All"
        {
            return filteredArray.count
        }
        else
        {
            return placeArray.count
        }
    }
    
//    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) // To maintain gap between tableview and searchbar
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var place:String?
        if tag != "All"
        {
            place = filteredArray[indexPath.row]
        }
        else
        {
            place = placeArray[indexPath.row]
        }
        let cell: LocationSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LocationSearchTableViewCell
        cell.textLabel?.text = place
        cell.textLabel?.textColor = .lightGray
        
        cell.selectionStyle = .blue
        cell.backgroundColor = .black
       let bgColorView = UIView()
       bgColorView.backgroundColor = UIColor.red
       cell.selectedBackgroundView = bgColorView
        return cell
       }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 13.352727, longitude: 74.792803)
        if tag != "All"
        {
            let name = filteredArray[indexPath.row]
            for c in poi_array
            {
                if c.locationName == name
                {
                    location = c.locationCoordinates
                }
            }
            handleMapSearchDelegate?.zoomToPlace(name: name,location: location)
        }
        else
        {
            let name = placeArray[indexPath.row]
            
            for c in poi_array
            {
                if c.locationName == name
                {
                    location = c.locationCoordinates
                }
            }
            //guard let location = poi_array. else {return}
            handleMapSearchDelegate?.zoomToPlace(name: name,location: location)
        }
    }
}

//extension LocationSearchTableViewController: UISearchResultsUpdating,UISearchBarDelegate{
//    func updateSearchResults(for searchController: UISearchController) {
//
//        let searchText = searchController.searchBar.text ?? ""
//        print(searchText)
//        if searchText == ""
//        {
//            //tableView.isHidden = false
//            isSearching = false
//            //view.endEditing(true)
//
//            tableView.reloadData()
//        }
//        else
//        {
//            isSearching = true
//            //filteredArray = placeArray.filter({$0.range(of: searchText, options: .caseInsensitive) != nil})
//            filteredArray = placeArray.filter({$0.lowercased().starts(with: searchText.lowercased()) == true})
//            tableView.reloadData()
//        }
//    }
//}

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}
