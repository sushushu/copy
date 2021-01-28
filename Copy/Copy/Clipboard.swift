//
//  Clipboard.swift
//  copy
//
//  Created by softlipa on 2020/7/4.
//  Copyright © 2020 softlipa. All rights reserved.
//

import AppKit

class Clipboard {
    typealias Hook = (String) -> Void
    
    private let pasteboard = NSPasteboard.general // 公共剪切板
    //  private let pasteboard = NSPasteboard.withUniqueName() // 私有剪切板
    
    private let timerInterval = 1.0
    
    private var changeCount: Int
    private var hooks: [Hook]
    
    init() {
        changeCount = pasteboard.changeCount // changeCount是干嘛的？
        hooks = []
    }
    
    func onNewCopy(_ hook: @escaping Hook) {
        hooks.append(hook)
    }
    
    func startListening() {
        Timer.scheduledTimer(timeInterval: timerInterval,
                             target: self,
                             selector: #selector(checkForChangesInPasteboard),
                             userInfo: nil,
                             repeats: true)
    }
    
    /// 写入剪切板
    func copy(string: String) {
        // 空字符串不管
        if string.count == 0 {
            return;
        }
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(string, forType: NSPasteboard.PasteboardType.string)
    }
    
    @objc
    func checkForChangesInPasteboard() {
        guard pasteboard.changeCount != changeCount else {
            return
        }
        
        changeCount = pasteboard.changeCount
        
        if let img = NSImage.init(pasteboard: pasteboard) {  // 这里已经可以拿到image，可以压缩存到数据库。多文件复制，参考：https://blog.csdn.net/u014600626/article/details/53635192
            for hook in hooks {
                hook("这是图片 + \(img.className) ")
            }
            return
        }
        // 网页复制的图片:  WebURLsWithTitlesPboardType 、 com.apple.webarchive 、 Apple Web Archive pasteboard type
        if let lastItem = pasteboard.string(forType: NSPasteboard.PasteboardType.string) {
            for hook in hooks {
                hook(lastItem)
            }
        }
    }
}
