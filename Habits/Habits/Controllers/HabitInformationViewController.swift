//
//  HabitInformationViewController.swift
//  Habits
//
//  Created by Emily Chin on 7/17/17.
//  Copyright © 2017 Emily Chin. All rights reserved.
//

import Foundation
import UIKit

class HabitInformationViewController: UIViewController {
    @IBOutlet weak var habitNameTextField: UITextField!
    
    var habit: Habit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            let habit = self.habit ?? CoreDataHelper.newHabit()
            habit.habit = habitNameTextField.text ?? ""
         //   habit.days =
            CoreDataHelper.saveHabit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let habit = habit {
            habitNameTextField.text = habit.habit
//            noteContentTextView.text = note.content
        } else {
            habitNameTextField.text = ""
//            noteContentTextView.text = ""
        }
    }
}
