//
//  DBManger.swift
//  copy
//
//  Created by Jianzhimao on 2020/7/21.
//  Copyright © 2020 softlipa. All rights reserved.
//

import Foundation
import WCDBSwift


class DBManager {
    // Use singleton pattern
    static let shared = DBManager()
    
    // DB config
    var db : Database!
    private let dbName = "Kao.db"
    private let contentTable = "content" // content表
    
    
    // MARK: - init
    private init() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let dbPath = "\(documentsPath)/\(dbName)"
        
        print("DBManager initializing...")
        self.db = Database(at: dbPath)
        print("Database initialized at path: \(dbPath)")
        
        self.createTables()
    }
    
    private func createTables () {
        do {
            print("Creating contentTable ing...")
            try self.db?.create(table: contentTable, of: BaseModel.self)
            print("Created contentTable successfully!")
        } catch {
            print("Failed to create table: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Read
    public func readHistory() -> [BaseModel] {
        do {
            let objects: [BaseModel] = try self.db.getObjects(fromTable: contentTable)
            print("Successfully read objects from contentTable")
            return objects
        } catch {
            print("Failed to read from contentTable: \(error.localizedDescription)")
            return []
        }
    }
    public func getDBFileSize() -> String {
        do {
            let fileSize = try self.db.getFilesSize()
            print("Database file size: \(fileSize) bytes")
            
            let fileSizeInMB = Double(fileSize) / (1024 * 1024)
            return String.init(format: "%.3lf MB", fileSizeInMB)
        } catch {
            print("Failed to get database file size: \(error.localizedDescription)")
            return error.localizedDescription
        }
    }

    // MARK: - Add
    public func addContent(content: String) -> Bool {
        do {
            var model = BaseModel()
            model.content = content
            model.timeStamp = Utils().getCurrentTimeStamp()
            model.type = "string"
            model.description = "null" // Temporarily set this value to null
            try self.db.insert(model, intoTable: contentTable)
            print("Successfully added content: \(content)")
            return true
        } catch {
            print("Failed to add content: \(error.localizedDescription)")
            return false
        }
    }
    
    
    // MARK: - Clear
    public func clearContentTable() -> Bool {
        do {
            try self.db.delete(fromTable: contentTable)
            print("Successfully cleared contentTable")
            return true
        } catch {
            print("Failed to clear contentTable: \(error.localizedDescription)")
            return false
        }
    }
}
