//
//  EventsController.swift
//  Revels
//
//  Created by Vedant Jain on 26/02/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Alamofire

class EventsController: UITableViewController {
    
    var tapped = ""
    var eventID = 0
    private let cellID = "cellID"
    var data: [Event] = []
    
    //gradients
    private var firstColour: [UIColor] = [UIColor.init(r: 227, g: 122, b: 180), UIColor.init(r: 247, g: 226, b: 170), UIColor.init(r: 135, g: 145, b: 179), UIColor.init(r: 33, g: 147, b: 176), UIColor.init(r: 201, g: 75, b: 75)]
    private var secondColour: [UIColor] = [UIColor.init(r: 228, g: 144, b: 151), UIColor.init(r: 223, g: 168, b: 157), UIColor.init(r: 128, g: 91, b: 146), UIColor.init(r: 109, g: 213, b: 237), UIColor.init(r: 75, g: 19, b: 79)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.backgroundColor = .white
        
        self.title = tapped
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
//        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.dataSource = self;
        tableView.delegate = self;

        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventTableViewCell
        cell.backgroundCard.layer.insertSublayer(gradient(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height), firstColor: firstColour[indexPath.item%firstColour.count], secondColor: secondColour[indexPath.item%secondColour.count]), at: 0)
        cell.titleLabel.text = data[indexPath.item].name
        cell.descLabel.text = data[indexPath.item].short_desc
        if (data[indexPath.item].min_size == data[indexPath.item].max_size) {
            if let parts = data[indexPath.item].min_size {
                cell.sizeLabel.text = "Participant(s): \(parts)"
            }
        } else {
            if let parts1 = data[indexPath.item].min_size {
                if let parts2 = data[indexPath.item].max_size {
                        cell.sizeLabel.text = "Participant(s): \(parts1) - \(parts2)"
                }
            }

        }
        cell.delegateCardButton.tag = indexPath.row
        cell.delegateCardButton.addTarget(self, action: #selector(EventsController.delegateButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func delegateButtonTapped(_ sender: UIButton!) {
        print("delegateButtonTapped")
        guard let cell = sender.superview as? EventTableViewCell  else { return }
        let indexPath: Int = (tableView.indexPath(for: cell)?.item)!
        var message = "You can buy the delegate card"
        if data[indexPath].del_card_type == 1{
            message = "Name: Gaming I\n\nThis card fetches you the opportunity to explore the battle fields of DOTA, COD and CS\n\nMAHE Price: 200\nNon MAHE Price: 250"
        }else if data[indexPath].del_card_type == 2{
            message = "Name: Gaming II\n\nThis card would allow you to join us on the grounds of FIFA, PUBG, BLUR.\n\nMAHE Price: 150\nNon MAHE Price: 200"
        }else if data[indexPath].del_card_type == 3{
            message = "Name: Pre Revels\n\nThis card enables you to explore all your talents in a preliminary round, winning these permits you to jump to the Revels events.\n\nMAHE Price: 200\nNon MAHE Price: 250"
        }else if data[indexPath].del_card_type == 4{
            message = "Name: General\n\nShowcase all the talents you have, and participate in multiple events and win exciting cash prices.\n\nMAHE Price: 250\nNon MAHE Price: 300"
        }else if data[indexPath].del_card_type == 5{
            message = "Name: Flagship\n\nThe heart of the fest are these events, to be a part of them you gotta have this precious Delegate card.\n\nMAHE Price: 300\nNon MAHE Price: 350"
        }else if data[indexPath].del_card_type == 6{
            message = "Name: MIT DT With Accomodation\n\nDon’t raise your voice, improve your arguments in this NATIONAL DEBATE TOURNAMENT. We also provide you with a comfortable stay at a very nominal costing.\n\nMAHE Price: 2500\nNon MAHE Price: 2500"
        }else if data[indexPath].del_card_type == 7{
            message = "Name: MIT DT Without Accomodation\n\nDon’t raise your voice, improve your arguments in this NATIONAL DEBATE TOURNAMENT. We also provide you with a comfortable stay at a very nominal costing.\n\nMAHE Price: 2100\nNon MAHE Price: 2100"
        }else if data[indexPath].del_card_type == 8{
            message = "Name: Proshow\n\nThis card enables you to attend days 3 and 4 of PROSHOW. Enjoy the amazing lineup of stars we have in store for you\n\nMAHE Price: 300\nNon MAHE Price: 400"
        }else if data[indexPath].del_card_type == 9{
            message = "Name: Internal Workshops\n\nThis card allows you to take part in all the internal workshops held during Pre Revels\n\nMAHE Price: 150\nNon MAHE Price: 200"
        }
        else if data[indexPath].del_card_type == 10{
            message = "Name: Gaming R6G\n\nThis card will allow you to participate in the online RAINBOW 6 SIEGE tournament\n\nMAHE Price: 300\nNon MAHE Price: 300"
        }
        else {
            message = "Sports delegate card required"
        }

        let actionSheet = UIAlertController(title: "Delegate Card", message: message, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            //cancel
        }))
        print(message)
        
        self.present(actionSheet, animated: true, completion: nil)
        return
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentEventCard(id: data[indexPath.row].id!, long: data[indexPath.row].long_desc!, min: data[indexPath.row].min_size!, max: data[indexPath.row].max_size!, name: data[indexPath.row].name!)
    }
    
    func presentEventCard(id: Int, long: String, min: Int, max: Int, name: String){
        var message = long
        message.append("\n\nMinimum team size: \(min)\nMaximum team size: \(max)")
        
        let actionSheet = UIAlertController(title: name, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let registerAction = UIAlertAction(title: "Register for Event", style: .default){ action in
            if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Sign in to Register", message: "You need to be signed in to register.", preferredStyle: UIAlertController.Style.alert)
                    let logInAction = UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
                        let loginController = LoginController()
                        self.present(loginController, animated: true, completion: nil)
                    })
                    let createNewAccountAction = UIAlertAction(title: "Create New Account", style: .default, handler: { (action) in
                        if let url = URL(string: "https://register.mitrevels.in"){
                            UIApplication.shared.open(url)
                        }
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(logInAction)
                    alertController.addAction(createNewAccountAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                })
                return
            }else{
                
                let parameters : Dictionary = ["eventid" : id]
                
                
                Alamofire.request("https://register.mitrevels.in/createteam", method: .post, parameters: parameters).responseJSON{ response in
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
            
                                    let alertController = UIAlertController(title: "Congatulations!", message: "You have successfully registered for \(name).", preferredStyle: .alert)
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
                            if message as! String == "Card for event not bought" {
                                DispatchQueue.main.async(execute: {
                                    let alertController = UIAlertController(title: "Uh, Oh!", message: "You have not bought the delegate card that is required for this event.", preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                })
                            }else if message as! String == "User already registered for event" {
                                DispatchQueue.main.async(execute: {
                                    let alertController = UIAlertController(title: "Yay!", message: "You have already registered for this event.", preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                })
                            }else{
                                DispatchQueue.main.async(execute: {
                                    let alertController = UIAlertController(title: "Uh, Oh!", message: message as? String, preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                })
                            }
                            
                        }
                        break
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        actionSheet.addAction(registerAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
        
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
