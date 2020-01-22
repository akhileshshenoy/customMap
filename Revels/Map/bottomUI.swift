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
        
        
//        let t = tbvc.view!
//        self.view.addSubview(t)
//        t.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
////        let leftMargin:CGFloat = 0
////        let topMargin:CGFloat = 0
////        let mapWidth:CGFloat = self.view.frame.width
////        let mapHeight:CGFloat = self.view.frame.size.height
////        t!.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
    }
    override var initialPosition: SheetPosition {
        return .middle
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
