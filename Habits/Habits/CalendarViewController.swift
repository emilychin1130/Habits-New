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
    var arrayOfHabits = [String]()
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0xB3B3B3)
    let monthColor = UIColor.white
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        // Do any additional setup after loading the view, typically from a nib.
        setupCalendarView()
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([ Date() ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.habitsDoneTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.habitsDoneTableView.reloadData()
    }
    
    // DEFINE ARRAY
    
    func defineArray(array: [String]) {
        arrayOfHabits = array
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
        
        if cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = monthColor
        } else {
            validCell.dateLabel.textColor = outsideMonthColor
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // TABLE VIEW
    
    @IBOutlet weak var habitsDoneTableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitsDoneCell") as! HabitsDoneTableViewCell
        
        let row = indexPath.row
        
        cell.habitDoneLabel.text = arrayOfHabits[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfHabits.count 
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

        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let selectedDate = formatter.string(from: date)
        
        let list = CoreDataHelper.retrieveGeneral()
        
        let general = list[0]
        
        if general.done?[selectedDate] != nil {
        
            defineArray(array: (general.done?[selectedDate]!)!)
            
        } else {
            defineArray(array: [  ])
        }
        
        self.habitsDoneTableView.reloadData()
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
