
Pod::Spec.new do |s|

  s.name             = 'CoreUIKit'
  s.version          = '0.1.0'
  s.summary          = 'Custom views, UIKit extensions, etc.'

  s.homepage         = 'https://github.com/osfalt4@gmail.com/CoreUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'osfalt4@gmail.com' => 'osfalt4@gmail.com' }
  s.source           = { :git => 'https://github.com/osfalt4@gmail.com/CoreUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'CoreUIKit/Classes/**/*'

  s.dependency 'ReactiveCocoa'

end
