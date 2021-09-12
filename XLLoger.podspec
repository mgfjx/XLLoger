@version = "0.0.1"

Pod::Spec.new do |spec|
  spec.name         = "XLLoger"
  spec.version      = @version
  spec.summary      = "A float UI log viewer for device."
  spec.description  = "It will automatically obtain log information and display it in textview."
  spec.homepage     = "https://github.com/mgfjx/XLLoger"
  spec.license       = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "mgfjx" => "mgfjxxiexiaolong@gmail.com" }
  spec.social_media_url   = "https://github.com/mgfjx"
  spec.platform     = :ios, "8.0"
  spec.ios.deployment_target = "8.0"
  spec.source       = { :git => "https://github.com/mgfjx/XLLoger.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "XLLoger/**/*.{h,m}"
  spec.public_header_files = "XLLoger/*.h"
  spec.requires_arc = true
  spec.framework     = "UIKit"

end
