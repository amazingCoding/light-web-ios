#
# Be sure to run `pod lib lint LightWebCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LightWebCore'
  s.version          = '0.1.0'
  s.summary          = 'a web app core.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/sanyuelanv/LightWebCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sanyuelanv' => 'sanylanv@gmail.com' }
  s.source           = { :git => 'https://github.com/sanyuelanv/LightWebCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '9.0'

  s.source_files = 'LightWebCore/Classes/**/*'
  s.frameworks = 'UIKit'
  s.frameworks = 'WebKit'
  s.frameworks = 'AudioToolbox'
  s.dependency 'SSZipArchive', '~> 2.1.4'
  s.resource_bundles = {
    'LightWebCore' => ['LightWebCore/Assets/*.xcassets','LightWebCore/Assets/*.js']
  }
  
  # s.resource_bundles = {
  #   'LightWebCore' => ['LightWebCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
