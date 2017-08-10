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

class HabitInformationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var habitNameTextField: UITextField!

    @IBOutlet weak var notification: UISwitch!
    
    var habit: Habit?
    var chosenHour: String? = "1"
    var chosenMinute: String? = "00"
    var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if habit?.habit != nil {
            isEdit = true
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        //NOTIFICATION PERMISSION
        
        initNotificationSetupCheck()

        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector("doneButtonAction"))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.habitNameTextField.inputAccessoryView = toolbar
    }
    
    func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let habits = CoreDataHelper.retrieveHabits()
            var listOfHabits = [String]()
            for habit in habits {
                listOfHabits.append(habit.habit!)
            }
            if (habitNameTextField.text?.isEmpty)! {
                let alert = UIAlertController(title: "", message: "You forgot to add a name!" , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil) } ) )
                self.present(alert, animated: true, completion: nil)
            } else
            if isEdit == false {
                if listOfHabits.contains(habitNameTextField.text!) {
                let alert = UIAlertController(title: "", message: "You already have a habit called \(String(describing: habitNameTextField.text!)). Please rename!" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil) } ) )
                self.present(alert, animated: true, completion: nil)
                } else {
                    
                    let habit = self.habit ?? CoreDataHelper.newHabit()
                    if habit.habit != nil {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.habit!])
                    }
                    habit.notification = notification.isOn
                    if notification.isOn == true {
                        scheduleAll()
                    }
                    habit.habit = habitNameTextField.text ?? ""
                    habit.hour = chosenHour ?? ""
                    habit.minute = chosenMinute ?? ""
                    CoreDataHelper.saveHabit()
                }

            } else {

            let habit = self.habit ?? CoreDataHelper.newHabit()
            if habit.habit != nil {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.habit!])
            }
            habit.notification = notification.isOn
            if notification.isOn == true {
                scheduleAll()
            }
            habit.habit = habitNameTextField.text ?? ""
            habit.hour = chosenHour ?? ""
            habit.minute = chosenMinute ?? ""
            CoreDataHelper.saveHabit()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let habit = habit {
            habitNameTextField.text = habit.habit
            chosenHour = habit.hour
            chosenMinute = habit.minute
            notification.isOn = habit.notification
            
            if notification.isOn == true {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat =  "HH:mm"
                let date = dateFormatter.date(from: "\(habit.hour!):\(habit.minute!)")
                datePicker.date = date!
            }

        } else {
            habitNameTextField.text = ""
            chosenHour = ""
            chosenMinute = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.habitNameTextField.resignFirstResponder()
        return true
    }
    
    // NOTIFICATION PERMISSION
 
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
    
    // PICKER
    
    
    func datePickerAction() {
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        
        chosenHour = "\(hour)"
        chosenMinute = "\(minute)"
    }
    
    // NOTIFICATION
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        scheduleAll()
        
    }

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
    }
    
    func scheduleNotification(title: String, body: String, hour: Int, minute: Int, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // SET EACH TIME THING UP
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    func scheduleAll() {
        
        datePickerAction()
        
        if habitNameTextField.text != nil && chosenHour != nil && chosenMinute != nil {
            scheduleNotification(title: "Time to do Your Tasks!", body: habitNameTextField.text!, hour: Int(chosenHour!)!, minute: Int(chosenMinute!)!, identifier: habitNameTextField.text!)
        }
    }
}


