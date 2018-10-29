//
//  PopoverResize.swift
//  PopoverResize
//
//  Created by David Boyd on 10/26/18.
//  Copyright © 2018 David Boyd. All rights reserved.
//

import Cocoa

public class PopoverResize: NSPopover {
    let SIDES_HIT = CGFloat(4)
    let BOTTOM_HIT = CGFloat(4)
    let CORNER_HIT = CGFloat(10)
    
    private enum Region {
        case None
        case Left
        case LeftBottom
        case Bottom
        case Right
        case RightBottom
    }
    
    private var min: NSSize
    private var max: NSSize
    private var bottomHeight = CGFloat(20)
    private var region: Region = .None
    private var down: NSPoint?
    private var size: NSSize?
    private var trackLeft: NSView.TrackingRectTag?
    private var trackRight: NSView.TrackingRectTag?
    private var trackLeftBottom: NSView.TrackingRectTag?
    private var trackRightBottom: NSView.TrackingRectTag?
    private var trackBottom: NSView.TrackingRectTag?
    private var sizeChanged: ((_ size: NSSize) -> Void)? = nil
    
    private let cursorLeftRight = PopoverResize.getCursor("resizeeastwest")
    private let cursorLeftBottom = PopoverResize.getCursor("resizenortheastsouthwest")
    private let cursorRightBottom = PopoverResize.getCursor("resizenorthwestsoutheast")
    private let cursorUpDown = PopoverResize.getCursor("resizenorthsouth")
    
    // min: the mimimum size the popover is allowed to be
    // max: the maximum size the popover is allowed to be
    // heightFromBottom: Set this to limit the draggable handle region
    //                   to a height starting from the bottom of the popover
    //                   If 0, then it uses the entire height of popover
    public init(min: NSSize, max: NSSize, heightFromBottom: CGFloat = 0) {
        self.min = min
        self.max = max
        self.bottomHeight = heightFromBottom

        // If not defined, use the screen height minus magic #
        if self.max.height == 0 {
            self.max.height = CGFloat(NSScreen.screens[0].frame.height - 110)
        }
        
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        clearTrackers()
    }
    
    // Call this to get notified anytime the popover is resized
    public func resized(_ sizeChanged: @escaping (_ size: NSSize) -> Void) {
        self.sizeChanged = sizeChanged
    }
    
    public func setContentViewController(_ controller: NSViewController, initialSize: NSSize? = nil) {
        contentViewController = controller

        if let size = initialSize {
            contentSize = size
        } else {
            contentSize = NSSize(width: controller.view.bounds.width, height: controller.view.bounds.height)
        }
        
        if bottomHeight == 0 {
            bottomHeight = contentSize.height
        }
        
        setTrackers()
    }
    
    override public func mouseEntered(with event: NSEvent) {
        if region == .None {
            if event.trackingNumber == trackLeft {
                region = .Left
            } else if event.trackingNumber == trackRight {
                region = .Right
            } else if event.trackingNumber == trackLeftBottom {
                region = .LeftBottom
            } else if event.trackingNumber == trackRightBottom {
                region = .RightBottom
            } else if event.trackingNumber == trackBottom {
                region = .Bottom
            } else {
                region = .None
            }
            
            setCursor()
        }
    }
    
    override public func mouseExited(with event: NSEvent) {
        if down == nil {
            region = .None
            setCursor()
        }
    }

    override public func mouseDown(with event: NSEvent) {
        self.size = contentSize
        self.down = NSEvent.mouseLocation
        
//        print("REGION: \(String(describing: region))")
//        print("DOWN: \(String(describing: down))")
//        print("SIZE: \(String(describing: self.contentSize))")
    }
    
