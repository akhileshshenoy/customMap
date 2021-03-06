//
//  AboutCollectionViewController.swift
//  Revels
//
//  Created by Vedant Jain on 01/03/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class AboutCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "cellID"
    private let names = ["Saptarshi", "Ritvik", "Harsh", "Akshit", "Ankush", "Naman", "Vaishnavi", "Vedant"]
    private let images: [UIImage] = [UIImage(named: "saptarshi") ?? UIImage(), UIImage(named: "ritvik") ?? UIImage(), UIImage(named: "harsh") ?? UIImage(), UIImage(named: "ankush") ?? UIImage(), UIImage(named: "naman") ?? UIImage(), UIImage(named: "vaishnavi") ?? UIImage(), UIImage(named: "vedant") ?? UIImage()]
    private let posts = [1, 1, 1, 0, 0, 0 ,0, 0]
    private let platform = [0, 0, 1, 0, 0, 1, 0, 1]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView.backgroundColor = UIColor(r: 240, g: 240, b: 240)

        // Register cell classes
        self.collectionView!.register(AboutCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popViewController))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        self.navigationItem.title = "Developers"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-24, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AboutCollectionViewCell
        // Configure the cell
        cell.imageView.image = UIImage(named: names[indexPath.item].lowercased())
        cell.titleLabel.text = names[indexPath.item]
        if posts[indexPath.item] == 1 {
            cell.postLabel.text = "Category Head"
        }
        else {
            cell.postLabel.text = "Organizer"
        }
        
        if platform[indexPath.item] == 0 {
            cell.platformLabel.text = "Android"
        }
        else {
            cell.platformLabel.text = "iOS"
        }
        return cell
    }

}
