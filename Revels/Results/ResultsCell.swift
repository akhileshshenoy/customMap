//
//  ResultsCell.swift
//  Revels
//
//  Created by Vedant Jain on 28/02/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupViews()
    }
    
    var roundLabel: UILabel = {
        let label = UILabel()
        return UILabel()
    }()
    
    var positionLabel: UILabel = {
        let label = UILabel()
        return UILabel()
    }()
    
    var teamLabel: UILabel = {
        let label = UILabel()
        return UILabel()
    }()
    
    func setupViews() {
        
        addSubview(roundLabel)
        addSubview(positionLabel)
        addSubview(teamLabel)
        
        //don't move this to label initialisers
        roundLabel.textAlignment = .center
        positionLabel.textAlignment = .center
        teamLabel.textAlignment = .center
        
//        _ = roundLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: (frame.width/3), heightConstant: 0)
//        _ = positionLabel.anchor(topAnchor, left: roundLabel.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: (frame.width/3), heightConstant: 0)
//        _ = teamLabel.anchor(topAnchor, left: positionLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: (frame.width/3), heightConstant: 0)
        
        roundLabel.frame = CGRect(x: 0, y: 0, width: frame.width/3, height: frame.height)
        positionLabel.frame = CGRect(x: frame.width/3, y: 0, width: frame.width/3, height: frame.height)
        teamLabel.frame = CGRect(x: 2*frame.width/3, y: 0, width: frame.width/3, height: frame.height)
        
    }
    
}
