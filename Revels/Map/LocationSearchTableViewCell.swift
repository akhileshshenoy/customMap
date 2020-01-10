//
//  LocationSearchTableViewCell.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 10/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class LocationSearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupViews()
        // Configure the view for the selected state
    }
    
    var placeLabel: UILabel = {
        let label = UILabel()
        return UILabel()
    }()
    
    func setupViews() {
    addSubview(placeLabel)
    placeLabel.textAlignment = .left
        placeLabel.textColor = .black
    placeLabel.frame = CGRect(x: 25, y: 0, width: frame.width/3, height: frame.height)
    }
}
