//
//  BaseModel.swift
//  Copy
//
//  Created by Jianzhimao on 2020/7/23.
//  Copyright © 2020 Jianzhimao. All rights reserved.
//

import Foundation
import WCDBSwift

// 声明的字段必须要和 enum CodingKeys下面的case字段一致
// 枚举列举每一个需要定义的字段。
// 对于变量名与表的字段名不一样的情况，可以使用别名进行映射，如 case identifier = "id"
// 对于变量名与 SQLite 的保留关键字冲突的字段，同样可以使用别名进行映射，如 offset 是 SQLite 的关键字
struct BaseModel: TableCodable {
    var identifier: Int = 0
    var description: String? = nil
    var path: String? = nil
    var content: String? = nil // 复制的内容
    var formApp: String? = nil // 从哪个App复制的
    var timeStamp: Int? = nil
    var type: String? = nil // 类型
    var isEncrypt: Bool = false
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = BaseModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case identifier
        case description
        case path
        case content
        case formApp
        case timeStamp
        case type
        case isEncrypt
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true , isAutoIncrement : true)
//                description: ColumnConstraintBinding(isNotNull: false, defaultTo: "defaultDescription"),
            ]
        }
    }
    
    var isAutoIncrement: Bool = true // 用于定义是否使用自增的方式插入
    var lastInsertedRowID: Int64 = 0 // 用于获取自增插入后的主键值
}

