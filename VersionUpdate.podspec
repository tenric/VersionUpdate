#
#  Be sure to run `pod spec lint VersionUpdate.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "VersionUpdate"
  s.version      = "1.0.1"
  s.summary      = "Check and update app's version for both AppStore & Fir."
  s.homepage     = "https://github.com/tenric/VersionUpdate"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "tenric" => "minjieni@vip.qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tenric/VersionUpdate.git", :tag => s.version.to_s }
  s.source_files  = "VersionUpdate/*"
  s.requires_arc = true

end
