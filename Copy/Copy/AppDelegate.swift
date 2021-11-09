//
//  AppDelegate.swift
//  Copy
//
//  Created by Jianzhimao on 2020/7/22.
//  Copyright © 2020 Jianzhimao. All rights reserved.
//

import Cocoa
import Carbon


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let clipBoardWoker = Clipboard()
    var statusBarItem: NSStatusItem!
    var statusBarMenu = NSMenu(title: "Cap")
    let db = DBManger.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.initStatusBar()
        self.addGlobalObsvKeyboardMonitor()
        self.addClipBoardMonitor()
        
    }
    
    
    /// 清除所有menu并且从db读取历史记录
    private func resetDefaultItems () {
        statusBarMenu.removeAllItems()
        statusBarMenu.addItem(withTitle: "退出", action: #selector(_exit), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "清空所有", action: #selector(_clearDB), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "===下面是你的剪切板历史内容,点击即可复制===", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "===同时按下command和option激活===", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "============↓↓↓分隔↓↓↓============", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "         ", action: nil, keyEquivalent: "")
        
        for value in self.db.readHistory().reversed() { // 从数据库取出来逆序一下
            statusBarMenu.addItem(withTitle: value.content!, action: #selector(action), keyEquivalent: "")
        }
    }
    
    
    /// 监听j剪切板
    //            let img = NSImage.init(pasteboard: NSPasteboard.general)
    //            print(img ?? "")
    //            print(content)
    
    
    private func addClipBoardMonitor() {
        clipBoardWoker.startListening()
        clipBoardWoker.onNewCopy { (content) in
            if self.statusBarMenu.items.count >= 6 {
                self.statusBarMenu.insertItem(withTitle: content, action: #selector(self.action), keyEquivalent: "", at: 6)
                _ = self.db.addContent(content: content)
            }
        }
    }
    
    /// 初始化状态栏按钮
    func initStatusBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "🌯"
        statusBarItem.menu = statusBarMenu
        
        self.resetDefaultItems()
    }
    
    @objc func action( sender : NSButton) {
        let title = sender.title

        self.clipBoardWoker.copy(string: title)
    }
    
    @objc func _exit() {
        exit(1)
    }
    
    @objc func _clearDB() {
        if self.db.clearContentTable() {
            self._alert(title: "😝", message: "清除成功~")
            self.initStatusBar()
        }
    }
    
    
    // MARK: - obsv
    /// 监听command和option键同事按下的时候弹出statusBarMenu
    func addGlobalObsvKeyboardMonitor() {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { (event) in
            if event.modifierFlags.contains(.command) && event.modifierFlags.contains(.control) && event.modifierFlags.contains(.option) {
                self.statusBarItem.popUpMenu(self.statusBarMenu)
            }
        }
    }
    

    // MARK: private
    func _alert(title:String? , message:String?) { // 不用在当前App响应
        let alert = NSAlert()
        alert.messageText = title ?? ""
        alert.informativeText = message ?? ""
        alert.addButton(withTitle: "关闭")
        alert.runModal()
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

