#
# Be sure to run `pod lib lint BXPhotoViewer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BXPhotoViewer"
  s.version          = "1.0.0"
  s.summary          = "BXPhotoViewer is a simple Photo Viewer ViewController "

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
BXPhotoViewer is a simple Photo Viewer ViewController
One for viewer simgle Photo,One for browser a set of Phtos.
                       DESC

  s.homepage         = "https://github.com/banxi1988/BXPhotoViewer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "banxi1988" => "banxi1988@gmail.com" }
  s.source           = { :git => "https://github.com/banxi1988/BXPhotoViewer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/banxi1988'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'BXPhotoViewer' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'PinAutoLayout'
end