    override public func mouseDragged(with event: NSEvent) {
        if region == .None {
            return
        }

        guard let size = size else { return }
        guard let down = down else { return }
        
        let location = NSEvent.mouseLocation
        
        var movedX = (location.x - down.x) * 2
        let movedY = location.y - down.y
//        print("MOVE x: \(movedX), y: \(movedY)")
        
        if region == .Left || region == .LeftBottom {
            movedX = -movedX
        }
        
        var newWidth = size.width + movedX
        if newWidth < min.width {
            newWidth = min.width
        } else if newWidth > max.width {
            newWidth = max.width
        }
        
        var newHeight = size.height - movedY
        if newHeight < min.height {
            newHeight = min.height
        } else if newHeight > max.height {
            newHeight = max.height
        }
        
        switch region {
            case .Left: fallthrough
            case .Right:
                contentSize = NSSize(width: newWidth, height: contentSize.height)
            case .LeftBottom: fallthrough
            case .RightBottom:
                contentSize = NSSize(width: newWidth, height: newHeight)
            case .Bottom:
                contentSize = NSSize(width: contentSize.width, height: newHeight)
            default:
                ()
        }
        
        setCursor()
    }
    
    override public func mouseUp(with event: NSEvent) {
        if region != .None {
            region = .None
            setCursor()
            setTrackers()
            down = nil
            
            if let onChanged = sizeChanged {
                onChanged(NSSize(width: contentSize.width, height: contentSize.height))
            }
        }
    }
    
    private func setCursor(){
        switch region {
            case .Left: fallthrough
            case .Right:
                cursorLeftRight.set()
            
            case .LeftBottom:
                cursorLeftBottom.set()
            
            case .RightBottom:
                cursorRightBottom.set()
            
            case .Bottom:
                cursorUpDown.set()
            
            default:
                NSCursor.arrow.set()
        }
    }
    
    private func setTrackers() {
        clearTrackers()
        
        if let view = contentViewController?.view {
            var bounds = NSRect(x: 0, y: CORNER_HIT, width: SIDES_HIT, height: bottomHeight - CORNER_HIT)
            trackLeft = view.addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)

            bounds = NSRect(x: contentSize.width - SIDES_HIT, y: CORNER_HIT, width: SIDES_HIT, height: bottomHeight - CORNER_HIT)
            trackRight = view.addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)

            bounds = NSRect(x: 0, y: 0, width: CORNER_HIT, height: CORNER_HIT)
            trackLeftBottom = view.addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)

            bounds = NSRect(x: contentSize.width - CORNER_HIT, y: 0, width: CORNER_HIT, height: CORNER_HIT)
            trackRightBottom = view.addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)

            bounds = NSRect(x: CORNER_HIT, y: 0, width: contentSize.width - CORNER_HIT * 2, height: BOTTOM_HIT)
            trackBottom = view.addTrackingRect(bounds, owner: self, userData: nil, assumeInside: false)
        }
    }
    
    private func clearTrackers() {
        if let view = contentViewController?.view, let left = trackLeft, let right = trackRight, let leftBottom = trackLeftBottom, let rightBottom = trackRightBottom, let bottom = trackBottom {
            view.removeTrackingRect(left)
            view.removeTrackingRect(right)
            view.removeTrackingRect(rightBottom)
            view.removeTrackingRect(leftBottom)
            view.removeTrackingRect(bottom)
        }
    }

    private static func getCursor(_ name: String) -> NSCursor {
        var cursor = NSCursor.arrow
        let bundle = Bundle(for: self)
        
        if let pdf = bundle.path(forResource: "\(name)_cursor", ofType: "pdf"),
            let info = bundle.path(forResource: "\(name)_info", ofType: "plist") {
            
            let image = NSImage(byReferencingFile: pdf)
            let info = NSDictionary(contentsOfFile: info)
            cursor = NSCursor(image: image!, hotSpot: NSPoint(x: (info!.value(forKey: "hotx")! as AnyObject).doubleValue!, y: (info!.value(forKey: "hoty")! as AnyObject).doubleValue!))
        }
        
        return cursor
    }
}
