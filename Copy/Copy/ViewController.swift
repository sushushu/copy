//
//  ViewController.swift
//  Copy
//
//  Created by Jianzhimao on 2020/7/22.
//  Copyright © 2020 Jianzhimao. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.toolTip = "aaa"
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

