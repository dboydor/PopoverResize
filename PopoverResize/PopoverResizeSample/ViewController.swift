//
//  ViewController.swift
//  PopoverResizeSample
//
//  Created by David Boyd on 10/28/18.
//  Copyright © 2018 David Boyd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

// --------------------------------------------
//  Creation factory
// --------------------------------------------
extension ViewController {
    static func create() -> ViewController {
        let id = "ViewController"
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: id)
        guard let controller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Where is \(id)? - Check Main.storyboard")
        }
        
        return controller
    }
}

