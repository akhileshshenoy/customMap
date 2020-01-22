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

class LocationSearchTableViewController: BottomSheetController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    private let cellID = "cellID"
    var placeArray = [String]()
    private var filteredArray = [String]()
    private var isSearching = false
   // var poi_coordinates = [String:CLLocationCoordinate2D]()
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
//        view.backgroundColor = .red
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        tableView.register(LocationSearchTableViewCell.self, forCellReuseIdentifier: cellID)
//        tableView.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
       
        
    }
    
    override var initialPosition: SheetPosition {
        return .middle
    }

    // MARK: - Table view data source

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearching
        {
            return filteredArray.count
        }
        else
        {
        return placeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) // To maintain gap between tableview and searchbar
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var place:String?
        if isSearching
        {
            place = filteredArray[indexPath.row]
        }
        else
        {
            place = placeArray[indexPath.row]
        }
        let cell: LocationSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LocationSearchTableViewCell
//        cell.placeLabel.text = place
        cell.textLabel?.text = place
        cell.selectionStyle = .blue
        return cell
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if isSearching == true
        {
            handleMapSearchDelegate?.zoomToPlace(place: filteredArray[indexPath.row])
        }
        else
        {
             handleMapSearchDelegate?.zoomToPlace(place: placeArray[indexPath.row])
        }
        
    }
}

extension LocationSearchTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText == ""
        {
            tableView.isHidden = false
            isSearching = false
            view.endEditing(true)
            
            tableView.reloadData()
        }
        else
        {
            isSearching = true
            //filteredArray = placeArray.filter({$0.range(of: searchText, options: .caseInsensitive) != nil})
            filteredArray = placeArray.filter({$0.lowercased().starts(with: searchText.lowercased()) == true})
            tableView.reloadData()
        }
    }
    
    
}
