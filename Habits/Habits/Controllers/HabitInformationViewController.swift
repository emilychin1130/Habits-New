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
            scheduleAll()
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
    
    @IBOutlet weak var ampmSelector: UISegmentedControl!
    
    func rightTime(time: Int) -> Int {
        switch ampmSelector.selectedSegmentIndex {
        case 0:
            if time != 12 {
                return time
            } else {
                return (time + 12)
            }
        case 1:
            if time != 12 {
                return (time + 12)
            } else {
                return time
            }
        default:
            return time
        }
    }
    
    // NOTIFICATION
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        scheduleAll()
        
    }
    
    
//    }

    // TIME DICTIONARIES
    
    var hourDictionary = [String:Int]()
    var minuteDictionary = [String:Int]()
    
    func addToDictionaries() {
        if chosenHour != nil {
            hourDictionary["\(habitNameTextField.text)"] = Int(chosenHour!)
        }
        if chosenMinute != nil {
            minuteDictionary["\(habitNameTextField.text)"] = Int(chosenMinute!)
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
//
//    func scheduleAll() {
//        addToDictionaries()
//        if let name = habitNameTextField.text {
//            scheduleNotification(title: "Time to do Your Tasks!", body: name, hour: hourDictionary[name]!, minute: minuteDictionary[name]!)
//        }
//    }

    // SET EACH TIME THING UP
    
    func scheduleAll() {
        if habitNameTextField.text != nil && chosenHour != nil && chosenMinute != nil {
            scheduleNotification(title: "Time to do Your Tasks!", body: habitNameTextField.text!, hour: rightTime(time: Int(chosenHour!)!), minute: Int(chosenMinute!)!)
        } else { print("no") }
        print (rightTime(time: Int(chosenHour!)!))
    }
}


