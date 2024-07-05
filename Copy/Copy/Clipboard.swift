//
//  Clipboard.swift
//  copy
//
//  Created by softlipa on 2020/7/4.
//  Copyright © 2020 softlipa. All rights reserved.
//

import AppKit

/// Clipboard class to manage and listen to clipboard changes
class Clipboard {
    typealias Hook = (String) -> Void
    
    private let pasteboard = NSPasteboard.general // 公共剪切板 ， 私有剪切板 NSPasteboard.withUniqueName()
    private let timerInterval: TimeInterval = 1.0 // Time interval for checking the pasteboard
    private var changeCount: Int // Tracks the change count of pasteboard
    private var hooks: [Hook] // Array of hooks to be called on new copy
    
    /// Initializes the Clipboard instance
    init() {
        self.changeCount = pasteboard.changeCount
        self.hooks = []
    }
    
    /// Adds a new hook to be called on new copy
     /// - Parameter hook: The closure to be called with the copied string
    func onNewCopy(_ hook: @escaping Hook) {
        hooks.append(hook)
    }
    
    /// Starts listening to the pasteboard for changes
    func startListening() {
        Timer.scheduledTimer(timeInterval: timerInterval,
                             target: self,
                             selector: #selector(checkPasteboard),
                             userInfo: nil,
                             repeats: true)
    }
    
    /// Copies the given string to the pasteboard
    /// - Parameter string: The string to be copied to the pasteboard
    func copy(string: String) {
        guard !string.isEmpty else { return }
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(string, forType: .string)
    }
    
    // 如果是网页复制的图片类型一般是这几种:  WebURLsWithTitlesPboardType 、 com.apple.webarchive 、 Apple Web Archive pasteboard type
    /// Checks the pasteboard for new content
    @objc func checkPasteboard() {
        // Check if the pasteboard content has changed
        guard pasteboard.changeCount != changeCount else { return }
        
        // Update the change count
        changeCount = pasteboard.changeCount
        
        // Check if there is an image in the pasteboard
        // TODO: 这里已经可以拿到image，可以压缩存到数据库。多文件复制，参考：https://blog.csdn.net/u014600626/article/details/53635192
        if let img = NSImage(pasteboard: pasteboard) {
            for hook in hooks {
                hook("这是图片 + \(img.className)")
            }
        } else if let lastItem = pasteboard.string(forType: .string) {
            // Check if there is a string in the pasteboard
            for hook in hooks {
                hook(lastItem)
            }
        }
    }
}
