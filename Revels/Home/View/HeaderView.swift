//
//  HeaderView.swift
//  StretchyHeader
//
//  Created by Naman Jain on 27/12/18.
//  Copyright © 2018 Naman Jain. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    var homeController : HomeController?
    
    let imageView: UIImageView = {
        let number = Int.random(in: 0 ... 4)
        let iv = UIImageView(image: UIImage(named: "\(number)"))
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.text = "Revels 19"
        return label
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.tintColor = .white
        button.addTarget(self, action: #selector(openDeveloper), for: .touchUpInside)
        return button
    }()
    
    
    @objc func openDeveloper(){
        homeController?.openInfoView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom code for layout
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        backgroundColor = .red
        
        addSubview(imageView)
        imageView.fillSuperview()
        //blur
        setupVisualEffectBlur()
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 16, bottom: 16, right: 16), size: CGSize.init())
    }
    @objc func willEnterForeground(){
        animateToNewPhoto()
//        setupVisualEffectBlur()
//        animator.fractionComplete = 0
    }
    
    var animator: UIViewPropertyAnimator!
    var statusAnimator: UIViewPropertyAnimator!
    
    fileprivate func setupVisualEffectBlur() {
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [weak self] in
            
            // treat this area as the end state of your animation
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            
            self?.addSubview(visualEffectView)
            visualEffectView.fillSuperview()
            if let label = self?.titleLabel{
                self?.addSubview(label)
                label.anchor(top: nil, leading: self?.leadingAnchor, bottom: self?.bottomAnchor, trailing: self?.trailingAnchor, padding: UIEdgeInsets.init(top: 0, left: 16, bottom: 16, right: 16), size: CGSize.init())
            }
        })
        
        statusAnimator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = .black
        })
        
    }
    
    @objc func animateToNewPhoto(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                let number = Int.random(in: 0 ... 4)
                self.imageView.image = UIImage(named: "\(number)")
            }, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

