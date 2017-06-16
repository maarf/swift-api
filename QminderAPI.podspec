Pod::Spec.new do |s|
  s.name             = 'QminderAPI'
  s.version          = '0.1.35'
  s.summary          = 'Qminder iOS API'

  s.description      = <<-DESC
  iOS wrapper for Qminder API.
                       DESC

  s.homepage         = 'https://www.qminderapp.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Qminder Ltd.' => 'info@qminderapp.com' }
  s.social_media_url = 'https://www.facebook.com/QMinder/'
  s.source           = { :git => 'https://github.com/Qminder/swift-api.git', :tag => s.version.to_s }
  
  s.source_files = "QminderAPI/Classes/*.swift"
  
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'QminderAPI/Classes/**/*'

  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'SwiftyJSON', '~> 3.1'
  s.dependency 'Starscream', '~> 2.0'
  s.dependency 'ObjectMapper', '~> 2.2'
  s.dependency 'RxSwift', '~> 3.4'
  
end
