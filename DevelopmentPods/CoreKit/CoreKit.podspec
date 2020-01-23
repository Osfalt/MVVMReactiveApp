
Pod::Spec.new do |s|

  s.name             = 'CoreKit'
  s.version          = '0.1.0'
  s.summary          = 'Models, Foundation extensions, etc.'

  s.homepage         = 'https://github.com/osfalt4@gmail.com/CoreKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'osfalt4@gmail.com' => 'osfalt4@gmail.com' }
  s.source           = { :git => 'https://github.com/osfalt4@gmail.com/CoreKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'CoreKit/Classes/**/*'

  s.dependency 'ReactiveSwift'

end
