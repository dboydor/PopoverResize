Pod::Spec.new do |s|
  s.name         = "PopoverResize"
  s.version      = "1.0"
  s.summary      = "A resizable NSPopover implementation written in Swift"
  s.description  = <<-DESC
                    This framework allows you to drag-resize a NSPopover window
                    This framework supports macOS 10.11+, Xcode 9 and Swift 4.
                   DESC
  s.homepage     = "https://github.com/dboydor/PopoverResize"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  s.author       = { "David Boyd" => "dboydor@me.com" }
  s.osx.deployment_target = "10.11"
  s.source       = { :git => "https://github.com/dboydor/PopoverResize.git" }
  s.source_files = "PopoverResize/PopoverResize"
  s.resource     = "PopoverResize/PopoverResize/resources"
end
