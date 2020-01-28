platform :ios, '11.0'
use_frameworks!

def shared_pods

  # third-party pods
  pod 'ReactiveCocoa', '~> 10.2'

  # development pods
  pod 'CoreKit', path: 'DevelopmentPods/CoreKit'
  pod 'APIKit', path: 'DevelopmentPods/APIKit'
  pod 'PersistentStorageKit', path: 'DevelopmentPods/PersistentStorageKit'
  pod 'ServiceKit', path: 'DevelopmentPods/ServiceKit'

end

target 'MVVMReactiveApp' do

  shared_pods

  # development pods
  pod 'CoreUIKit', path: 'DevelopmentPods/CoreUIKit'

end

target 'MVVMReactiveAppTests' do

  shared_pods

end
