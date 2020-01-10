//
//  LocationSearchTableViewController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 10/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class LocationSearchTableViewController: UITableViewController {

    private let cellID = "cellID"
    private var placeArray = ["AB1","AB2","AB3","IC","Quadrangle","SP"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(LocationSearchTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .white
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
       
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationSearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! LocationSearchTableViewCell
        cell.placeLabel.text = placeArray[indexPath.item]
        cell.placeLabel.textColor = .black
        cell.selectionStyle = .none
        return cell
       }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
}

extension LocationSearchTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
        tableView.reloadData()
    }
    
    
}
