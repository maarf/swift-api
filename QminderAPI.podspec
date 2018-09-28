Pod::Spec.new do |s|
  s.name             = 'QminderAPI'
  s.version          = '1.8.1'
  s.summary          = 'Qminder iOS API'

  s.description      = <<-DESC
  Swift wrapper for Qminder API
                       DESC

  s.homepage         = 'https://www.qminder.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Qminder Ltd.' => 'info@qminder.com' }
  s.social_media_url = 'https://www.facebook.com/QMinder/'
  s.source           = { :git => 'https://github.com/Qminder/swift-api.git', :tag => s.version.to_s }

  s.source_files = "QminderAPI/Classes/*.swift"

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'Sources/**/*.swift'

  s.dependency 'Starscream', '~> 3.0'

  s.swift_version = "4.2"

end
