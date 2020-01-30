//
//  TagsController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 24/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class TagsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let cellId = "cellId"

    var tags = [String]()
    var specialColor: UIColor?

    var delegate: TagsControllerDelegate?

    let menuBar: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()

    lazy var markerBar: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let shadowBar: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()


    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        delegate?.didTapTag(indexPath: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = -8
            layout.minimumInteritemSpacing = -8
        }
        collectionView.showsHorizontalScrollIndicator = false
    }

    override func viewDidAppear(_ animated: Bool) {
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TagCell
        cell.label.text = tags[indexPath.item]
        if let color = specialColor{
            cell.color = color
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //UIFont.systemFont(ofSize: 16, weight: .regular)
        let tag = self.tags[indexPath.item]
        let width = tag.width(withConstrainedHeight: 35, font: UIFont.systemFont(ofSize: 16, weight: .regular)) + 48
        return .init(width: width, height: 40)
    }

}




