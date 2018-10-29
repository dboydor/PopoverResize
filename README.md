**PopoverResize** adds the ability to resize a NSPopover.  It shows resize icons when you hover over the edges of the popover window, indicating to the user they can resize.

[![Watch the video](https://img.youtube.com/vi/T-D1KVIuvjA/maxresdefault.jpg)](https://youtu.be/T-D1KVIuvjA)

### How to use PopoverResize

1\. Import the framework:
```swift
@import PopoverResize
```
2\. Create the PopoverResize instance, giving it a minimum and maximum size. The CGFloat(0) indicates to use the current screen's height.

```swift
let min = NSSize(width: CGFloat(150), height: CGFloat(50))
let max = NSSize(width: CGFloat(800), height: CGFloat(0))
popover = PopoverResize(min: min, max: max)
```

3\. Set the content view controller for the popup.

```swift
popover.setContentViewController(ViewController.create())
```

4\. Set a callback for the resized event

```swift
popover.resized {(size: NSSize) in
    print("Popover resized: \(size)")
}
```

See the PopoverResizeSample app for a complete example.

## Installation

PopoverResize can be installed with [CocoaPods](https://cocoapods.org/).

### CocoaPods

Add this to your Podspec:
```
pod 'PopoverResize'
```

Then run `pod install`.

### License

The MIT License (MIT)

Copyright (c) 2018 David Boyd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
