//
//  placeInfoUI.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 29/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import UBottomSheet

class placeInfoUI: BottomSheetController
{
    public var isLoaded = 0
    public var imageView = UIImageView()
    public var name = "" {didSet{
        nameLabel.text = name
        }}
    var handleMapSearchDelegate:HandleMapSearch? = nil
    let nameLabel : UILabel = {
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
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(showDirection), for: .touchUpInside)
        return button
    }()
    
    lazy var navigationButton : UIButton = {
           let button = UIButton()
           button.setTitle("Navigation", for: .normal)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.layer.cornerRadius = 10
           button.clipsToBounds = true
           button.backgroundColor = .systemBlue
           button.addTarget(self, action: #selector(showNavigation), for: .touchUpInside)
           return button
       }()
    
    fileprivate func setupLayout() {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: view.frame.width/2-20 , y: 7.5, width: 40, height: 5), cornerRadius: 50).cgPath
        layer.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(layer)
        
        view.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(closeButton)
        closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor , constant: -20).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -390).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(directionButton)
        directionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor , constant: 0).isActive = true
        directionButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
        directionButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -50).isActive = true
        directionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(navigationButton)
        navigationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor , constant: 0).isActive = true
        navigationButton.topAnchor.constraint(equalTo: directionButton.bottomAnchor, constant: 15).isActive = true
        navigationButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -50).isActive = true
        navigationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageView  = UIImageView(frame:CGRect.init(x: 25, y: 190, width: view.bounds.maxX-50, height: 250));
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
//        imageView.image = UIImage(named:"sp.jpg")
        self.view.addSubview(imageView)
    }
    //MARK:upto here
    
    @objc func handleClose()
    {
        self.detach()
        self.isLoaded = 0
        handleMapSearchDelegate?.removeDirection()
    }
    
    @objc func showDirection()
    {
        changePosition(to: .bottom)
        handleMapSearchDelegate?.showDirection()
    }
    
    @objc func showNavigation()
    {
        changePosition(to: .bottom)
        handleMapSearchDelegate?.showNavigation()
    }
    
    override func viewDidLoad() {
        setupLayout()
        nameLabel.text = "Manipal Institute of Technology"
        super.viewDidLoad()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        view.backgroundColor = .black
    }

    
    override var initialPosition: SheetPosition {
        return .middle
    }
}




    



