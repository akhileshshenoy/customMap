//
//  MyEventsTableViewController.swift
//  Revels
//
//  Created by Naman Jain on 28/02/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Alamofire


class MyEventsTableViewController: UITableViewController {
    
    var events = [Event]()
    var registeredEvents = [registeredEvent]()
    var eventDict = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissVC))
        self.navigationItem.title = "Registered Events"
        tableView.register(TutorialCell.self, forCellReuseIdentifier: "tutorialCellId")
        tableView.register(LoaderTVCell.self, forCellReuseIdentifier: "loaderCellId")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        getEvents()
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registeredEvents.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if registeredEvents.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loaderCellId", for: indexPath) as! LoaderTVCell
            cell.selectionStyle = .none
            return cell
        }else{
            if indexPath.row == registeredEvents.count{
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                return cell!
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "tutorialCellId", for: indexPath) as! TutorialCell
            cell.selectionStyle = .none
            let regEvent = registeredEvents[indexPath.row]
            if let eventId = regEvent.event {
                if let event = eventDict[eventId] as? Event{
                   cell.titleLabel.text = event.name
                    cell.bodyLabel.text = "Team ID: \(regEvent.teamid!)\nRound: \(regEvent.round!)\nDelegate ID: \(regEvent.delid!)"
                    cell.dateLabel.text = "Tap to add a team mate or leave the team."
                }
            }
//            cell.bodyLabel.text = Tutorials[indexPath.row].description
//            if let name = Tutorials[indexPath.row].author{
//                cell.dateLabel.text = "Written by \(name)"
//            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentEventCard(event: registeredEvents[indexPath.row])
//        print(registeredEvents[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if registeredEvents.count == 0 {
            if let tabBarHeight = self.tabBarController?.tabBar.frame.height{
                print(tabBarHeight)
                if let navBarHeight = self.navigationController?.navigationBar.intrinsicContentSize.height{
                    print(navBarHeight)
                    let guide = view.safeAreaLayoutGuide
                    let height = guide.layoutFrame.size.height - (UIApplication.shared.statusBarFrame.height + tabBarHeight + navBarHeight + 60)
                    return height
                }
            }else{
                return 200
            }
        }
        if indexPath.row == registeredEvents.count{
            return 16
            
        }
        return UITableView.automaticDimension
    }
    
    private func getData(){
        if let retrievedEventsData = NSKeyedUnarchiver.unarchiveObject(withFile: eventsFilePath) as? [Event]{
            self.events = retrievedEventsData
            self.getRegisteredEvents()
        }else{
            self.getEvents()
        }
    }
    
    func getEvents(){
        Alamofire.request("https://api.mitrevels.in/events", method: .get, parameters: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data{
                    do{
                        let response = try JSONDecoder().decode(EventResponse.self, from: data)
                        if let events = response.data{
                            self.events = events
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                self.getRegisteredEvents()
                            }
                        }else{
                            print("Coudnt get data")
                        }
                    }catch let error{
                        print(error)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getRegisteredEvents(){
        var eventId = [Int]()
        for item in events{
            eventId.append(item.id!)
        }
        
        eventDict = NSMutableDictionary(objects: events, forKeys: eventId as [NSCopying])
        
        Alamofire.request("https://register.mitrevels.in/registeredEvents", method: .get, parameters: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data{
                    do{
                        let response = try JSONDecoder().decode(registeredEventsResponse.self, from: data)
                        if response.data.count == 0 {
                            DispatchQueue.main.async(execute: {
                                let alertController = UIAlertController(title: "No events found", message: "You have not registered for any events. Please register through the schedules tab.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    self.dismissVC()
                                })
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                            return
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                self.registeredEvents = response.data
                                self.tableView.reloadData()
                                self.tableView.refreshControl?.endRefreshing()
                            }
                        }

                    }catch let error{
                        print(error)
                    }
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func presentEventCard(event : registeredEvent){
        guard let eventId = event.event, let teamId = event.teamid else{
            return
        }

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let reminderAction = UIAlertAction(title: "Add a Team Mate", style: .default){ action in
            let qrVC = QRViewController()
            qrVC.eventId = eventId
            self.present(qrVC, animated: true, completion: nil)
            return
        }
        let leaveTeamAction = UIAlertAction(title: "Leave Team", style: .default){ action in

                let parameters : Dictionary = ["teamid" : teamId]

                Alamofire.request("https://register.mitrevels.in/leaveteam", method: .post, parameters: parameters).responseJSON{ response in
                    switch response.result {
                    case .success:
                        guard let items = response.result.value as? [String:AnyObject] else {
                            DispatchQueue.main.async(execute: {
                                let alertController = UIAlertController(title: "Unable to Fetch Data", message: "Please try again later.", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                            return
                        }
                        if items["success"] as! Int == 1 {
                            DispatchQueue.main.async(execute: {
                                self.getRegisteredEvents()
                                let alertController = UIAlertController(title: "Successfully left team.", message: nil, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                        }else{
                            guard let message = items["msg"]  else {
                                DispatchQueue.main.async(execute: {
                                    let alertController = UIAlertController(title: "Uh, Oh!", message: "Some issue occured, please try again later.", preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                })
                                return
                            }
                            DispatchQueue.main.async(execute: {
                                let alertController = UIAlertController(title: "Uh, Oh!", message: message as? String, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            })
                        }
                        break
                    case .failure(let error):
                        print(error)
                    }
                }
        }
        actionSheet.addAction(leaveTeamAction)
        actionSheet.addAction(reminderAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }

}

class RegistedEventCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        setupViews()
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 8
        return label
    }()
    
    var ccLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    var callButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 17
        button.setImage(UIImage(named: "phone"), for: .normal)
        button.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        
        return button
    }()
    
    var backgroundCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 17
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        
        addSubview(backgroundCard)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(callButton)
        
        _ = backgroundCard.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = titleLabel.anchor(backgroundCard.topAnchor, left: backgroundCard.leftAnchor, bottom: nil, right: nil
            , topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
        _ = descLabel.anchor(titleLabel.bottomAnchor, left: backgroundCard.leftAnchor, bottom: callButton.topAnchor, right: backgroundCard.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        _ = callButton.anchor(nil, left: nil, bottom: backgroundCard.bottomAnchor, right: backgroundCard.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 50, heightConstant: 50)
        
        //for testing
        //        backgroundCard.frame = CGRect(x: 16, y: 16, width: self.frame.width-32, height: self.frame.height-32)
        //        titleLabel.frame = CGRect(x: 32, y: 32, width: self.frame.width-64, height: 25)
        //        descLabel.frame = CGRect(x: 32, y: 80, width: self.frame.width-64, height: 130)
        //        callButton.frame = CGRect(x: 32, y: 220, width: self.frame.width-64, height: 32)
        
        //        setupTitleLabel()
        //        setupCallButton()
        //        setupDescLabel()
        //        setupBackgroundCard()
        
    }
    
    fileprivate func setupTitleLabel() {
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 32).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    fileprivate func setupCallButton() {
        callButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = false
        callButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16).isActive = true
        callButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        callButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupDescLabel() {
        descLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 28).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: callButton.topAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setupBackgroundCard() {
        
        backgroundCard.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        backgroundCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        backgroundCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
        backgroundCard.bottomAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 16).isActive = true
        
    }
    
}
