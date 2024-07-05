//
//  Utils.swift
//  Copy
//
//  Created by Jianzhimao on 2020/7/23.
//  Copyright © 2020 Jianzhimao. All rights reserved.
//

import Foundation

struct Utils {
    ///  获取当前长整型时间戳
    func getCurrentTimeStamp() -> Int {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss SSS"//设置时间格式；hh——>12小时制， HH———>24小时制
        
        //设置时区
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        formatter.timeZone = timeZone
        let dateNow = Date()//当前时间
        let ret = Int(dateNow.timeIntervalSince1970) * 1000
        return ret
    }
    
    //    func _alert(title:String? , message:String?) { // TODO: 不用在当前App响应
    //        let alert = NSAlert()
    //        alert.messageText = title ?? ""
    //        alert.informativeText = message ?? ""
    //        alert.addButton(withTitle: "关闭")
    //        if let window = window {
    //        alert.beginSheetModal(for: window., completionHandler: nil)
    //        } else {
    //            alert.runModal()
    //        }
    //    }
}


