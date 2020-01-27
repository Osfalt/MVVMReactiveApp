
Pod::Spec.new do |s|

  s.name             = 'ServiceKit'
  s.version          = '0.1.0'
  s.summary          = 'Services for app.'

  s.homepage         = 'https://github.com/osfalt4@gmail.com/ServiceKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'osfalt4@gmail.com' => 'osfalt4@gmail.com' }
  s.source           = { :git => 'https://github.com/osfalt4@gmail.com/ServiceKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'ServiceKit/Classes/**/*'

  s.dependency 'ReactiveSwift'
  s.dependency 'CoreKit'
  s.dependency 'APIKit'
  s.dependency 'PersistentStorageKit'

end
