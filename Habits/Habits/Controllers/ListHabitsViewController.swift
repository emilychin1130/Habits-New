//
//  ListHabitsViewController.swift
//  Habits
//
//  Created by Emily Chin on 7/17/17.
//  Copyright © 2017 Emily Chin. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class ListHabitsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBAction func unwindToListHabitsViewController(_ segue: UIStoryboardSegue) {

        self.habits = CoreDataHelper.retrieveHabits()
        
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habits = CoreDataHelper.retrieveHabits()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scheduleAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var habits = [Habit]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.delete(habit: habits[indexPath.row])
            habits = CoreDataHelper.retrieveHabits()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! ListHabitsCell
        
        let row = indexPath.row
        
        let habit = habits[row]
        
        cell.nameOfHabit.text = habit.habit
        
        cell.numberOfDays.text = "\(habit.days) DAYS"
        
        return cell
        
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PointsCell") as! HabitsPointsCell
////            cell.usernameLabel.text = post.poster.username
//            
//                return cell
//            
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell") as! AddHabitsCell
////            let imageURL = URL(string: post.imageURL)
////            cell.postImageView.kf.setImage(with: imageURL)
//            
//                return cell
//            
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! ListHabitsCell
////            cell.delegate = self
////            configureCell(cell, with: post)
//            
//                return cell
//            
//        default:
//            fatalError("Error: unexpected indexPath.")
//        }

    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
        
//        switch indexPath.row {
//        case 0:
//            return 40
//            
//        case 1:
//            return 50
//            
//        case 2:
//            return 75
//            
//        default:
//            fatalError()
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayHabit" {
                print("Table view cell tapped")
                
                let indexPath = tableView.indexPathForSelectedRow!
                
                let habit = habits[indexPath.row]
                
                let habitInformationViewController = segue.destination as! HabitInformationViewController
                
               habitInformationViewController.habit = habit
                
            } else if identifier == "addHabit" {
                print("+ button tapped")
            }
        }
    }
    
    // TIME DICTIONARIES
    
    var hourDictionary = [String:Int]()
    var minuteDictionary = [String:Int]()
    
    func addToDictionaries() {
        for habit in habits {
            if habit.hour != nil {
                hourDictionary[habit.habit!] = Int(habit.hour!)
            }
        }
        for habit in habits {
            if habit.minute != nil {
                minuteDictionary[habit.habit!] = Int(habit.minute!)
            }
        }
        print(hourDictionary)
        print(minuteDictionary)
    }
    
    func scheduleNotification(title: String, body: String, hour: Int, minute: Int) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "10.second.message", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func scheduleAll() {
        addToDictionaries()
        for habit in habits {
            if let name = habit.habit{
                scheduleNotification(title: "Time to do Your Tasks!", body: name, hour: hourDictionary[name]!, minute: minuteDictionary[name]!)
            }
        }
    }
}

