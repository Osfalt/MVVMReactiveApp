
Pod::Spec.new do |s|

  s.name             = 'APIKit'
  s.version          = '0.1.0'
  s.summary          = 'API'

  s.homepage         = 'https://github.com/osfalt4@gmail.com/APIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'osfalt4@gmail.com' => 'osfalt4@gmail.com' }
  s.source           = { :git => 'https://github.com/osfalt4@gmail.com/APIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'APIKit/Classes/**/*'
  
  s.dependency 'CoreKit'

end
