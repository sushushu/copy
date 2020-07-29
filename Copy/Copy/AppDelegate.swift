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
    
    let c = Clipboard()
    let notificationNameOfKeyBoradString = " NotificationCenter.default_cmd_option"
    var statusBarItem: NSStatusItem!
    var statusBarMenu = NSMenu(title: "Cap")
    let db = DBManger.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 设置状态栏图标
        NSApp.applicationIconImage = NSImage.init(named: "icons-96")
        
        self.initStatusBar()
        self.addGlobalObsvKeyboardMonitor()
        
        c.startListening()
        c.onNewCopy { (content) in
            //            let img = NSImage.init(pasteboard: NSPasteboard.general)
            //            print(img ?? "")
            //            print(content)
            
            self.statusBarMenu.addItem(withTitle: content, action: #selector(self.action), keyEquivalent: "")
            _ = self.db.addContent(content: content)
        }
    }
    

    /// 初始化状态栏按钮
    func initStatusBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "🌯"
        
        statusBarItem.menu = statusBarMenu
        statusBarMenu.addItem(withTitle: "退出", action: #selector(_exit), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "清空所有", action: #selector(_clearDB), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "===下面是你的剪切板历史内容,点击即可复制===", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "===同时按下command和option激活===", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "===============分割线=============", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "=================================", action: #selector(action), keyEquivalent: "")
        
        for value in self.db.readHistory() {
            statusBarMenu.addItem(withTitle: value.content!, action: #selector(action), keyEquivalent: "")
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationNameOfKeyBoradString), object: nil, queue: nil) { (noti) in
            print(noti)
            self.statusBarItem.popUpMenu(self.statusBarMenu)
        }
    }
    
    @objc func action( sender : NSButton) {
        let title = sender.title

        self.c.copy(string: title)
        print(sender.title)
    }
    
    @objc func _exit() {
        exit(1)
    }
    
    @objc func _clearDB() {
        if self.db.clearContentTable() {
            self._alert(title: "😝", message: "清除成功~")
            statusBarMenu.removeAllItems()
            statusBarMenu.addItem(withTitle: "退出", action: #selector(_exit), keyEquivalent: "")
            statusBarMenu.addItem(withTitle: "清空所有", action: #selector(_clearDB), keyEquivalent: "")
            statusBarMenu.addItem(withTitle: "===下面是你的剪切板历史内容,点击即可复制===", action: #selector(action), keyEquivalent: "")
            statusBarMenu.addItem(withTitle: "===同时按下command和option激活===", action: #selector(action), keyEquivalent: "")
            statusBarMenu.addItem(withTitle: "===============分割线=============", action: #selector(action), keyEquivalent: "")
            statusBarMenu.addItem(withTitle: "=================================", action: #selector(action), keyEquivalent: "")
            for value in self.db.readHistory() {
                statusBarMenu.addItem(withTitle: value.content!, action: #selector(action), keyEquivalent: "")
            }
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
        alert.window.titlebarAppearsTransparent = true
        alert.runModal()
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

