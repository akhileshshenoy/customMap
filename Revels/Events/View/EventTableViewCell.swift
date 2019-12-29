//
//  EventTableViewCell.swift
//  Revels
//
//  Created by Vedant Jain on 27/02/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupViews()
    }
    
    var backgroundCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    var delegateCardLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    var delegateCardButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 5
        button.setTitle("Delegate Card", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        
        return button
    }()
    
    func setupViews() {
        
        addSubview(backgroundCard)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(sizeLabel)
        addSubview(delegateCardButton)
        
        _ = backgroundCard.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = titleLabel.anchor(backgroundCard.topAnchor, left: backgroundCard.leftAnchor, bottom: nil, right: backgroundCard.rightAnchor
            , topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
        _ = descLabel.anchor(titleLabel.bottomAnchor, left: backgroundCard.leftAnchor, bottom: delegateCardButton.topAnchor, right: backgroundCard.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = delegateCardButton.anchor(nil, left: nil, bottom: backgroundCard.bottomAnchor, right: backgroundCard.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 100, heightConstant: 25)
        _ = sizeLabel.anchor(nil, left: backgroundCard.leftAnchor, bottom: backgroundCard.bottomAnchor, right: delegateCardButton.leftAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 25)
    }
    
}
