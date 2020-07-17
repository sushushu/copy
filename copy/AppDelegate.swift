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
    let notificationNameOfKeyBoradString = " NotificationCenter.default_cmd_option"
    var statusBarItem: NSStatusItem!
    var statusBarMenu = NSMenu(title: "Cap")
    var count = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 设置状态栏图标
        NSApp.applicationIconImage = NSImage.init(named: "smile")

        self.initStatusBar()
        self.addGlobalObsvKeyboardMonitor()
        
        c.startListening()
        c.onNewCopy { (content) in
//            let img = NSImage.init(pasteboard: NSPasteboard.general)
//            print(img ?? "")
//            print(content)
            
            self.statusBarMenu.addItem(withTitle: content, action: #selector(self.action), keyEquivalent: "")
            
        }
    }

    /// 初始化状态栏按钮
    func initStatusBar() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "🌯"
        
        statusBarItem.menu = statusBarMenu
        statusBarMenu.addItem(withTitle: "退出", action: #selector(_exit), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "下面是你的剪切板历史内容,点击即可复制↓↓↓", action: #selector(action), keyEquivalent: "Escape")
        statusBarMenu.addItem(withTitle: "=================================", action: #selector(action), keyEquivalent: "Down")
        statusBarMenu.addItem(withTitle: "===============分割线=============", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "=================================", action: #selector(action), keyEquivalent: "")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationNameOfKeyBoradString), object: nil, queue: nil) { (noti) in
            print(noti)
        }
    }
    
    @objc func action( sender : NSButton) {
        count += 1
            
        let title = sender.title
        
//        statusBarMenu.addItem(withTitle: "\(count)", action: #selector(action), keyEquivalent: "")
//        self._alert(title: "111", message: nil)
        self.c.copy(string: title)
        print(sender.title)
    }
    
    @objc func _exit() {
        exit(1)
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    // MARK: - obsv
    func addGlobalObsvKeyboardMonitor() {
        
        //  监听鼠标移动 ， 激活状态按下cmd按钮
//        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask(rawValue: NSEvent.EventTypeMask.RawValue(kFSEventStreamEventFlagRootChanged))) { (event) in
//            print(event)
//        }
//
        
//        public static var capsLock: NSEvent.ModifierFlags { get } // Set if Caps Lock key is pressed.
//
//        public static var shift: NSEvent.ModifierFlags { get } // Set if Shift key is pressed.
//
//        public static var control: NSEvent.ModifierFlags { get } // Set if Control key is pressed.
//
//        public static var option: NSEvent.ModifierFlags { get } // Set if Option or Alternate key is pressed.
//
//        public static var command: NSEvent.ModifierFlags { get } // Set if Command key is pressed.
//
//        public static var numericPad: NSEvent.ModifierFlags { get } // Set if any key in the numeric keypad is pressed.
//
//        public static var help: NSEvent.ModifierFlags { get } // Set if the Help key is pressed.
//
//        public static var function: NSEvent.ModifierFlags { get } // Set if any function key is pressed.
//
//
//        // Used to retrieve only the device-independent modifier flags, allowing applications to mask off the device-dependent modifier flags, including event coalescing information.
//        public static var deviceIndependentFlagsMask: NSEvent.ModifierFlags { get }
        
       
        var cmd = false , opt = false
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { (event) in
            //            let flags = event.modifierFlags
            print(event)
            
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

