//
//  CoreDataManager.swift
//  PersonalDiary
//
//  Created by Karen Khachatryan on 24.11.24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersonalDiary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveRecord(recordModel: RecordModel, completion: @escaping (Error?) -> Void) {
        let id = recordModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let record: Record
                
                if let existingRecord = results.first {
                    record = existingRecord
                } else {
                    record = Record(context: backgroundContext)
                    record.id = id
                }
                record.date = recordModel.date
                if let emoji = recordModel.emoji {
                    record.emoji = Int32(emoji)
                }
                record.info = recordModel.info
                record.photo = recordModel.photo
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchRecords(completion: @escaping ([RecordModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var recordsModel: [RecordModel] = []
                for result in results {
                    let recordModel = RecordModel(id: result.id, date: result.date, emoji: Int(result.emoji), info: result.info, photo: result.photo)
                    recordsModel.append(recordModel)
                }
                completion(recordsModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
}

