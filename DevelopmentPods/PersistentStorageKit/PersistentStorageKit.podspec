
Pod::Spec.new do |s|

  s.name             = 'PersistentStorageKit'
  s.version          = '0.1.0'
  s.summary          = 'Persistent storage, Managed Objects, etc.'

  s.homepage         = 'https://github.com/osfalt4@gmail.com/PersistentStorageKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'osfalt4@gmail.com' => 'osfalt4@gmail.com' }
  s.source           = { :git => 'https://github.com/osfalt4@gmail.com/PersistentStorageKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.source_files = 'PersistentStorageKit/Classes/**/*'
  s.resources = 'PersistentStorageKit/Model/**/*'
  
  s.dependency 'CoreKit'

end
