//
//  AppDelegate.swift
//  Copy
//
//  Created by Jianzhimao on 2020/7/22.
//  Copyright © 2020 Jianzhimao. All rights reserved.
//

import Cocoa
import Carbon
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    let clipboardWorker = Clipboard()
    var statusBarItem: NSStatusItem!
    var statusBarMenu = NSMenu()
    let dbManger = DBManager.shared
    var infoItem = NSMenuItem()
    var launchAtLoginItem = NSMenuItem()
    private let fixedMenuItemCount = 10 // HadeCode，用于固定菜单项的数量
    private var isMenuVisible: Bool = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Application did finish launching")
        initStatusBar()
        addGlobalKeyboardMonitor()
        addClipBoardMonitor()
    }
    
    /// 清除所有menu并且从db读取历史记录
    private func resetDefaultItems() {
        print("Resetting default items...")
        statusBarMenu.removeAllItems()
        addFixedMenuItems()
        
        for value in self.dbManger.readHistory().reversed() { // 从数据库取出来逆序一下
            statusBarMenu.addItem(withTitle: value.content ?? " ", action: #selector(copyToClipboard), keyEquivalent: "")
        }
    }
    
    private func addFixedMenuItems() {
        print("Adding fixed menu items...")
        statusBarMenu.delegate = self
        
        statusBarMenu.addItem(withTitle: "❗️ 退出应用", action:  #selector(exitApp), keyEquivalent: "q")
        statusBarMenu.addItem(withTitle: "🗑 清空所有内容", action:  #selector(clearAll), keyEquivalent: "k")

        launchAtLoginItem = NSMenuItem(title: "登录时启动")
        launchAtLoginItem.addAction {
          do {
            try SMAppService.mainApp.toggle()
              print("SMAppService toggle..")
          } catch {
              print("SMAppService error...\(error.localizedDescription)")
          }
        }
        
        statusBarMenu.addItem(launchAtLoginItem)
        statusBarMenu.addItem(menuItemGitHub)
        statusBarMenu.addItem(menuItemAboutLunarBar)
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(withTitle: "📋 下面是你的剪切板历史内容,点击即可复制", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(withTitle: "⌨️ 同时按下command+control+options键激活", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(infoItem)
        statusBarMenu.addItem(withTitle: "============↓↓↓ 分隔 ↓↓↓============", action: nil, keyEquivalent: "")
        statusBarMenu.addItem(NSMenuItem.separator())
        
        reloadInfoItem()
    }
    
    private func reloadInfoItem() {
        print("Reloading info item...")
        let text = "ℹ️ 目前总条数: \(self.dbManger.readHistory().count) , 数据库大小: " + self.dbManger.getDBFileSize()
        infoItem.title = text
        
        launchAtLoginItem.setOn((SMAppService.mainApp.isEnabled))
    }
    
    private func addClipBoardMonitor() {
        print("Adding clipboard monitor...")
        clipboardWorker.startListening()
        clipboardWorker.onNewCopy { [weak self] content in
            guard let self = self else { return }
            print("New content copied: \(content)")
            if self.statusBarMenu.items.count >= self.fixedMenuItemCount, self.dbManger.addContent(content: content) {
                self.statusBarMenu.insertItem(withTitle: content, action: #selector(self.copyToClipboard), keyEquivalent: "", at: self.fixedMenuItemCount)
            }
        }
    }
    
    /// 初始化状态栏按钮
    func initStatusBar() {
        print("Initializing status bar...")
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = "🌯"
        statusBarItem.menu = statusBarMenu
        
        self.resetDefaultItems()
    }
    
    var menuItemGitHub: NSMenuItem {
        let item = NSMenuItem(title: "🔗 Github")
        item.addAction {
            print("Opening Github link...")
            NSWorkspace.shared.safelyOpenURL(string: "https://github.com/sushushu/copy")
        }
        return item
    }
    
    var menuItemAboutLunarBar: NSMenuItem {
        let item = NSMenuItem(title: "💊 关于Kao!")
        item.addAction {
            print("Opening About panel...")
            NSApp.activate(ignoringOtherApps: true)
            NSApp.orderFrontStandardAboutPanel()
        }
        return item
    }

    var menuItemLaunchAtLogin: NSMenuItem {
      let item = NSMenuItem(title: "登录时启动")
//      item.setOn(SMAppService.mainApp.isEnabled)
//        item.setOn(true)
      item.addAction {
        do {
          try SMAppService.mainApp.toggle()
            print("SMAppService toggle..")
        } catch {
            print("SMAppService error...\(error.localizedDescription)")
        }
      }

      return item
    }
    
    // MARK: - Privete
    @objc private func copyToClipboard(sender: NSMenuItem) {
        let title = sender.title
        clipboardWorker.copy(string: title)
        print("Copying the value: \(title) to clipboard")
    }
    
    @objc func exitApp() {
        print("Exiting app...")
        NSApplication.shared.terminate(nil)
    }
    
    @objc func clearAll() {
        print("Clearing all content...")
        if self.dbManger.clearContentTable() {
            print("Content cleared successfully")
            resetDefaultItems()
        } else {
            print("Failed to clear content")
        }
    }
    
    // MARK: - Obsv
    // 监听按钮激活
    private func addGlobalKeyboardMonitor() {
        print("Adding global keyboard monitor...")
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            guard let self = self else { return }
            if event.modifierFlags.contains([.command, .control, .option]) {
                print("Global keyboard shortcut detected, showing menu...")
                self.statusBarItem.popUpMenu(self.statusBarMenu)
            }
        }
    }
    
    // MARK: - NSMenuDelegate
    func menuWillOpen(_ menu: NSMenu) {
        print("Menu will open, reloading info item...")
        reloadInfoItem()
    }
}

