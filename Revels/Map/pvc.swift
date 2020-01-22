//
//  pvc.swift
//  
//
//  Created by Akhilesh Shenoy on 14/01/20.
//

import UIKit
import Pulley
class pvc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         //let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrimaryContentViewController")
        //
        //        let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController")

                 let mainContentVC = MapViewController()
                let drawerContentVC = LocationSearchTableViewController()
                let pulleyController = PulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
