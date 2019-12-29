//
//  Model.swift
//  Revels
//
//  Created by Naman Jain on 31/01/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation
import UIKit

var eventsFilePath: String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("Events").path
}

var categoriesFilePath: String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("Categories").path
}

var scheduleFilePath: String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("Schedules").path
}



struct CategoriesResponse : Decodable {
    let success : Bool
    let data : [Categories]?
}

struct Categories : Decodable {
    let id : Int?
    let name : String?
    let type : String?
    let description : String?
    let cc1_name : String?
    let cc1_contact : String?
    let cc2_name : String?
    let cc2_contact : String?
}

struct ScheduleEvent{
    let event: Event?
    let eventTime: String?
    let eventVenue: String?
    let eventRound: Int?
    
    init(event: Event, time: String, venue: String, round: Int) {
        self.event = event
        self.eventTime = time
        self.eventVenue = venue
        self.eventRound = round
    }
    
    func returnName() -> String{
        if let name = event?.name{
            return name
        }
        return "event n/a"
    }
}

struct EventResponse : Decodable {
    let success: Bool
    let data: [Event]?
}

class Event : NSObject, Decodable, NSCoding {
    
    struct keys {
        static let id = "id"
        static let category = "category"
        static let name = "name"
        static let short_desc = "short_desc"
        static let long_desc = "long_desc"
        static let del_card_type = "del_card_type"
        static let min_size = "min_size"
        static let max_size = "max_size"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: keys.id)
        aCoder.encode(name, forKey: keys.name)
        aCoder.encode(long_desc, forKey: keys.long_desc)
        aCoder.encode(short_desc, forKey: keys.short_desc)
        aCoder.encode(min_size, forKey: keys.min_size)
        aCoder.encode(max_size, forKey: keys.max_size)
        aCoder.encode(del_card_type, forKey: keys.del_card_type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let id1 = aDecoder.decodeObject(forKey: "id") as? Int{
            id = id1
        }
        if let category1 = aDecoder.decodeObject(forKey: "category") as? Int{
            category = category1
        }
        if let name1 = aDecoder.decodeObject(forKey: "name") as? String{
            name = name1
        }
        if let short_desc1 = aDecoder.decodeObject(forKey: "short_desc") as? String{
            short_desc = short_desc1
        }
        if let long_desc1 = aDecoder.decodeObject(forKey: "long_desc") as? String{
            long_desc = long_desc1
        }
        if let min_size1 = aDecoder.decodeObject(forKey: "min_size") as? Int{
            min_size = min_size1
        }
        if let max_size1 = aDecoder.decodeObject(forKey: "max_size") as? Int{
            max_size = max_size1
        }
        if let del_card_type1 = aDecoder.decodeObject(forKey: "del_card_type") as? Int{
            del_card_type = del_card_type1
        }
        
    }
    
    var id: Int?
    var category: Int?
    var name: String?
    var short_desc: String?
    var long_desc: String?
    var min_size: Int?
    var max_size: Int?
    var del_card_type: Int?
    
    override init() {
    }
}

struct ScheduleResponse : Decodable {
    let success: Bool
    let data: [Schedule]?
}

class Schedule : NSObject, Decodable, NSCoding  {
    struct keys {
        static let event = "event"
        static let round = "round"
        static let start = "start"
        static let end = "end"
        static let location = "location"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(event, forKey: keys.event)
        aCoder.encode(round, forKey: keys.round)
        aCoder.encode(start, forKey: keys.start)
        aCoder.encode(end, forKey: keys.end)
        aCoder.encode(location, forKey: keys.location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let event1 = aDecoder.decodeObject(forKey: "event") as? Int{
            event = event1
        }
        if let round1 = aDecoder.decodeObject(forKey: "round") as? Int{
            round = round1
        }
        if let start1 = aDecoder.decodeObject(forKey: "start") as? String{
            start = start1
        }
        if let end1 = aDecoder.decodeObject(forKey: "end") as? String{
            end = end1
        }
        if let location1 = aDecoder.decodeObject(forKey: "location") as? String{
            location = location1
        }
        
    }
    
    var event: Int?
    var round: Int?
    var start: String?
    var end: String?
    var location: String?
    
    override init() {
    }

}

struct DataStruct: Decodable {
    let id: Int
    let name: String
    let type: String
    let description: String
    let cc1_name: String
    let cc1_contact: String
    let cc2_name: String
    let cc2_contact: String
    
    init() {
        id = -1
        name = ""
        type = ""
        description = ""
        cc1_name = ""
        cc1_contact = ""
        cc2_name = ""
        cc2_contact = ""
    }
}
