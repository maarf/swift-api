#
# Be sure to run `pod lib lint QminderTV.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QminderAPI'
  s.version          = '0.1.0'
  s.summary          = 'Qminder iOS API'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  iOS wrapper for Qminder API.
                       DESC

  s.homepage         = 'https://www.qminderapp.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kristaps Grinbergs' => 'kristaps@qminderapp.com' }
  s.source           = { :git => 'https://github.com/Qminder/qminder-ios-api.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'

  s.source_files = 'QminderAPI/Classes/**/*'
  
  # s.resource_bundles = {
  #   'QminderTV' => ['QminderTV/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'Alamofire', '~> 4.2'
  s.dependency 'SwiftyJSON', '~> 3.1'
  s.dependency 'Starscream', '~> 2.0'
end
