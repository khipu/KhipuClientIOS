#
# Be sure to run `pod lib lint KhipuClientIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KhipuClientIOS'
  s.version          = '0.1.0'
  s.summary          = 'A short description of KhipuClientIOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Emilio Davis/KhipuClientIOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Emilio Davis' => 'emilio.davis@khipu.com' }
  s.source           = { :git => 'https://github.com/Emilio Davis/KhipuClientIOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'KhipuClientIOS/Classes/**/*'
  s.resources = 'KhipuClientIOS/Assets/**/*.{xcassets,json,ttf,html,js,css}'

  s.dependency 'Socket.IO-Client-Swift'
  s.dependency 'KhenshinSecureMessage'
  s.dependency 'KhenshinProtocol', '1.0.42'
end
