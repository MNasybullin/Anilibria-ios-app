platform :ios, '15.0'
use_frameworks!

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end


target 'Anilibria-ios-app' do
    pod 'SwiftGen', '~> 6.6.2'
    pod 'SwiftLint', '~> 0.54.0'
    pod 'SkeletonView', :inhibit_warnings => true, :git => 'https://github.com/MNasybullin/SkeletonView', :branch => 'anilibria'
    pod 'FDFullscreenPopGesture', '1.1'
    
    # Add the Firebase pod for Google Analytics
    pod 'FirebaseAnalytics'
    pod 'FirebaseCrashlytics'
    pod 'FirebaseRemoteConfig'

  # Pods for Anilibria-ios-app

  target 'SecurityStorageTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'APITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
