//
//  AppDelegate.swift
//  copy
//
//  Created by softlipa on 2020/7/4.
//  Copyright © 2020 softlipa. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let c = Clipboard()
    
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // 设置状态栏图标
        NSApp.applicationIconImage = NSImage.init(named: "smile")

        self.initStatusBar()
        self.obsvKeyboard()
        
        c.startListening()
        c.onNewCopy { (content) in
            let img = NSImage.init(pasteboard: NSPasteboard.general)
            print(img ?? "")
            print(content)
        }
        
    }

    /// 初始化状态栏按钮
    func initStatusBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "🌯"
        
        let statusBarMenu = NSMenu(title: "Cap")
        statusBarItem.menu = statusBarMenu

        statusBarMenu.addItem(withTitle: "111", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "222", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "333", action: #selector(action), keyEquivalent: "")
    }
    
    @objc func action( sender : NSButton) {
        print("1111")
        
//        self._alert(title: "111", message: nil)
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    // MARK: - obsv
    func obsvKeyboard() {
        
        //  监听鼠标移动 ， 激活状态按下cmd按钮
//        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask(rawValue: NSEvent.EventTypeMask.RawValue(kFSEventStreamEventFlagRootChanged))) { (event) in
//            
//            print(event)
//        }
//        
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { (event) in
            let flags = event.modifierFlags
            if flags == .command {
                
            }
            
            
            print(event)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NOTI_HOTKEY"), object: nil, queue: nil) { (noti) in
            print(noti)
        }
    }
    
    // MARK: - NSMenuDelegate
    
    
    
    // MARK: private
    func _alert(title:String? , message:String?) {
        let alert = NSAlert()
        alert.messageText = title ?? ""
        alert.informativeText = message ?? ""
        alert.addButton(withTitle: "关闭")
        alert.window.titlebarAppearsTransparent = true
        alert.runModal()
    }
    
}

