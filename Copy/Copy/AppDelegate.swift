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
    let notificationNameOfKeyBoradString = " NotificationCenter.default_cmd_option" // 监听快捷键响应key
    var statusBarItem: NSStatusItem!
    var statusBarMenu = NSMenu(title: "Cap")
    let db = DBManger.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.initStatusBar()
        self.addGlobalObsvKeyboardMonitor()
        self.addShortcuKeyMonitor()
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
    
    /// 监听快捷键响应
    private func addShortcuKeyMonitor() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationNameOfKeyBoradString), object: nil, queue: nil) { (noti) in
            self.statusBarItem.popUpMenu(self.statusBarMenu)
        }
    }
    
    /// 监听j剪切板
    private func addClipBoardMonitor() {
        clipBoardWoker.startListening()
        clipBoardWoker.onNewCopy { (content) in
            //            let img = NSImage.init(pasteboard: NSPasteboard.general)
            //            print(img ?? "")
            //            print(content)
            
            // 总是插入到最前面
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
//            self._alert(title: "😝", message: "清除成功~")
            self.initStatusBar()
        }
    }
    
    // MARK: - obsv
    func addGlobalObsvKeyboardMonitor() {
        
        //  监听鼠标移动 ， 激活状态按下cmd按钮
        //        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask(rawValue: NSEvent.EventTypeMask.RawValue(kFSEventStreamEventFlagRootChanged))) { (event) in
        //            print(event)
        //        }

        var cmd = false , opt = false
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { (event) in
            //            let flags = event.modifierFlags
//            print(event)
            
            switch event.keyCode {
            case 55 :
                cmd = true
                break
            case 58 :
                opt = true
                break
                
            default : break
                
            }
            
            
            if cmd && opt {
                print("嗯 同时按下了cmd 和 option！ ")
                cmd = false
                opt = false
                
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: self.notificationNameOfKeyBoradString)))
            }
        }
    }
    

    // MARK: private
    func _alert(title:String? , message:String?) {
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

