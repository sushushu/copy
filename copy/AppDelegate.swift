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
    var statusBarMenu = NSMenu(title: "Cap")
    var count = 0
    
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
        
        statusBarItem.menu = statusBarMenu
        statusBarMenu.addItem(withTitle: "111", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "222", action: #selector(action), keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "333", action: #selector(action), keyEquivalent: "")
    }
    
    @objc func action( sender : NSButton) {
        print("1111")
        
        count += 1
            
        statusBarMenu.addItem(withTitle: "\(count)", action: #selector(action), keyEquivalent: "")
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
            
            
            
            switch event.keyCode {
            case 55 :
                cmd = true
                break
                

            case 58 :
                opt = true
                break
                
            default : break
            }
            
            
//            switch flags {
//
//            case .command:
//                print(keyCodeMask)
//
//                fallthrough // 使用了fallthrough 语句，则会继续执行之后的 case 或 default 语句
//
//            case .shift:
//                print(keyCodeMask)
//                fallthrough
//
//            case .option:
//                print(keyCodeMask)
//
//                fallthrough
//
//            case .function:
//                print(keyCodeMask)
//                fallthrough
//
//            case .deviceIndependentFlagsMask:
//                print(keyCodeMask)
//                fallthrough
//
//            default :
//                print(keyCodeMask)
////                break /* 可选 */11
//            }
            
            if cmd && opt {
                print("嗯 同时按下了cmd 和 option！ ")
                cmd = false
                opt = false
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

