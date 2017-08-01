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
    var habit: Habit?
 //   var numberOfDays: Int = 0
    
    var numberOfPoints: Int = 0
    
    @IBAction func unwindToListHabitsViewController(_ segue: UIStoryboardSegue) {

        self.habits = CoreDataHelper.retrieveHabits()
        
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        habits = CoreDataHelper.retrieveHabits()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
        
        scheduleAll()
    }
    
//    func showEditing(sender: UIBarButtonItem)
//    {
//        if(self.tableView.isEditing == true)
//        {
//            self.tableView.isEditing = false
//            self.navigationItem.rightBarButtonItem?.title = "Done"
//        }
//        else
//        {
//            self.tableView.isEditing = true
//            self.navigationItem.rightBarButtonItem?.title = "Edit"
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var habits = [Habit]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // TABLE VIEW
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.delete(habit: habits[indexPath.row])
            habits = CoreDataHelper.retrieveHabits()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let row = indexPath.row
        if tableView.isEditing == true {
            self.performSegue(withIdentifier: "displayHabit", sender: nil)
        } else {
            let habit = habits[row]
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
                habit.days -= 1
                habit.checked = false
                CoreDataHelper.saveHabit()
            } else {
                cell?.accessoryType = .checkmark
                habit.days += 1
                habit.checked = true
                CoreDataHelper.saveHabit()
            }
            print(habit.days)
            print(habit.checked)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell") as! ListHabitsCell
        
        let row = indexPath.row
        
        let habit = habits[row]
        
        cell.nameOfHabit.text = "\(habit.habit!) | \(habit.hour!):\(habit.minute!)"
        
        cell.numberOfDays.text = "\(habit.days) DAYS"
        
        if habit.checked == true {
            cell.accessoryType = .checkmark
        } else
        {
            cell.accessoryType = .none
        }
        
        print(habit.days)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if self.tableView.isEditing == false {
            self.tableView.isEditing = true
            editButton.title = "Done"
        } else {
            self.tableView.isEditing = false
            editButton.title = "Edit"
        }
        
    }
    
    // TIME DICTIONARIES
    
    var hourDictionary = [String:Int]()
    var minuteDictionary = [String:Int]()
    
    func addToDictionaries() {
        for habit in habits {
            if habit.hour != nil {
                print(habit.hour)
                hourDictionary[habit.habit!] = Int(habit.hour!)
                print(hourDictionary[habit.habit!])
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
    
    func scheduleNotification(title: String, body: String, hour: Int, minute: Int, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func scheduleAll() {
        addToDictionaries()
        for habit in habits {
            if let name = habit.habit {
                if hourDictionary[name] != nil && minuteDictionary[name] != nil {
                    scheduleNotification(title: "Time to do Your Tasks!", body: name, hour: hourDictionary[name]!, minute: minuteDictionary[name]!, identifier: name)
                }
                else {
                    print("no2")
                }
            } else { print("no1") }
        }
    }

}

