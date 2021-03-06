//
//  coreDataHelper.swift
//  Habits
//
//  Created by Emily Chin on 7/20/17.
//  Copyright © 2017 Emily Chin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import UserNotifications

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext

    static func newHabit() -> Habit {
        let habit = NSEntityDescription.insertNewObject(forEntityName: "Habit", into: managedContext) as! Habit
        return habit
    }
    
    static func saveHabit() {
        do {
            try managedContext.save()
        } catch let error as NSError {
        }
    }
    
    static func delete(habit: Habit) {
        managedContext.delete(habit)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.habit!])
        saveHabit()
    }
    
    static func retrieveHabits() -> [Habit] {
        let fetchRequest = NSFetchRequest<Habit>(entityName: "Habit")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
        }
        return []
    }
    
    static func newGeneral() -> General {
        let general = NSEntityDescription.insertNewObject(forEntityName: "General", into: managedContext) as! General
        return general
    }
    
    static func saveGeneral() {
        do {
            try managedContext.save()
        } catch let error as NSError {
        }
    }
    
    static func retrieveGeneral() -> [General] {
        let fetchRequest = NSFetchRequest<General>(entityName: "General")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
        }
        return []
    }
}
