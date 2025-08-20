# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GoferHandy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for GoferHandy
  pod 'SocialLoginsIntegration'#,'~> 0.0.8'
  pod 'PaymentHelper','~> 0.0.6'
  
  pod 'AGPullView'
  pod 'GoogleMaps'#,'~> 3.5.0'
  pod 'GooglePlaces','~> 3.5.0'
  
  pod 'SDWebImage'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Database'
  pod 'GeoFire'
  pod 'Alamofire'
  pod 'TTTAttributedLabel'
#  pod 'SinchRTC'
  pod 'SinchVerification'       # <- NOT FOR VOICE/CALLS
  pod 'SinchRTC'                # <- FOR VOICE & VIDEO
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Auth'
  pod 'lottie-ios', '~> 3.1'
  pod 'IQKeyboardManagerSwift'
  
  pod 'Firebase/Firestore'
  pod 'Firebase/RemoteConfig'
  pod 'ARCarMovement', '~> 2.1.1'
  pod 'OTPFieldView'
  
  pod 'StripeApplePay'
  
#  pod 'gRPC-C++', '~> 1.62.0'
  pod 'gRPC-ProtoRPC'#, '~> 1.62.0'
  pod 'gRPC-RxLibrary'#, '~> 1.62.0'
  pod 'gRPC-Core'#, '~> 1.62.0'
  pod 'Protobuf'#, '~> 3.24'
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
  
  target 'GoferHandyTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'GoferHandyUITests' do
    # Pods for testing
  end
  
end
