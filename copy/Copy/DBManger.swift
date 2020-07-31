//
//  DBManger.swift
//  copy
//
//  Created by Jianzhimao on 2020/7/21.
//  Copyright © 2020 softlipa. All rights reserved.
//

import Foundation
import WCDBSwift


class DBManger {
    var db : Database! = nil
    static let shared = DBManger.init()
    
    private let dbName = "home.db"
    private let userTable = "user"
    private let contentTable = "content" // content表
    
    private let mainPath = NSHomeDirectory() // 沙盒目录
    private let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    private let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    private let caches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!

    // MARK: - init
    private init() {
        let path = (self.documents) + "/" + (self.dbName)
        
        // 延迟初始化是 WCDB Swift 的原则之一，绝大部分数据只会在需要用到时才创建并初始化。数据库的打开就是其中一个例子。
        // 数据库会在第一次进行操作时，自动打开并初始化。开发者不需要手动调用。
        print("DBManger init ing...")
        self.db = Database.init(withPath: (self.documents) + "/" + (self.dbName))
        print("Database init,db path is:  \(path)")
        
        self.createTables()
    }
    
    private func createTables () {
        do {
            print("create contentTable ing...")
            try self.db?.create(table: self.contentTable, of: BaseModel.self)
            print("create contentTable success!")
        } catch {
            print("create table invalid.")
        }
    }

    
    // MARK: - R
    public func readHistory() -> Array<BaseModel> {
        var ret = Array<BaseModel>()
        do {
            ret = try self.db.getObjects(fromTable: self.contentTable)
//            ret = try self.db.getObject(on: nil, fromTable: self.contentTable, where: contentTable, orderBy: <#T##[OrderBy]?#>, offset: <#T##Offset?#>)
            print("read objects from contentTable success")
        } catch {
            print("error")
        }
        
        return ret
    }
    
    private func readObjtectFromTable(tableName : String) -> Bool {
        if tableName.count == 0 {
            print("tableName invalid")
            return false
        }
        
        return false 
    }
    
    
    // MARK: - C
    
    
    // MARK: - U
    public func addContent(content:String) -> Bool {
        var ret = true
        do {
            var model = BaseModel()
            model.content = content
            model.timeStamp = Utils.init().getNowTimeStampMillisecond()
            model.type = "string"
            model.description = "null"
            try self.db.insert(objects: model, intoTable: self.contentTable)
            print("addContent success :  \(content)")
        } catch {
            print("addContent error")
            ret = false
        }
        
        return ret
    }
    
    // MARK: - D
    public func clearContentTable() -> Bool {
        var ret = true
        do {
            try self.db.delete(fromTable: self.contentTable)
            print("delete contentTable success")
        } catch {
            print("clear ContentTable error")
            ret = false
        }
  
        return ret
    }
    
    private func deleteObjtectFromTable(tableName : String) -> Bool {
        if tableName.count == 0 {
            print("tableName invalid")
            return false
        }

        return true
    }
}
