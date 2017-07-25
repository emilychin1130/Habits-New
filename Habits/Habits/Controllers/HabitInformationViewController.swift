//
//  HabitInformationViewController.swift
//  Habits
//
//  Created by Emily Chin on 7/17/17.
//  Copyright © 2017 Emily Chin. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class HabitInformationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var habitNameTextField: UITextField!
    
    var habit: Habit?
    var chosenHour: String? = "1"
    var chosenMinute: String? = "00"
    
    var hourPickerData = ["Hour","1","2","3","4","5","6","7","8","9","10","11","12"]
    var minutePickerData = ["Minute","00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hourPicker.delegate = self
        self.hourPicker.dataSource = self
        
        hourPicker.tag = 0
        minutePicker.tag = 1
        
        self.minutePicker.delegate = self
        self.minutePicker.dataSource = self
        
        //NOTIFICATION PERMISSION
        
        initNotificationSetupCheck()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let habit = self.habit ?? CoreDataHelper.newHabit()
            habit.habit = habitNameTextField.text ?? ""
            habit.hour = chosenHour ?? ""
            habit.minute = chosenMinute ?? ""
    //      habit.days =
            CoreDataHelper.saveHabit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let habit = habit {
            //habit.hour = chosenHour
            habitNameTextField.text = habit.habit
            chosenHour = habit.hour
            chosenMinute = habit.minute
            if chosenHour != "Hour" && chosenMinute != "Minute" {
                displaySelectedTime.text = "\(chosenHour!)  :  \(chosenMinute!)"
            }
            else { displaySelectedTime.text = "" }
            
            //            noteContentTextView.text = note.content
        } else {
            habitNameTextField.text = ""
            chosenHour = ""
            chosenMinute = ""
            //            noteContentTextView.text = ""
        }
    }
    
    // NOTIFICATION PERMISSION
 
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
    
    // ALARM
    
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var minutePicker: UIPickerView!
    @IBOutlet weak var displaySelectedTime: UILabel!
    @IBOutlet weak var ampmSelector: UISegmentedControl!
    
    //var hourPickerData: [Int] = [Int]()
   // var minutePickerData: [Int] = [Int]()
    
    // PICKER
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hourPicker {
            return hourPickerData.count
        }
        else if pickerView == minutePicker {
            return minutePickerData.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == hourPicker {
            return hourPickerData[row]
        }
        else if pickerView == minutePicker {
            return minutePickerData[row]
        }
        return "1"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPicker {
            chosenHour = hourPickerData[row]
        }
        else if pickerView == minutePicker {
            chosenMinute = minutePickerData[row]
        }
        if chosenHour != "Hour" && chosenMinute != "Minute" {
            displaySelectedTime.text = "\(chosenHour!)  :  \(chosenMinute!)"
        }
        else { displaySelectedTime.text = "" }
    }
    
    // AM PM
    
    
    
    // NOTIFICATION
    
//    func scheduleNotification() {
//        let center = UNUserNotificationCenter.current()
//        
//        let content = UNMutableNotificationContent()
//        content.title = "Late wake up call"
//        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
////        content.categoryIdentifier = "alarm"
////        content.userInfo = ["customData": "fizzbuzz"]
//        //content.sound = UNNotificationSound.default()
//        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 11
//        dateComponents.minute = 16
//     //   dateComponents.weekday = 1 // day of the week ??
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        
//        let request = UNNotificationRequest(identifier: "10.second.message", content: content, trigger: trigger)
//        center.add(request, withCompletionHandler: nil)
//    }
    
    var hourDictionary = [String: String]()
    var minuteDictionary = [String: String]()
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
//        if habit != nil {
//            hourDictionary[habit.habit] = habit.hour
//            minuteDictionary[habit.habit] = habit.minute
//        }
        
        scheduleNotification(title: "Time to Do Your Tasks!", body: "\(habitNameTextField)", hour: 11, minute: 13)
//        scheduleNotification()
//        
//        let content = UNMutableNotificationContent()
//        content.title = "do stuffs"
//        //        content.subtitle =
//        content.body = habit!.habit!
//        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 11
//        dateComponents.minute = 25
//           dateComponents.weekday = 1 // day of the week ??
////        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let date = Date(timeIntervalSinceNow: 3600)
//        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
//        
//        let identifier = "UYLLocalNotification"
//        let request = UNNotificationRequest(identifier: identifier,
//                                            content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//            if let error = error {
//                print("error")// Something went wrong
//            }
//        })
        
        
    }
    
    
//    func scheduleNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "do stuffs"
////        content.subtitle =
//        content.body = habit!.habit!
//        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 14
//        dateComponents.minute = 00
//     //   dateComponents.weekday = 1 // day of the week ??
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//    }

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

}


