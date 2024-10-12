#
# Be sure to run `pod lib lint LeigodAPM.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LeigodAPM'
  s.version          = '0.1.3'
  s.summary          = 'A short description of LeigodAPM.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xyk/LeigodAPM'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xyk' => 'xiayukun@nn.com' }
  s.source           = { :git => 'https://github.com/xyk/LeigodAPM.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.source_files = 'LeigodAPM/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LeigodAPM' => ['LeigodAPM/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'WCDB.swift', '~> 1.1.0'
   s.dependency 'SnapKit'
#   s.dependency 'NNKit'
   
end
