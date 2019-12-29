//
//  CategoriesController.swift
//  Revels
//
//  Created by Vedant Jain on 16/01/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
    
    fileprivate let cellId = "cellId"
    fileprivate let headerId = "headerId"
    fileprivate let postID = "postID"
    
    fileprivate let padding: CGFloat = 16
    fileprivate var lightStatusBar: Bool = true
    var categories = [Categories]()
    
    var myAnimator: UIViewPropertyAnimator?
    
    var headerView: HeaderView?
    
    let headerBar: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Revels'19"
        return label
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.tintColor = .white
        button.addTarget(self, action: #selector(openInfoView), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    fileprivate func setupCustomNavigationBar() {
        view.addSubview(infoButton)
        infoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets.init(top: 16, left: 0, bottom: 0, right: 32), size: CGSize.init())

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if lightStatusBar{
            return .lightContent
        }else{
            return .default
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let headerView = headerView {
            headerView.willEnterForeground()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        headerView?.animator.fractionComplete = (-contentOffsetY / 100) - 0.25
        
        if contentOffsetY > view.frame.width*1080/1920 - (UIApplication.shared.statusBarFrame.height){
            self.lightStatusBar = false
            infoButton.alpha = 0
            setNeedsStatusBarAppearanceUpdate()
            setWhiteStatusBar()
        }else{
            self.lightStatusBar = true
            infoButton.alpha = 1
            setNeedsStatusBarAppearanceUpdate()
            setClearStatusBar()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width*1080/1920)
    }
    
    func setWhiteStatusBar(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = .white
        }, completion: nil)
    }
    
    func setClearStatusBar(){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = .clear
        }, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderView
        return headerView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupCustomNavigationBar()
        
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: postID)
        
        collectionView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Home"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.item == 1) {
            let cell: PostCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: postID, for: indexPath) as! PostCollectionViewCell
            cell.headerLabel.text = "MIT Post"
            cell.newsletterButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
            cell.newsletterButton.setBackgroundImage(UIImage(named: "newspaper"), for: .normal)
            cell.newsletterButton.tag = 0
            cell.liveBlogButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
            cell.liveBlogButton.tag = 1
            cell.liveBlogButton.setBackgroundImage(UIImage(named: "newspaper2"), for: .normal)
            cell.instagramButton.tag = 2
            cell.instagramButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
            cell.instagramButton.setBackgroundImage(UIImage(named: "ig-1"), for: .normal)
            return cell
        } else {
            let cell: HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
            cell.title.text = "Events Today"
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM, EEEE"
            let dayText = formatter.string(from: currentDate)
            cell.subtitle.text = dayText
            return cell
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 1 {
            return CGSize(width: view.frame.width, height: 400)
        }
        
        return CGSize(width: view.frame.width, height: 250)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func openInfoView() {
        
        let about = AboutCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let aboutNavigationController = UINavigationController(rootViewController: about)
        self.present(aboutNavigationController, animated: true, completion: nil)
        
    }
    
    @objc func openLink(sender: UIButton) {
        
        var urlString = "https://themitpost.com/revels19-newsletter-day-"
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let day0 = formatter.date(from: "2019/03/06 08:00")
        let day1 = formatter.date(from: "2019/03/07 08:00")
        let day2 = formatter.date(from: "2019/03/08 08:00")
        let day3 = formatter.date(from: "2019/03/09 08:00")
        let revelsDay = formatter.date(from: "2019/03/06 00:00")
        
        if currentDate > day0! && currentDate < day1!{
            urlString = "https://themitpost.com/revels19-newsletter-day-0"
        }else if currentDate > day1! && currentDate < day2!{
            urlString = "https://themitpost.com/revels19-newsletter-day-1"
        }else if currentDate > day2! && currentDate < day3!{
            urlString = "https://themitpost.com/revels19-newsletter-day-2"
        }else if currentDate > day3!{
            urlString = "https://themitpost.com/revels19-newsletter-day-3"
        }else{
            urlString = "https://themitpost.com/"
        }
        
        var url = URL(string: urlString)
        if sender.tag == 0 {
            url = URL(string: urlString)
            let safariVC = SFSafariViewController(url: url ?? URL(string: "https://themitpost.com/")!)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
        else if sender.tag == 1 {
            if currentDate > revelsDay! {
                urlString = "http://themitpost.com/revels-19-liveblog"
            }else{
                urlString = "http://themitpost.com/"
            }

            let safariVC = SFSafariViewController(url: url ?? URL(string: "https://google.com")!)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
        else {
            // open instagram
            let Username =  "revelsmit"
            let appURL = URL(string: "instagram://user?username=\(Username)")!
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL) {
                application.open(appURL)
            } else {
                // if Instagram app is not installed, open URL inside Safari
                let webURL = URL(string: "https://instagram.com/\(Username)")!
                application.open(webURL)
            }
        }
    }
    
}
