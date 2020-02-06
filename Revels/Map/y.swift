////
////  placeInfoUI.swift
////  Revels
////
////  Created by Akhilesh Shenoy on 29/01/20.
////  Copyright © 2020 Naman Jain. All rights reserved.
////
//
//import UIKit
//import UBottomSheet
//
//class y: UIViewController
//{
//    public var isLoaded = 0
//    public var imageView = UIImageView()
//    public var name = "" {didSet{
//        nameLabel.text = name
//        //changePosition(to: .middle)
//        //imageView.image = UIImage(named: name)
//        }}
//    var handleMapSearchDelegate:HandleMapSearch? = nil
//    let nameLabel : UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.lineBreakMode = .byWordWrapping
//        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
//        label.textAlignment = .left
//        label.textColor = .white
//        label.text = ""
//        return label
//    }()
//    
//    lazy var closeButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("X", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .red
//        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
//        return button
//      }()
//    
//    lazy var directionButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("Direction", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = #colorLiteral(red: 0.0628238342, green: 0.0628238342, blue: 0.0628238342, alpha: 1)
//        button.addTarget(self, action: #selector(showDirection), for: .touchUpInside)
//        return button
//    }()
//    
//    lazy var navigationButton : UIButton = {
//           let button = UIButton()
//           button.setTitle("Navigation", for: .normal)
//           button.translatesAutoresizingMaskIntoConstraints = false
//           button.layer.cornerRadius = 10
//           button.clipsToBounds = true
//           button.backgroundColor = #colorLiteral(red: 0.0628238342, green: 0.0628238342, blue: 0.0628238342, alpha: 1)
//           button.addTarget(self, action: #selector(showNavigation), for: .touchUpInside)
//           return button
//       }()
//    
//    fileprivate func setupLayout() {
//        
//        view.addSubview(nameLabel)
//        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
//        nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
//        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
//        
//        view.addSubview(closeButton)
//        closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor , constant: -20).isActive = true
//        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
//        closeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -390).isActive = true
//        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        
//        view.addSubview(directionButton)
//        directionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor , constant: 0).isActive = true
//        directionButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
//        directionButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -50).isActive = true
//        directionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        view.addSubview(navigationButton)
//        navigationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor , constant: 0).isActive = true
//        navigationButton.topAnchor.constraint(equalTo: directionButton.bottomAnchor, constant: 15).isActive = true
//        navigationButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -50).isActive = true
//        navigationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        imageView  = UIImageView(frame:CGRect.init(x: 25, y: 190, width: view.bounds.maxX-50, height: 250));
//        imageView.layer.cornerRadius = 5
//        imageView.clipsToBounds = true
//        imageView.image = UIImage(named:"SP")
//        self.view.addSubview(imageView)
//    }
//    //MARK:upto here
//    
//    @objc func handleClose()
//    {
////        let transition = CATransition()
////        transition.duration = 0.5
////        transition.type = CATransitionType.push
////        transition.subtype = CATransitionSubtype.fromTop
////        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
////        self.view.window!.layer.add(transition, forKey: kCATransition)
//        //self.detach()
//        self.isLoaded = 0
//        handleMapSearchDelegate?.removeDirection()
//    }
//    
//    @objc func showDirection()
//    {
//        handleMapSearchDelegate?.showDirection()
//    }
//    
//    @objc func showNavigation()
//    {
//        handleMapSearchDelegate?.showNavigation()
//    }
//    
//    
//    
//    override func viewDidLoad() {
//    
//        setupLayout()
//        super.viewDidLoad()
//        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
//        view.backgroundColor = .black
//        
//    }
//}
//
//
//
//
//    
//
//
//
