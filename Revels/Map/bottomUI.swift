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
    //let dummyData : [taggedEvents] = [taggedEvents(name: "Event 1", tags: ["Animals", "Gaming"]),taggedEvents(name: "Event 2", tags: ["Science & Tech", "Gaming"]),taggedEvents(name: "Event 3", tags: ["TV & Movies"])]
       
    let tags = ["All", "Sports", "Proshow", "Buildings", "Food Stalls", "Informals"]
    
//    lazy var eventsTableView: UITableView = {
//            let tableView = UITableView()
//        tableView.delegate = self
//            tableView.dataSource = self
//            return tableView
//    }()

    fileprivate let tagsController = TagsController(collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let cellId = "cellId"
    fileprivate let menuCellId = "menuCellId"
    
    fileprivate func setupTagsController() {
            tagsController.delegate = self
            tagsController.tags = self.tags
            tagsController.markerBar.backgroundColor = UIColor.green
            tagsController.specialColor = UIColor.green
            tagsController.menuBar.backgroundColor = UIColor.black
            tagsController.collectionView.backgroundColor = UIColor.black
            tagsController.shadowBar.backgroundColor = UIColor.black
    }
    
    let suggestionTable = LocationSearchTableViewController()
    
//    let horizontalBar:UIView = {
//        let hview = UIView()
//        //hview.layer.cornerRadius = 5.0
//        hview.backgroundColor = .black
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: CGRect(x: , y: 7.5, width: 30, height: 5), cornerRadius: 50).cgPath
//        layer.fillColor = UIColor.red.cgColor
//        hview.layer.addSublayer(layer)
//        return hview
//    }()
    
    
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
        
        guard let suggestionTableView = suggestionTable.view else {return}
        view.addSubview(suggestionTableView)
        suggestionTableView.backgroundColor = .black
        _ = suggestionTableView.anchor(top: tagsView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

    }
    //MARK:upto here
   
    override func viewDidLoad() {
        setupTagsController()
        setupLayout()
        super.viewDidLoad()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        view.backgroundColor = .black
    }

        //suggestionTable.handleMapSearchDelegate = MapViewController()
        
//        let searchController = UISearchController(searchResultsController: suggestionTable)
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = suggestionTable
//        searchController.searchBar.showsScopeBar = true
        
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 200, y: 10))
//        path.addLine(to: CGPoint(x: 240, y: 10))
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = UIColor.lightGray.cgColor
//        shapeLayer.cornerRadius = 10
//        shapeLayer.lineWidth = 6.0
//
//        view.layer.addSublayer(shapeLayer)
//        let t = searchController.searchBar //searchController.view else {return}
       // self.view.addSubview(x)
       // shapeLayer.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: shapeLayer.bottomAnchor, trailing: self.view.trailingAnchor)
//        guard let u = searchController.searchResultsController?.view else {return}
//        self.view.addSubview(t)
//        self.view.addSubview(u)
      
//        u.anchor(top: t.bottomAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor , trailing: self.view.trailingAnchor)
    
    override var initialPosition: SheetPosition {
        return .bottom
    }
}


//UIViewController Extension
extension UIViewController {

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
   }
}



struct taggedEvents: Decodable{
    let name: String
    let tags: [String]
}
    
extension bottomUI:TagsControllerDelegate
{
    func didTapTag(indexPath: IndexPath) {
        suggestionTable.tag = tags[indexPath.row]
        //changePosition(to: .middle)
    }
    
   
}


protocol TagsControllerDelegate {
    func didTapTag(indexPath: IndexPath)
}
