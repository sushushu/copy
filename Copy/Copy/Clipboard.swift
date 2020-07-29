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
        
        // 网页复制的图片:  WebURLsWithTitlesPboardType 、 com.apple.webarchive 、 Apple Web Archive pasteboard type
        if let lastItem = pasteboard.string(forType: NSPasteboard.PasteboardType.string) {
            for hook in hooks {
                hook(lastItem)
            }
        }
        
//        if let lastItem11 = pasteboard.data(forType: NSPasteboard.PasteboardType.string) {
//            print(lastItem11)
//        }
        changeCount = pasteboard.changeCount
    }
    
}