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
    //var hour: Habit?
    //var minute: Habit?
    var chosenHour: String?
    
    var hourPickerData = ["1","2","3","4","5","6","7"]
    var minutePickerData = ["1","2","3"]
    
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
            //let hour = self.habit?.hour ?? CoreDataHelper.newHabit()
            //let minute = self.habit?.minute ?? CoreDataHelper.newHabit()
            habit.habit = habitNameTextField.text ?? ""
         //   habit.days =
            CoreDataHelper.saveHabit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let habit = habit {
            habit.hour = chosenHour
            habitNameTextField.text = habit.hour
                //habit.habit
            //habit.hour = "5"
            habit.minute = "57"
            
//            noteContentTextView.text = note.content
        } else {
            habitNameTextField.text = ""
//            noteContentTextView.text = ""
        }
    }
    
    // ALARM
    @IBOutlet weak var hourPicker: UIPickerView!
    @IBOutlet weak var minutePicker: UIPickerView!
    
    //var hourPickerData: [Int] = [Int]()
   // var minutePickerData: [Int] = [Int]()
    
    // PICKER
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hourPicker {
            return hourPickerData.count}
        else if pickerView == minutePicker {return minutePickerData.count}
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == hourPicker {
        return hourPickerData[row]}
        else if pickerView == minutePicker{
            return minutePickerData[row]
        }
        return "1"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //minute = minutePickerData[row]
        chosenHour = hourPickerData[row]
        print(hourPickerData[row])
    }
    
    
}


