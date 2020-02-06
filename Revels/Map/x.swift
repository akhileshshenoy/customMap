////
////  x.swift
////  Revels
////
////  Created by Akhilesh Shenoy on 01/02/20.
////  Copyright © 2020 Naman Jain. All rights reserved.
////
//
////
////  bottomUI.swift
////  Revels
////
////  Created by Akhilesh Shenoy on 23/01/20.
////  Copyright © 2020 Naman Jain. All rights reserved.
////
//
//import UIKit
//import UBottomSheet
//
//class x: BottomSheetController
//{
//    let tags = ["All", "Sports", "Proshow", "Buildings", "Food Stalls", "Informals"]
//    
//
//    fileprivate let tagsController = TagsController(collectionViewLayout: UICollectionViewFlowLayout())
//    //fileprivate let cellId = "cellId"
//    //fileprivate let menuCellId = "menuCellId"
//    
//    fileprivate func setupTagsController() {
//            tagsController.delegate = self
//            tagsController.tags = self.tags
//            tagsController.markerBar.backgroundColor = UIColor.green
//            tagsController.specialColor = UIColor.green
//            tagsController.menuBar.backgroundColor = UIColor.black
//            tagsController.collectionView.backgroundColor = UIColor.black
//            tagsController.shadowBar.backgroundColor = UIColor.black
//    }
//    
//    //let suggestionTable = LocationSearchTableViewController()
//    //let yy = y()
//    //var yvc = UIView()
//    
//    fileprivate func setupLayout() {
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: CGRect(x: view.frame.width/2-20 , y: 7.5, width: 40, height: 5), cornerRadius: 50).cgPath
//        layer.fillColor = UIColor.red.cgColor
//        view.layer.addSublayer(layer)
//        
//        guard let tagsView = tagsController.view else {return}
//        tagsView.backgroundColor = .white
//        view.addSubview(tagsView)
//        _ = tagsView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
//        tagsController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
//       
//        guard let suggestionTableView = suggestionTable.view else {return}
//        view.addSubview(suggestionTableView)
//        suggestionTableView.backgroundColor = .black
//        _ = suggestionTableView.anchor(top: tagsView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
//        
//        view.addSubview(yvc)
//        _ = yvc.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.view.frame.height)
//        yvc.isHidden = true
//        
//    }
//    //MARK:upto here
//
//    override func viewDidLoad() {
//        setupTagsController()
//        yvc = yy.view
//        setupLayout()
//        super.viewDidLoad()
//        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
//        view.backgroundColor = .black
//        
//    }
//    public func setView(view: UIView, hidden: Bool) {
//        UIView.transition(with: view, duration: 2, options: .transitionCrossDissolve, animations: {
//            view.isHidden = hidden
//        })
//    }
//    
//    override var initialPosition: SheetPosition {
//        return .bottom
//    }
//}
//
//
////UIViewController Extension
//extension UIViewController {
//
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        view.layer.mask = mask
//   }
//}
//
//
//
//struct taggedEvents: Decodable{
//    let name: String
//    let tags: [String]
//}
//    
//extension x:TagsControllerDelegate
//{
//    func didTapTag(indexPath: IndexPath) {
//        setView(view: yvc, hidden: false)
//    
//        changePosition(to: .middle)
//    suggestionTable.tag = tags[indexPath.row]
//    }
//}
//
//
//protocol TagsControllerDelegate {
//    func didTapTag(indexPath: IndexPath)
//}
//
//
//class MapsDemoBottomSheetController: BottomSheetController{
//    
//    //MARK: BottomSheetController configurations
//    override var initialPosition: SheetPosition {
//        return .middle
//    }
//        
////    override var topYPercentage: CGFloat
//    
////    override var bottomYPercentage: CGFloat
//    
////    override var middleYPercentage: CGFloat
//    
////    override var bottomInset: CGFloat
//    
////    override var topInset: CGFloat
//    
////    Don't override if not necessary as it is auto-detected
////    override var scrollView: UIScrollView?{
////        return put_your_tableView, collectionView, etc.
////    }
//    
////    //Override this to apply custom animations
////    override func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
////        UIView.animate(withDuration: 0.3, animations: animations)
////    }
//    
////    To change sheet position manually
////    call ´changePosition(to: .top)´ anywhere in the code
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
//    }
//
//}
//
//extension MapsDemoBottomSheetController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 100
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableCell", for: indexPath) as! SimpleTableCell
//        let model = SimpleTableCellViewModel(image: nil, title: "Title \(indexPath.row)", subtitle: "Subtitle \(indexPath.row)")
//        cell.configure(model: model)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}
//
////UIViewController Extensions
//extension UIViewController {
//   
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        view.layer.mask = mask
//   }
//}
