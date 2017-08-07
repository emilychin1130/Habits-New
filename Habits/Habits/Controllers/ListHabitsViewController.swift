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
//    var habit: Habit?
 //   var numberOfDays: Int = 0
    var timer: Timer?
    var otherTimer: Timer?
    var reloadTimer: Timer?
 //   var numberOfPoints: Int = 0
    
//    var general = General()
    
    @IBAction func unwindToListHabitsViewController(_ segue: UIStoryboardSegue) {

        self.habits = CoreDataHelper.retrieveHabits()
        
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfPointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent

        habits = CoreDataHelper.retrieveHabits()
        
        setUpGeneral()
        
        reset()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
        
        let list = CoreDataHelper.retrieveGeneral()
        let general = list[0]
        
        numberOfPointsLabel.text = "\(general.points)"
        
        scheduleAll()
        
        let general1 = CoreDataHelper.retrieveGeneral()
        
        print(general1[0].rows)
        
//        if(timer != nil)
//        {
//            timer?.invalidate()
//        }
//        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(ListHabitsViewController.reset), userInfo: nil, repeats: true)
//        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
//        
//        if(otherTimer != nil)
//        {
//            otherTimer?.invalidate()
//        }
//        otherTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(ListHabitsViewController.setPoints), userInfo: nil, repeats: true)
//        RunLoop.current.add(otherTimer!, forMode: RunLoopMode.commonModes)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // CONTINUOUSLY RUN RESET AND SETPOINTS AND GENERAL
        
        if(timer != nil)
        {
            timer?.invalidate()
        }
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(ListHabitsViewController.reset), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        
        if(otherTimer != nil)
        {
            otherTimer?.invalidate()
        }
        otherTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(ListHabitsViewController.setPoints), userInfo: nil, repeats: true)
        RunLoop.current.add(otherTimer!, forMode: RunLoopMode.commonModes)
        
        if(reloadTimer != nil)
        {
            reloadTimer?.invalidate()
        }
        reloadTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(ListHabitsViewController.reload), userInfo: nil, repeats: true)
        RunLoop.current.add(reloadTimer!, forMode: RunLoopMode.commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        general.points = Int64(numberOfPoints) ?? 0
//        CoreDataHelper.saveGeneral()
//        timer?.invalidate()
//        otherTimer?.invalidate()
    }
    
    var habits = [Habit]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func setPoints() {
        let list = CoreDataHelper.retrieveGeneral()
        let general = list[0]
        numberOfPointsLabel.text = "\(general.points)"
    }
    
    // SETUP GENERAL
    
    func reload() {
        print("hi")
        let list = CoreDataHelper.retrieveGeneral()
        let general = list[0]
 //       general.points = Int64(numberOfPoints)
    //    CoreDataHelper.saveGeneral()
        numberOfPointsLabel.text = "\(general.points)"
        self.numberOfPointsLabel.reloadInputViews()
 //       general.points = Int64(numberOfPoints)
        CoreDataHelper.saveGeneral()
    }
    
    func setUpGeneral() {
        let list = CoreDataHelper.retrieveGeneral()
        if list.count == 0 {
            let general = CoreDataHelper.newGeneral()
            general.points = 0
            general.rows = 0
        } else if list.count == 1 {
            let general = CoreDataHelper.retrieveGeneral()
   //         numberOfPoints = Int(general[0].points)
            self.numberOfPointsLabel.reloadInputViews()
        }
        CoreDataHelper.saveGeneral()
    }
    
    func updateGeneral() {
        let general = CoreDataHelper.retrieveGeneral()
 //       general[0].points = Int64(numberOfPoints)
        CoreDataHelper.saveGeneral()
 //       self.numberOfPointsLabel.reloadInputViews()
    }
    
    // TABLE VIEW
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.delete(habit: habits[indexPath.row])
            habits = CoreDataHelper.retrieveHabits()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let general = CoreDataHelper.retrieveGeneral()
        return habits.count // (3 + Int(general[0].rows))
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
            let list = CoreDataHelper.retrieveGeneral()
            let general = list[0]
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
                habit.days -= 1
                habit.checked = false
                CoreDataHelper.saveHabit()
                general.points -= (1 + Int(habit.days))
            } else {
                cell?.accessoryType = .checkmark
                habit.days += 1
                habit.checked = true
                CoreDataHelper.saveHabit()
                general.points += Int(habit.days)
            }
  //          print(numberOfPoints)
            self.numberOfPointsLabel.reloadInputViews()
            self.tableView.reloadData()
        }
//        habit?.points = Int64(numberOfPoints)
//        print(habit?.points)
        CoreDataHelper.saveHabit()
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
                hourDictionary[habit.habit!] = Int(habit.hour!)
            }
        }
        for habit in habits {
            if habit.minute != nil {
                minuteDictionary[habit.habit!] = Int(habit.minute!)
            }
        }
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
                if hourDictionary[name] != nil && minuteDictionary[name] != nil && habit.notification == true {
                    scheduleNotification(title: "Time to do Your Tasks!", body: name, hour: hourDictionary[name]!, minute: minuteDictionary[name]!, identifier: name)
                }
                else {
                }
            } else { print("no1") }
        }
    }
    
    // RESET AT MIDNIGHT
    
    func reset() {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
       // print("hours = \(hour):\(minutes):\(seconds)")
        if "\(hour):\(minutes):\(seconds)" == "0:0:0" {
            for x in 0 ..< habits.count {
                if habits[x].checked == false {
                    habits[x].days = 0
                    CoreDataHelper.saveHabit()
                    self.tableView.reloadData()
                }
            }
            let cells = self.tableView.visibleCells
            for ListHabitsCell in cells {
                ListHabitsCell.accessoryType = .none
                for x in 0 ..< habits.count {
                    habits[x].checked = false
                }
            }
            CoreDataHelper.saveHabit()
            print("yay")
        }
//        let cal = Calendar(identifier: .gregorian)
//        let newDate = cal.startOfDay(for: date)
//        print(newDate)
    }



}

