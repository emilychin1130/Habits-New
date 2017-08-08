//
//  CalendarViewController.swift
//  Habits
//
//  Created by Emily Chin on 7/26/17.
//  Copyright © 2017 Emily Chin. All rights reserved.
//

import Foundation
import JTAppleCalendar
import UIKit

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { //add datasource later
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    var selectedDate = ""
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0xB3B3B3)
    let monthColor = UIColor.black
//    let selectedMonthColor = UIColor(colorWithHexValue: <#T##Int#>)
//    let currentDateSelectedMonthColor = UIColor(colorWithHexValue: <#T##Int#>)
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view, typically from a nib.
        setupCalendarView()
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([ Date() ])
    }
    
    func setupCalendarView() {
        //SETUP SPACING
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //SETUP LABELS
        calendarView.visibleDates() {visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)

    }
    
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else {return}
        
//        let todaysDate = Date()
//        if formatter.string(from:todaysDate) == formatter.string(from:cellState.date) {
//            validCell.textLabel.textColor = 008000
//        }
        
        if cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = monthColor
        } else {
            validCell.dateLabel.textColor = outsideMonthColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TABLE VIEW
    
    @IBOutlet weak var habitsDoneTableView: UITableView!

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitsDoneCell") as! HabitsDoneTableViewCell
        
        let row = indexPath.row
        
        let list = CoreDataHelper.retrieveGeneral()
        let general = list[0]
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        let today = "\(year) \(month) \(day)"
        
        cell.habitDoneLabel.text = general.done?[today]?[row]
        
   //     self.habitsDoneTableView.reloadData()
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // arrayOfHabits.count // NUMBER OF HABITS DONE
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: Date())
        return parameters
    }
    

}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    //DISPLAY
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        
        handleCelltextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        validCell.selectedView.isHidden = false
//        
//        let cell1 = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: IndexPath) as! CalendarCell
//        
//        formatter.dateFormat = "yyyy MM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//        
//        var selectedDate = formatter.date(from: cell1.dateLabel.text!)
//        print(selectedDate)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        validCell.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
