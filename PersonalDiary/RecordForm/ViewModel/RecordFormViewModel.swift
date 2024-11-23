//
//  RecordFormViewModel.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 24.11.24.
//

import Foundation

class RecordFormViewModel {
    static let shared = RecordFormViewModel()
    @Published var record = RecordModel(id: UUID(), date: Date())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveRecord(recordModel: record, completion: completion)
    }
    
    func clear() {
        record = RecordModel(id: UUID(), date: Date())
    }
}
