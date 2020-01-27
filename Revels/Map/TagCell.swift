//
//  TagCell.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 24/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell {

    var color: UIColor?{
        didSet {
            if isSelected{
                label.textColor = color
                backgroundCardView.layer.borderColor = color?.cgColor
            }
        }
    }
    let backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.0628238342, green: 0.0628238342, blue: 0.0628238342, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.15
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()

    let label: UILabel = {
        let l = UILabel()
        l.text = "Tag"
        l.textAlignment = .center
        l.textColor = .lightGray
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return l
    }()

    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? color ?? .black : .lightGray
            label.font = isSelected ? UIFont.systemFont(ofSize: 14, weight: .medium) : UIFont.systemFont(ofSize: 14, weight: .regular)
            backgroundCardView.layer.borderColor = isSelected ? color?.cgColor : UIColor.lightGray.cgColor
            backgroundCardView.layer.borderWidth = isSelected ? 0.4 : 0.15
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundCardView)
        _=backgroundCardView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        backgroundCardView.addSubview(label)
        _=label.anchor(backgroundCardView.topAnchor, left: backgroundCardView.leftAnchor, bottom: backgroundCardView.bottomAnchor, right: backgroundCardView.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
