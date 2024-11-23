//
//  CalendarViewController.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 22.11.24.
//

import UIKit
import FSCalendar
import Combine

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: FSCalendar!
    private let viewModel = CalendarViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.appearance.imageOffset.y = -20
        calendarView.rowHeight = 100
        calendarView.appearance.titleOffset = .init(x: 0, y: 20)
        calendarView.headerHeight = 30
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.addShadow()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func subscribe() {
        viewModel.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self else { return }
                self.calendarView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        for record in viewModel.records {
            if record.date?.stripTime() == date {
                return UIImage(named: "smallEmoji\((record.emoji ?? 0) + 1)")
            }
        }
        if date <= Date().stripTime() {
            return .nonRecordedDay
        } else {
            return .defaultDay
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if let record = viewModel.records.first(where: { $0.date?.stripTime() == date }) {
            RecordFormViewModel.shared.record = record
        } else {
            RecordFormViewModel.shared.record.date = date.settingCurrentTime()
        }
        self.pushViewController(RecordFormViewController.self)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date <= Date().stripTime()
    }
}
