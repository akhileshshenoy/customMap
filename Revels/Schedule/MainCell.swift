//
//  MainCell.swift
//  Revels
//
//  Created by Naman Jain on 19/12/18.
//  Copyright © 2018 Naman Jain. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var data = [ScheduleEvent]()
    var screenHeight: CGFloat = 200
    var scheduleController: ScheduleController?
    
    private var firstColour: [UIColor] = [UIColor.init(r: 227, g: 122, b: 180), UIColor.init(r: 247, g: 226, b: 170), UIColor.init(r: 135, g: 145, b: 179), UIColor.init(r: 33, g: 147, b: 176), UIColor.init(r: 201, g: 75, b: 75), UIColor(red:0.99, green:0.45, blue:0.42, alpha:1.0)]
    private var secondColour: [UIColor] = [UIColor.init(r: 228, g: 144, b: 151), UIColor.init(r: 223, g: 168, b: 157), UIColor.init(r: 128, g: 91, b: 146), UIColor.init(r: 109, g: 213, b: 237), UIColor.init(r: 75, g: 19, b: 79), UIColor(red:1.00, green:0.56, blue:0.41, alpha:1.0)]
    
    
    fileprivate let cellId = "cellId"
    fileprivate let loaderCellId = "loaderCellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        tableView.register(EventCell.self, forCellReuseIdentifier: cellId)
        tableView.register(LoaderTVCell.self, forCellReuseIdentifier: loaderCellId)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        _ = tableView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0{
            return 1
        }else{
            return data.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if data.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: loaderCellId, for: indexPath) as! LoaderTVCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EventCell
            cell.selectionStyle = .none
            cell.backgroundCard.layer.insertSublayer(gradient(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height), firstColor: firstColour[indexPath.row%firstColour.count], secondColor: secondColour[indexPath.row%secondColour.count]), at: 0)
            cell.titleLabel.text = data[indexPath.row].returnName()
            cell.dateLabel.text = (data[indexPath.row].event?.short_desc)!
            guard let time = data[indexPath.row].eventTime, let venue = data[indexPath.row].eventVenue, let round = data[indexPath.row].eventRound else{
                cell.locationLabel.text = "NULL"
                return cell
            }
            cell.locationLabel.text = "Round \(round)\n" + venue + "\n" + time
        
                cell.titleLabel.textColor = .white
                cell.dateLabel.textColor = .white
                cell.locationLabel.textColor = .white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data.count == 0 {
            return screenHeight
        }
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
        if data.count == 0 {
            return
        }else{
            scheduleController?.presentEventCard(event: data[indexPath.row])
        }
    }
    
    
    func gradient(frame:CGRect, firstColor: UIColor, secondColor: UIColor) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [
            firstColor.cgColor, secondColor.cgColor]
        return layer
    }
}
