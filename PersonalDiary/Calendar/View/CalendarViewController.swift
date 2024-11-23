//
//  CalendarViewController.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 22.11.24.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.appearance.imageOffset.y = -20
        calendarView.rowHeight = 100
        calendarView.appearance.titleOffset = .init(x: 0, y: 20)
        calendarView.headerHeight = 30
        calendarView.delegate = self
        calendarView.dataSource = self
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        return .emoji
    }
}
