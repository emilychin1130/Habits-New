//
//  HabitInformationViewController.swift
//  Habits
//
//  Created by Emily Chin on 7/17/17.
//  Copyright © 2017 Emily Chin. All rights reserved.
//

import Foundation
import UIKit

class HabitInformationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var habitNameTextField: UITextField!
    
    var habit: Habit?
//    var hour: Habit?
//    var minute: Habit?
    var chosenHour: String? = "1"
    var chosenMinute: String? = "00"
    
    var hourPickerData = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var minutePickerData = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hourPicker.delegate = self
        self.hourPicker.dataSource = self
        
        hourPicker.tag = 0
        minutePicker.tag = 1
        
        self.minutePicker.delegate = self
        self.minutePicker.dataSource = self
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let habit = self.habit ?? CoreDataHelper.newHabit()
            //let hour = chosenHour
            //            let hour = self.hour ?? CoreDataHelper.newHabit()
            //            let minute = self.minute ?? CoreDataHelper.newHabit()
            habit.habit = habitNameTextField.text ?? ""
            habit.hour = chosenHour ?? ""
            habit.minute = chosenMinute ?? ""
            //   habit.days =
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
            //habit.hour = "5"
            //habit.minute = "57"
            
            //            noteContentTextView.text = note.content
        } else {
            habitNameTextField.text = ""
            chosenHour = ""
            chosenMinute = ""
            //            noteContentTextView.text = ""
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
        //minute = minutePickerData[row]
        //chosenHour = hourPickerData[row]
        //print(hourPickerData[row])
        if pickerView == hourPicker {
            chosenHour = hourPickerData[row]
        }
        else if pickerView == minutePicker {
            chosenMinute = minutePickerData[row]
        }
        displaySelectedTime.text = "\(chosenHour!)  :  \(chosenMinute!)"
    }
    
    
}


