//
//  AppDelegate.swift
//  PopoverResizeSample
//
//  Created by David Boyd on 10/28/18.
//  Copyright © 2018 David Boyd. All rights reserved.
//

import Cocoa
import PopoverResize

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let popover: PopoverResize
    private let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    override init() {
        let min = NSSize(width: CGFloat(150), height: CGFloat(50))
        let max = NSSize(width: CGFloat(800), height: CGFloat(0))
        popover = PopoverResize(min: min, max: max)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setMenuIcon()
        
        popover.appearance = NSAppearance(named: .aqua)
        popover.animates = false
        popover.setContentViewController(ViewController.create())
        popover.resized {(size: NSSize) in
            print("Popover resized: \(size)")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func setMenuIcon() {
        if let button = statusItem.button {
            let icon = "StatusBarIcon"
            button.image = NSImage(named:NSImage.Name(icon))
            button.action = #selector(togglePopover(_:))
        }
    }
    
    @objc private func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    private func showPopover(sender: Any?) {
        if let button = statusItem.button {
            NSRunningApplication.current.activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
            
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    private func closePopover(sender: Any?) {
        self.popover.close()
    }
    
}


