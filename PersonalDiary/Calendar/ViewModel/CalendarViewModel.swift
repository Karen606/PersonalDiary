//
//  CalendarViewModel.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 24.11.24.
//

import Foundation

class CalendarViewModel {
    static let shared = CalendarViewModel()
    @Published var records: [RecordModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchRecords { [weak self] records, _ in
            guard let self = self else { return }
            self.records = records
        }
    }
}
