//
//  bottomUI.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 23/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import UBottomSheet

class bottomUI: BottomSheetController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let suggestionTable = LocationSearchTableViewController()
        
        let searchController = UISearchController(searchResultsController: suggestionTable)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = suggestionTable
        suggestionTable.handleMapSearchDelegate = self
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 200, y: 10))
        path.addLine(to: CGPoint(x: 240, y: 10))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.cornerRadius = 10
        shapeLayer.lineWidth = 6.0

        view.layer.addSublayer(shapeLayer)
        let t = searchController.searchBar //searchController.view else {return}
       // self.view.addSubview(x)
       // shapeLayer.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: shapeLayer.bottomAnchor, trailing: self.view.trailingAnchor)
        guard let u = searchController.searchResultsController?.view else {return}
        self.view.addSubview(t)
        self.view.addSubview(u)
      
        u.anchor(top: t.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor , trailing: self.view.trailingAnchor)
    }
    override var initialPosition: SheetPosition {
        return .bottom
    }
    let tbvc:LocationSearchTableViewController = LocationSearchTableViewController()
    
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
extension bottomUI:UISearchResultsUpdating,UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    
}
extension bottomUI:HandleMapSearch
{
    func zoomToPlace(place: String) {

    }
}
